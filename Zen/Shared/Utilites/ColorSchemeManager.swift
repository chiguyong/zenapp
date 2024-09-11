import SwiftUI

struct ColorSchemeKey: EnvironmentKey {
    static let defaultValue: ColorScheme = .light
}

extension EnvironmentValues {
    var managedColorScheme: ColorScheme {
        get { self[ColorSchemeKey.self] }
        set { self[ColorSchemeKey.self] = newValue }
    }
}

struct ColorSchemeManager: ViewModifier {
    @Binding var colorScheme: ColorScheme
    
    func body(content: Content) -> some View {
        content
            .environment(\.managedColorScheme, colorScheme)
            .preferredColorScheme(colorScheme)
    }
}

extension View {
    func managedColorScheme(_ colorScheme: Binding<ColorScheme>) -> some View {
        self.modifier(ColorSchemeManager(colorScheme: colorScheme))
    }
}
