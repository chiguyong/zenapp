import SwiftUI
import SwiftData
import ObjectiveC

@main
struct ZenApp: App {
    @StateObject private var appState = AppState()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isInitialized = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PomodoroSession.self,
            WhiteNoiseSettings.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(isInitialized ? appState.effectiveColorScheme : nil)
                .onAppear {
                    DispatchQueue.main.async {
                        self.isInitialized = true
                        (NSApplication.shared.delegate as? AppDelegate)?.appState = self.appState
                        (NSApplication.shared.delegate as? AppDelegate)?.updateAppAppearance()
                    }
                }
                .modifier(ColorSchemeChangeModifier(appState: appState))
        }
        .modelContainer(sharedModelContainer)
        .handlesExternalEvents(matching: Set(arrayLiteral: "mainWindow"))
        .commands {
            CommandGroup(replacing: .newItem, addition: { })
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .defaultSize(width: 600, height: 400)
    }
}

struct ColorSchemeChangeModifier: ViewModifier {
    @ObservedObject var appState: AppState

    func body(content: Content) -> some View {
        content
            #if compiler(>=5.9) // Swift 5.9 corresponds to Xcode 15 and macOS 14
            .onChange(of: appState.effectiveColorScheme) { oldValue, newValue in
                (NSApplication.shared.delegate as? AppDelegate)?.updateAppAppearance()
            }
            #else
            .onChange(of: appState.effectiveColorScheme) { newValue in
                (NSApplication.shared.delegate as? AppDelegate)?.updateAppAppearance()
            }
            #endif
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    var mainWindow: NSWindow?
    weak var appState: AppState?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarController = StatusBarController(appDelegate: self)
        
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first {
                self.mainWindow = window
                self.configureMainWindow()
            }
        }
        
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(systemAppearanceChanged),
            name: Notification.Name("AppleInterfaceThemeChangedNotification"),
            object: nil
        )
        
        updateAppAppearance()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    func toggleMainWindow() {
        if let window = mainWindow {
            if window.isVisible {
                window.orderOut(nil)
                NSApp.setActivationPolicy(.accessory)
            } else {
                window.makeKeyAndOrderFront(nil)
                NSApp.setActivationPolicy(.regular)
            }
        } else {
            NSWorkspace.shared.open(URL(string: "zen://mainWindow")!)
        }
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func configureMainWindow() {
        guard let window = mainWindow else { return }
        
        window.title = "Zen"
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.setFrameAutosaveName("Main Window")
        
        if let screenFrame = NSScreen.main?.visibleFrame {
            let windowFrame = NSRect(x: screenFrame.midX - 200, y: screenFrame.midY - 200, width: 400, height: 400)
            window.setFrame(windowFrame, display: true)
        }
        
        window.makeKeyAndOrderFront(nil)
        NSApp.setActivationPolicy(.regular)
    }
    
    @objc func systemAppearanceChanged() {
        DispatchQueue.main.async { [weak self] in
            self?.appState?.updateColorScheme()
            self?.updateAppAppearance()
        }
    }

    func updateAppAppearance() {
        if let effectiveAppearance = appState?.effectiveColorScheme {
            NSApp.appearance = NSAppearance(named: effectiveAppearance == .dark ? .darkAqua : .aqua)
        }
    }
}
