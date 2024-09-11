import Foundation
import SwiftData

@Model
final class WhiteNoiseSettings {
    var id: UUID
    var name: String
    var isActive: Bool
    var volume: Double
    
    init(id: UUID = UUID(), name: String, isActive: Bool = false, volume: Double = 0.5) {
        self.id = id
        self.name = name
        self.isActive = isActive
        self.volume = volume
    }
}
