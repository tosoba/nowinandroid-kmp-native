import NiaKit
import SDWebImageSwiftUI
import SwiftUI

struct NiaDynamicAsyncImageView: View {
    let imageUrl: String
    var contentDescription: String? = nil
    var placeholder: NiaKit.ImageResource = CoreDesignsystemMR.images().ic_placeholder_default
    var contentMode: ContentMode = .fill

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
