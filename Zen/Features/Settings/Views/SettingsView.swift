import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("主题设置").font(.headline)) {
                ColorSchemeSettingView()
            }
            .padding(.bottom, 20)
            
            Section(header: Text("番茄钟设置").font(.headline)) {
                Stepper("工作时长: \(viewModel.workDuration) 分钟", value: $viewModel.workDuration, in: 1...60)
                Stepper("短休息时长: \(viewModel.shortBreakDuration) 分钟", value: $viewModel.shortBreakDuration, in: 1...30)
                Stepper("长休息时长: \(viewModel.longBreakDuration) 分钟", value: $viewModel.longBreakDuration, in: 5...60)
                Stepper("长休息前的工作周期: \(viewModel.cyclesBeforeLongBreak)", value: $viewModel.cyclesBeforeLongBreak, in: 1...10)
            }
        }
        .padding()
    }
}

struct ColorSchemeSettingView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Picker("颜色主题", selection: $appState.colorSchemeSelection) {
            Text("跟随系统").tag(ColorSchemeSelection.system)
            Text("浅色").tag(ColorSchemeSelection.light)
            Text("深色").tag(ColorSchemeSelection.dark)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppState())
    }
}
