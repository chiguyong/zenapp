import SwiftUI

class PomodoroViewModel: ObservableObject {
    @Published var timeRemaining: Int = 0
    @Published var isRunning = false
    @Published var isWorking = true
    @Published var completedCycles = 0
    @Published var todayCompletedPomodoros = 0
    @Published var weekCompletedPomodoros = 0
    
    var progress: Double {
        let totalTime = isWorking ? workDuration : (completedCycles % cyclesBeforeLongBreak == 0 ? longBreakDuration : shortBreakDuration)
        return Double(totalTime - timeRemaining) / Double(totalTime)
    }
    
    var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private var timer: Timer?
    @AppStorage("workDuration") private var workDurationMinutes: Int = 25
    @AppStorage("shortBreakDuration") private var shortBreakDurationMinutes: Int = 5
    @AppStorage("longBreakDuration") private var longBreakDurationMinutes: Int = 15
    @AppStorage("cyclesBeforeLongBreak") private var cyclesBeforeLongBreak: Int = 4

    private var workDuration: Int { workDurationMinutes * 60 }
    private var shortBreakDuration: Int { shortBreakDurationMinutes * 60 }
    private var longBreakDuration: Int { longBreakDurationMinutes * 60 }
    
    init() {
        loadState()
        resetTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(updateSettings), name: .init("PomodoroSettingsChanged"), object: nil)
    }
    
    func toggleTimer() {
        isRunning.toggle()
        if isRunning {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func resetTimer() {
        stopTimer()
        isRunning = false
        isWorking = true
        timeRemaining = workDuration
    }
    
    func skipPhase() {
        if isWorking {
            completedCycles += 1
            todayCompletedPomodoros += 1
            weekCompletedPomodoros += 1
            isWorking = false
            timeRemaining = completedCycles % cyclesBeforeLongBreak == 0 ? longBreakDuration : shortBreakDuration
        } else {
            isWorking = true
            timeRemaining = workDuration
        }
        if isRunning {
            stopTimer()
            startTimer()
        }
        saveState()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            skipPhase()
        }
    }
    
    func saveState() {
        let defaults = UserDefaults.standard
        defaults.set(todayCompletedPomodoros, forKey: "todayCompletedPomodoros")
        defaults.set(weekCompletedPomodoros, forKey: "weekCompletedPomodoros")
    }
    
    private func loadState() {
        let defaults = UserDefaults.standard
        todayCompletedPomodoros = defaults.integer(forKey: "todayCompletedPomodoros")
        weekCompletedPomodoros = defaults.integer(forKey: "weekCompletedPomodoros")
    }
    
    @objc private func updateSettings() {
        if !isRunning {
            resetTimer()
        }
    }
}
