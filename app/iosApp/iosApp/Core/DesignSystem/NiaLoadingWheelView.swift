import NiaKit
import SwiftUI

struct NiaLoadingWheelView: View {
    enum Style {
        case inline
        case overlay
    }

    private let contentDescription: String
    private let style: Style

    @Environment(\.niaColors) private var colors

    init(contentDescription: String, style: Style = .inline) {
        self.contentDescription = contentDescription
        self.style = style
    }

    var body: some View {
        ProgressView()
            .controlSize(.large)
            .frame(width: 60, height: 60)
            .background(background)
            .accessibilityLabel(contentDescription)
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .inline:
            Circle()
                .fill(Color.primary.opacity(0.06))
        case .overlay:
            Circle()
                .fill(colors.surface.opacity(0.83))
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
}
