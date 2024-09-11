import SwiftUI
import Combine

enum ColorSchemeSelection: Int, Codable {
    case system = 0
    case light = 1
    case dark = 2
}

@MainActor
class AppState: ObservableObject {
    @Published var colorSchemeSelection: ColorSchemeSelection {
        didSet {
            UserDefaults.standard.set(colorSchemeSelection.rawValue, forKey: "colorSchemeSelection")
            updateEffectiveColorScheme()
        }
    }
    
    @Published var effectiveColorScheme: ColorScheme {
        didSet {
            print("EffectiveColorScheme set to: \(effectiveColorScheme)")
        }
    }
    
    private var systemColorSchemeObserver: AnyCancellable?
    
    init() {
        let savedSelection = UserDefaults.standard.integer(forKey: "colorSchemeSelection")
        self.colorSchemeSelection = ColorSchemeSelection(rawValue: savedSelection) ?? .system
        self.effectiveColorScheme = .light
        
        updateEffectiveColorScheme()
        observeSystemColorScheme()
        
        print("AppState initialized with colorSchemeSelection: \(colorSchemeSelection), effectiveColorScheme: \(effectiveColorScheme)")
    }
    
    func updateEffectiveColorScheme() {
        let newColorScheme: ColorScheme
        switch colorSchemeSelection {
        case .light:
            newColorScheme = .light
        case .dark:
            newColorScheme = .dark
        case .system:
            newColorScheme = getCurrentSystemColorScheme()
        }
        
        if newColorScheme != effectiveColorScheme {
            effectiveColorScheme = newColorScheme
            print("EffectiveColorScheme updated to: \(effectiveColorScheme)")
            NotificationCenter.default.post(name: .effectiveColorSchemeDidChange, object: nil)
        }
    }
    
    private func getCurrentSystemColorScheme() -> ColorScheme {
        NSApplication.shared.effectiveAppearance.name == .darkAqua ? .dark : .light
    }
    
    private func observeSystemColorScheme() {
        systemColorSchemeObserver = DistributedNotificationCenter.default().publisher(for: .init("AppleInterfaceThemeChangedNotification"), object: nil)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateEffectiveColorScheme()
            }
    }
}

extension Notification.Name {
    static let effectiveColorSchemeDidChange = Notification.Name("effectiveColorSchemeDidChange")
}
