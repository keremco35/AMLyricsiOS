import SwiftUI
import AVKit

// A robust Coordinator to manage navigation and states
struct MainCoordinatorView: View {
    @EnvironmentObject var musicManager: MusicManager
    
    var body: some View {
        TabView {
            LyricsView()
                .tabItem {
                    Label("Lyrics", systemImage: "music.note.list")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(.pink)
    }
}

struct SettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Toggle("High Contrast", isOn: .constant(false))
                NavigationLink("Font Packs", destination: Text("Font Selection"))
            }
            
            Section(header: Text("Cache")) {
                Text("Cache Size: 104 MB") // Mock data
                Button("Clear Cache") {}
            }
            
            Section(header: Text("About")) {
                Text("Version 1.0.0")
            }
        }
    }
}
