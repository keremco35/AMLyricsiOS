import SwiftUI

struct LyricsView: View {
    @EnvironmentObject var lyricsManager: LyricsManager
    @EnvironmentObject var musicManager: MusicManager
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(Array(lyricsManager.currentLyrics.enumerated()), id: \.offset) { index, line in
                        Text(line.text)
                            .font(.system(size: index == lyricsManager.activeLineIndex ? 28 : 20, weight: index == lyricsManager.activeLineIndex ? .bold : .regular))
                            .foregroundColor(index == lyricsManager.activeLineIndex ? .white : .gray)
                            .blur(radius: index == lyricsManager.activeLineIndex ? 0 : 2)
                            .scaleEffect(index == lyricsManager.activeLineIndex ? 1.1 : 1.0)
                            .animation(.spring(), value: lyricsManager.activeLineIndex)
                            .id(index)
                            .onTapGesture {
                                // Seek to time logic could go here
                            }
                    }
                }
                .padding()
            }
            .onChange(of: lyricsManager.activeLineIndex) { newIndex in
                withAnimation {
                    proxy.scrollTo(newIndex, anchor: .center)
                }
            }
        }
        .background(
            // Animated background placeholder
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
        )
        .onReceive(musicManager.$currentPlaybackTime) { time in
            lyricsManager.updateActiveLine(currentTime: time)
        }
    }
}
