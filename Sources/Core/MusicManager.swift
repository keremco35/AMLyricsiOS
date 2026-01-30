import Foundation
import MusicKit
import Combine

class MusicManager: ObservableObject {
    static let shared = MusicManager()
    
    @Published var currentTrack: Song?
    @Published var isPlaying: Bool = false
    @Published var currentPlaybackTime: TimeInterval = 0
    
    private var player = ApplicationMusicPlayer.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupObservers()
    }
    
    func requestAuthorization() async {
        let status = await MusicAuthorization.request()
        if status == .authorized {
            print("MusicKit Authorized")
        }
    }
    
    private func setupObservers() {
        // Observe playback state
        player.state.objectWillChange
            .sink { [weak self] _ in
                self?.isPlaying = self?.player.state.playbackStatus == .playing
            }
            .store(in: &cancellables)
            
        // Observe now playing item
        player.queue.objectWillChange
            .sink { [weak self] _ in
                Task {
                    await self?.updateCurrentEntry()
                }
            }
            .store(in: &cancellables)
            
        // Timer for high-precision playback time (60fps logic would go here or in a separate Ticker)
        Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.currentPlaybackTime = self?.player.playbackTime ?? 0
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func updateCurrentEntry() async {
        if let entry = player.queue.currentEntry, case let .song(song) = entry.item {
            self.currentTrack = song
            // Trigger lyric fetch
            await LyricsManager.shared.fetchLyrics(for: song)
        }
    }
}
