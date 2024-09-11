import SwiftUI

struct WhiteNoisePlayerView: View {
    @ObservedObject var viewModel: WhiteNoiseViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(viewModel.sounds) { sound in
                Button(action: { viewModel.toggleSound(sound) }) {
                    HStack {
                        Text(sound.name)
                        Spacer()
                        Image(systemName: viewModel.isPlaying(sound) ? "pause.circle" : "play.circle")
                    }
                }
                .buttonStyle(.bordered)
            }
            
            VStack {
                Text("音量: \(Int(viewModel.volume * 100))%")
                Slider(value: $viewModel.volume)
            }
        }
        .padding()
    }
}
