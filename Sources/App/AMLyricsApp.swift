import SwiftUI
import MusicKit

@main
struct AMLyricsApp: App {
    @StateObject var musicManager = MusicManager.shared
    @StateObject var lyricsManager = LyricsManager.shared
    
    var body: some Scene {
        WindowGroup {
            MainCoordinatorView()
                .environmentObject(musicManager)
                .environmentObject(lyricsManager)
                .task {
                    await musicManager.requestAuthorization()
                }
        }
    }
}
