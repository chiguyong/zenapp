import SwiftUI

class AppState: ObservableObject {
    @AppStorage("colorScheme") var colorSchemeRawValue: Int = 0 {
        didSet {
            print("colorSchemeRawValue changed to: \(colorSchemeRawValue)")
            updateColorScheme()
        }
    }
    
    @Published var colorScheme: ColorScheme?
    
    var effectiveColorScheme: ColorScheme {
        colorScheme ?? getCurrentSystemColorScheme()
    }
    
    init() {
        print("AppState initialized")
        updateColorScheme()
    }
    
    func updateColorScheme() {
        print("updateColorScheme called")
        switch colorSchemeRawValue {
        case 1:
            colorScheme = .light
        case 2:
            colorScheme = .dark
        default:
            colorScheme = nil
        }
    }
    
    func setColorScheme(_ newScheme: ColorScheme?) {
        print("setColorScheme called with: \(String(describing: newScheme))")
        switch newScheme {
        case .light:
            colorSchemeRawValue = 1
        case .dark:
            colorSchemeRawValue = 2
        case .none:
            colorSchemeRawValue = 0
        @unknown default:
            colorSchemeRawValue = 0
        }
    }
    
    func getCurrentSystemColorScheme() -> ColorScheme {
        guard let appearance = NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) else {
            print("Warning: Unable to determine system appearance, defaulting to light mode")
            return .light
        }
        return appearance == .darkAqua ? .dark : .light
    }
}
