import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("colorScheme") var colorSchemeRawValue: Int = 0 {
        didSet {
            updateColorScheme()
        }
    }
    @Published var colorScheme: ColorScheme?
    
    @AppStorage("workDuration") var workDuration = 25 {
        didSet { updatePomodoroSettings() }
    }
    @AppStorage("shortBreakDuration") var shortBreakDuration = 5 {
        didSet { updatePomodoroSettings() }
    }
    @AppStorage("longBreakDuration") var longBreakDuration = 15 {
        didSet { updatePomodoroSettings() }
    }
    @AppStorage("cyclesBeforeLongBreak") var cyclesBeforeLongBreak = 4 {
        didSet { updatePomodoroSettings() }
    }
    
    init() {
        updateColorScheme()
    }
    
    private func updateColorScheme() {
        switch colorSchemeRawValue {
        case 1:
            colorScheme = .light
        case 2:
            colorScheme = .dark
        default:
            colorScheme = nil
        }
        NotificationCenter.default.post(name: .init("ColorSchemeChanged"), object: nil)
    }
    
    func setColorScheme(_ newScheme: ColorScheme?) {
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
    
    func updatePomodoroSettings() {
        NotificationCenter.default.post(name: .init("PomodoroSettingsChanged"), object: nil)
    }
}
