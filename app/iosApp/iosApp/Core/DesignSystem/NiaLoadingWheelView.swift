import SwiftUI

struct NiaLoadingWheelView: View {
    let contentDescription: String

    var body: some View {
        ProgressView()
            .frame(width: 60, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 60)
                    .fill(Color.primary.opacity(0.06))
            )
            .accessibilityLabel(contentDescription)
    }
}
