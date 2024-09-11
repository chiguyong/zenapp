import SwiftUI

struct PomodoroTimerView: View {
    @ObservedObject var viewModel: PomodoroViewModel
    
    var body: some View {
        VStack {
            Text(timeString(from: viewModel.timeRemaining))
                .font(.largeTitle)
                .padding()
            
            HStack {
                Button(action: {
                    viewModel.isRunning.toggle()
                }) {
                    Text(viewModel.isRunning ? "暂停" : "开始")
                }
                .padding()
                
                Button(action: {
                    viewModel.resetTimer()
                }) {
                    Text("重置")
                }
                .padding()
            }
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
