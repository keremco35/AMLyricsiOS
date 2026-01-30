import Foundation
import Combine

struct LyricLine: Identifiable, Codable {
    let id = UUID()
    let text: String
    let startTime: TimeInterval
    let endTime: TimeInterval
}

class LyricsManager: ObservableObject {
    static let shared = LyricsManager()
    
    @Published var currentLyrics: [LyricLine] = []
    @Published var activeLineIndex: Int = 0
    
    private let baseURL = "https://lrclib.net/api"
    
    func fetchLyrics(for song: MusicKit.Song) async {
        let artist = song.artistName
        let title = song.title
        
        guard let url = URL(string: "\(baseURL)/get?artist_name=\(artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&track_name=\(title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let response = try? JSONDecoder().decode(LRCLibResponse.self, from: data), let syncedLyrics = response.syncedLyrics {
                let parsed = parseLRC(syncedLyrics)
                await MainActor.run {
                    self.currentLyrics = parsed
                }
            }
        } catch {
            print("Lyrics fetch failed: \(error)")
        }
    }
    
    private func parseLRC(_ lrc: String) -> [LyricLine] {
        // Simple regex-based parser
        // [mm:ss.xx] Text
        var lines: [LyricLine] = []
        let regex = try! NSRegularExpression(pattern: "\[(\d{2}):(\d{2}\.\d{2})\](.*)")
        
        let stringLines = lrc.components(separatedBy: .newlines)
        
        for (index, line) in stringLines.enumerated() {
            let range = NSRange(location: 0, length: line.utf16.count)
            if let match = regex.firstMatch(in: line, options: [], range: range) {
                let minStr = (line as NSString).substring(with: match.range(at: 1))
                let secStr = (line as NSString).substring(with: match.range(at: 2))
                let content = (line as NSString).substring(with: match.range(at: 3)).trimmingCharacters(in: .whitespaces)
                
                if let min = Double(minStr), let sec = Double(secStr) {
                    let start = (min * 60) + sec
                    // Estimate end time based on next line or arbitrary duration
                    let end = start + 3.0 
                    lines.append(LyricLine(text: content, startTime: start, endTime: end))
                }
            }
        }
        
        // Fix end times
        for i in 0..<lines.count - 1 {
            let nextStart = lines[i+1].startTime
            lines[i] = LyricLine(text: lines[i].text, startTime: lines[i].startTime, endTime: nextStart)
        }
        
        return lines
    }
    
    func updateActiveLine(currentTime: TimeInterval) {
        if let index = currentLyrics.firstIndex(where: { currentTime >= $0.startTime && currentTime < $0.endTime }) {
            if index != activeLineIndex {
                activeLineIndex = index
            }
        }
    }
}

struct LRCLibResponse: Codable {
    let syncedLyrics: String?
    let plainLyrics: String?
}
