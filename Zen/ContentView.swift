import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedView: String? = "pomodoro"
    @StateObject private var pomodoroViewModel = PomodoroViewModel()
    @Environment(\.managedColorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 0) {
            // 左侧菜单
            VStack(spacing: 10) {
                MenuButton(title: "专注", imageName: "timer", tag: "pomodoro")
                MenuButton(title: "白噪音", imageName: "waveform", tag: "whitenoise")
                MenuButton(title: "设置", imageName: "gear", tag: "settings")
                Spacer()
            }
            .frame(width: 70)
            .padding(.top, 20)
            .background(Color(NSColor.windowBackgroundColor))

            // 右侧内容区域
            Group {
                if selectedView == "pomodoro" {
                    PomodoroView(viewModel: pomodoroViewModel)
                } else if selectedView == "whitenoise" {
                    WhiteNoisePlayerView(viewModel: WhiteNoiseViewModel())
                } else if selectedView == "settings" {
                    SettingsView()
                } else {
                    Text("选择一个功能开始")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 600, height: 400)
        .managedColorScheme($appState.effectiveColorScheme)
        .onChange(of: colorScheme) { oldValue, newValue in
            print("ContentView detected colorScheme change: \(oldValue) -> \(newValue)")
        }
    }

    private func MenuButton(title: String, imageName: String, tag: String) -> some View {
        Button(action: {
            selectedView = tag
        }) {
            VStack {
                Image(systemName: imageName)
                    .font(.system(size: 24))
                Text(title)
                    .font(.caption2)
            }
            .frame(width: 60, height: 60)
        }
        .buttonStyle(PlainButtonStyle())
        .background(selectedView == tag ? Color.accentColor.opacity(0.2) : Color.clear)
        .cornerRadius(8)
    }
}
