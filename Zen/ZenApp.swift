import SwiftUI
import SwiftData

@main
struct ZenApp: App {
    @StateObject private var appState = AppState()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
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
                .environment(\.managedColorScheme, appState.effectiveColorScheme)
                .onAppear {
                    print("ContentView appeared")
                    self.appDelegate.appState = self.appState
                }
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

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    var mainWindow: NSWindow?
    weak var appState: AppState?
    private var colorSchemeObserver: NSObjectProtocol?

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("applicationDidFinishLaunching")
        statusBarController = StatusBarController(appDelegate: self)
        
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first {
                self.mainWindow = window
                self.configureMainWindow()
            }
        }
        
        colorSchemeObserver = NotificationCenter.default.addObserver(forName: .effectiveColorSchemeDidChange, object: nil, queue: .main) { [weak self] _ in
            Task { @MainActor in
                self?.updateWindowAppearance()
            }
        }
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        print("applicationDidBecomeActive")
        Task { @MainActor in
            appState?.updateEffectiveColorScheme()
            updateWindowAppearance()
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        print("applicationWillTerminate")
        if let observer = colorSchemeObserver {
            NotificationCenter.default.removeObserver(observer)
        }
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
                Task { @MainActor in
                    appState?.updateEffectiveColorScheme()
                    updateWindowAppearance()
                }
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
        
        Task { @MainActor in
            updateWindowAppearance()
        }
    }
    
    @MainActor
    private func updateWindowAppearance() {
        guard let window = mainWindow, let appState = appState else { return }
        
        let appearance: NSAppearance
        switch appState.effectiveColorScheme {
        case .light:
            appearance = NSAppearance(named: .aqua)!
        case .dark:
            appearance = NSAppearance(named: .darkAqua)!
        @unknown default:
            appearance = NSAppearance(named: .aqua)!
        }
        
        window.appearance = appearance
    }
}
