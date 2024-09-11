import SwiftUI

struct WhiteNoiseView: View {
    @StateObject private var viewModel = WhiteNoiseViewModel()
    @EnvironmentObject private var appState: AppState
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            Text("白噪音")
                .font(.largeTitle)
                .customTextStyle()
            
            ForEach(viewModel.sounds, id: \.name) { sound in
                Button(action: { viewModel.toggleSound(sound) }) {
                    HStack {
                        Text(sound.name)
                        Spacer()
                        Image(systemName: viewModel.isPlaying(sound) ? "pause.circle" : "play.circle")
                    }
                }
                .buttonStyle(CustomButtonStyle())
            }
            
            CustomDivider()
            
            VStack {
                Text("音量: \(Int(viewModel.volume * 100))%")
                    .customTextStyle()
                Slider(value: $viewModel.volume)
            }
        }
        .padding()
        .customBackground()
        .environment(\.colorScheme, appState.colorScheme ?? colorScheme)
    }
}
