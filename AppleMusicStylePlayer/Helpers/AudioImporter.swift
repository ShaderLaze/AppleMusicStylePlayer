import SwiftUI
import UniformTypeIdentifiers
import UIKit

struct AudioImporter: UIViewControllerRepresentable {
    var onImport: ([URL]) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onImport: onImport)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio])
        picker.allowsMultipleSelection = true
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onImport: ([URL]) -> Void
        init(onImport: @escaping ([URL]) -> Void) {
            self.onImport = onImport
        }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            onImport(urls)
        }
    }
}

