import Kingfisher
import SwiftUI

struct ArtworkImage: View {
    let url: URL?
    let image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
            } else if let url {
                KFImage.url(url)
                    .resizable()
                    .placeholder { fallback }
            } else {
                fallback
            }
        }
    }

    private var fallback: some View {
        Image(systemName: "music.note")
            .resizable()
            .scaledToFit()
            .padding(12)
            .foregroundStyle(Color(.palette.artworkBorder))
            .background(Color(.palette.artworkBackground))
    }
}
