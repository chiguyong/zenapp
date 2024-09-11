import SwiftUI

class WhiteNoiseViewModel: ObservableObject {
    @Published var sounds: [Sound] = [
        Sound(name: "白噪音"),
        Sound(name: "雨声"),
        Sound(name: "海浪声")
    ]
    @Published var volume: Double = 0.5
    @Published var playingSound: Sound?
    
    func toggleSound(_ sound: Sound) {
        if playingSound == sound {
            playingSound = nil
        } else {
            playingSound = sound
        }
    }
    
    func isPlaying(_ sound: Sound) -> Bool {
        return playingSound == sound
    }
}

struct Sound: Identifiable, Equatable {
    let id = UUID()
    let name: String
}
