import Foundation

struct UserTracksStorage {
    private let storeURL = FileManager.documentsDirectory.appendingPathComponent("tracks.json")

    func load() -> [UserTrack] {
        guard let data = try? Data(contentsOf: storeURL) else { return [] }
        return (try? JSONDecoder().decode([UserTrack].self, from: data)) ?? []
    }

    func save(_ tracks: [UserTrack]) {
        guard let data = try? JSONEncoder().encode(tracks) else { return }
        try? data.write(to: storeURL)
    }
}
