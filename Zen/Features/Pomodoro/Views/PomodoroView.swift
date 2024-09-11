import SwiftUI

struct PomodoroView: View {
    @ObservedObject var viewModel: PomodoroViewModel
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 40)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 15)
                    .opacity(0.3)
                    .foregroundColor(viewModel.isWorking ? .blue : .green)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(viewModel.progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                    .foregroundColor(viewModel.isWorking ? .blue : .green)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: viewModel.progress)
                
                Text(viewModel.timeString)
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
            .frame(width: 250, height: 250)
            .padding(.bottom, 30)
            
            HStack(spacing: 20) {
                Button(action: viewModel.toggleTimer) {
                    Text(viewModel.isRunning ? "暂停" : "开始")
                }
                .buttonStyle(.bordered)
                
                Button("重置", action: viewModel.resetTimer)
                    .buttonStyle(.bordered)
                
                Button("跳过", action: viewModel.skipPhase)
                    .buttonStyle(.bordered)
            }
            .padding(.bottom, 20)
            
            HStack {
                Text("今日完成：\(viewModel.todayCompletedPomodoros)")
                Spacer()
                Text("本周完成：\(viewModel.weekCompletedPomodoros)")
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}
