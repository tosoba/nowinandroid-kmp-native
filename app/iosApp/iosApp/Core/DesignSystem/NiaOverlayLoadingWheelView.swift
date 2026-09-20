import NiaKit
import SwiftUI

struct NiaOverlayLoadingWheel: View {
    @Environment(\.niaColors) private var colors

    let contentDescription: String

    var body: some View {
        ProgressView()
            .frame(width: 60, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 60)
                    .fill(colors.surface.opacity(0.83))
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            )
            .accessibilityLabel(contentDescription)
    }
}
