import SwiftUI
import UniformTypeIdentifiers

struct FilePicker: UIViewControllerRepresentable {
    typealias Callback = ([URL]) -> Void
    var onPick: Callback

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio])
        controller.allowsMultipleSelection = true
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onPick: Callback
        init(onPick: @escaping Callback) { self.onPick = onPick }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let accessibleUrls: [URL] = urls.compactMap { original in
                let fm = FileManager.default
                let docs = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let destination = docs.appendingPathComponent(original.lastPathComponent)

                let accessed = original.startAccessingSecurityScopedResource()
                defer { if accessed { original.stopAccessingSecurityScopedResource() } }

                do {
                    if fm.fileExists(atPath: destination.path) {
                        try fm.removeItem(at: destination)
                    }
                    try fm.copyItem(at: original, to: destination)
                    return destination
                } catch {
                    print("Failed to copy \(original) to documents: \(error)")
                    return nil
                }
            }

            onPick(accessibleUrls)
        }
    }
}
