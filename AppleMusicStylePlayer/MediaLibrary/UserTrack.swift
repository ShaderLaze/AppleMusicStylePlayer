import AVFoundation
import Foundation

struct UserTrack: Codable {
    let fileName: String
    var title: String
    var artist: String?
    var artworkFileName: String?

    var fileURL: URL {
        FileManager.documentsDirectory.appendingPathComponent(fileName)
    }

    var artworkURL: URL? {
        artworkFileName.map { FileManager.documentsDirectory.appendingPathComponent($0) }
    }

    init(fileURL url: URL) {
        self.fileName = url.lastPathComponent
        self.title = url.deletingPathExtension().lastPathComponent
        self.artist = nil
        self.artworkFileName = nil

        let asset = AVURLAsset(url: url)
        for item in asset.commonMetadata {
            guard let key = item.commonKey?.rawValue else { continue }
            switch key {
            case "title":
                if let value = item.stringValue { self.title = value }
            case "artist":
                if let value = item.stringValue { self.artist = value }
            case "artwork":
                if let data = item.dataValue {
                    let artworkName = UUID().uuidString + ".png"
                    let dest = FileManager.documentsDirectory.appendingPathComponent(artworkName)
                    try? data.write(to: dest)
                    self.artworkFileName = artworkName
                }
            default: break
            }
        }
    }
}
