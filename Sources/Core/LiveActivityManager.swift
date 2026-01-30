import ActivityKit
import SwiftUI

struct LyricsActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic state updated frequently
        var currentLine: String
        var nextLine: String
        var progress: Double
    }
    
    // Static data
    var songTitle: String
    var artistName: String
}

class LiveActivityManager {
    static let shared = LiveActivityManager()
    
    private var currentActivity: Activity<LyricsActivityAttributes>?
    
    func startLiveActivity(song: String, artist: String) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        
        let attributes = LyricsActivityAttributes(songTitle: song, artistName: artist)
        let state = LyricsActivityAttributes.ContentState(currentLine: "Loading...", nextLine: "", progress: 0)
        
        do {
            currentActivity = try Activity.request(
                attributes: attributes,
                content: .init(state: state, staleDate: nil)
            )
        } catch {
            print("Error starting Live Activity: \(error)")
        }
    }
    
    func updateLyrics(line: String, next: String, progress: Double) {
        guard let activity = currentActivity else { return }
        
        let newState = LyricsActivityAttributes.ContentState(currentLine: line, nextLine: next, progress: progress)
        
        Task {
            await activity.update(
                ActivityContent(state: newState, staleDate: nil)
            )
        }
    }
    
    func stopLiveActivity() {
        Task {
            await currentActivity?.end(nil, dismissalPolicy: .immediate)
            currentActivity = nil
        }
    }
}
