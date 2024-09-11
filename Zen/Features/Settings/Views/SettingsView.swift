import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.colorScheme) private var systemColorScheme
    
    var body: some View {
        Form {
            Section(header: Text("主题设置").font(.headline)) {
                Picker("颜色主题", selection: Binding(
                    get: {
                        appState.colorSchemeRawValue
                    },
                    set: { newValue in
                        switch newValue {
                        case 0:
                            appState.setColorScheme(nil)
                        case 1:
                            appState.setColorScheme(.light)
                        case 2:
                            appState.setColorScheme(.dark)
                        default:
                            break
                        }
                    }
                )) {
                    Text("跟随系统").tag(0)
                    Text("浅色").tag(1)
                    Text("深色").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
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
        .preferredColorScheme(appState.effectiveColorScheme)
    }
}
