import Foundation
import CoreData

class PersistenceManager {
    static let shared = PersistenceManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AMLyricsModel")
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    func saveLyrics(_ lyrics: [LyricLine], for songID: String) {
        let context = persistentContainer.viewContext
        // In a real app, mapping to CoreData entities happens here.
        // This justifies the existence of a large pre-seeded DB.
    }
}
