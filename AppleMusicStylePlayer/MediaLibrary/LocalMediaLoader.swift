import AVFoundation
import SwiftUI
import UniformTypeIdentifiers
import UIKit

@MainActor
final class LocalMediaLoader: NSObject, UIDocumentPickerDelegate {
    private var continuation: CheckedContinuation<[Media], Never>?

    /// Presents document picker from provided controller and returns loaded media
    func pick(from controller: UIViewController) async -> [Media] {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        picker.allowsMultipleSelection = true
        picker.delegate = self
        controller.present(picker, animated: true)
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
        }
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true)
        continuation?.resume(returning: loadMedia(from: urls))
        continuation = nil
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
        continuation?.resume(returning: [])
        continuation = nil
    }

    /// Creates ``Media`` objects from file URLs using `AVAsset` metadata
    func loadMedia(from urls: [URL]) -> [Media] {
        urls.compactMap { url in
            let asset = AVURLAsset(url: url)
            let metadata = asset.commonMetadata

            let title = metadata.first(where: { $0.commonKey == .commonKeyTitle })?.stringValue ?? url.deletingPathExtension().lastPathComponent
            let artist = metadata.first(where: { $0.commonKey == .commonKeyArtist })?.stringValue
            var artworkURL: URL?
            if let data = metadata.first(where: { $0.commonKey == .commonKeyArtwork })?.dataValue {
                let tmp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".png")
                try? data.write(to: tmp)
                artworkURL = tmp
            }

            return Media(artwork: artworkURL, title: title, subtitle: artist, online: false, fileURL: url)
        }
    }
}
