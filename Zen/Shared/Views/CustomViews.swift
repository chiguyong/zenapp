import SwiftUI

// 自定义背景修饰符
struct CustomBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(colorScheme == .dark ? Color(white: 0.1) : Color(white: 0.9))
    }
}

// 自定义文本样式
struct CustomTextStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .font(.system(size: 16, weight: .regular, design: .default))
    }
}

// 自定义按钮样式
struct CustomButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(colorScheme == .dark ? Color.blue.opacity(0.6) : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// 自定义分割线
struct CustomDivider: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Rectangle()
            .fill(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2))
            .frame(height: 1)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

// 扩展 View 以便更容易使用这些自定义修饰符
extension View {
    func customBackground() -> some View {
        self.modifier(CustomBackgroundModifier())
    }
    
    func customTextStyle() -> some View {
        self.modifier(CustomTextStyle())
    }
}
