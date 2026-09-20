import NiaKit
import SDWebImageSwiftUI
import SwiftUI

struct NiaDynamicAsyncImageView: View {
    let imageUrl: String
    let contentDescription: String?
    let placeholder: NiaKit.ImageResource
    let contentMode: ContentMode

    init(
        imageUrl: String,
        contentDescription: String? = nil,
        placeholder: NiaKit.ImageResource = CoreDesignsystemMR.images().ic_placeholder_default,
        contentMode: ContentMode = .fill
    ) {
        self.imageUrl = imageUrl
        self.contentDescription = contentDescription
        self.placeholder = placeholder
        self.contentMode = contentMode
    }

    var body: some View {
        WebImage(
            url: URL(string: imageUrl),
            options: [.retryFailed, .scaleDownLargeImages]
        ) { image in
            image
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } placeholder: {
            Image(placeholder).renderingMode(.original)
        }
        .accessibilityLabel(contentDescription ?? "")
    }
}
