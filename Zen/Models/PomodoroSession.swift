import Foundation
import SwiftData

@Model
final class PomodoroSession {
    var id: UUID
    var startTime: Date
    var duration: Int
    var isCompleted: Bool
    
    init(id: UUID = UUID(), startTime: Date = Date(), duration: Int = 25, isCompleted: Bool = false) {
        self.id = id
        self.startTime = startTime
        self.duration = duration
        self.isCompleted = isCompleted
    }
}
