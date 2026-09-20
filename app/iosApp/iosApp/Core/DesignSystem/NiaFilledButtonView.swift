import SwiftUI

struct NiaFilledButtonView: View {
    @Environment(\.niaColors) private var colors

    let title: String
    let enabled: Bool
    let maxWidth: CGFloat?
    let action: () -> Void

    init(
        title: String,
        enabled: Bool = true,
        maxWidth: CGFloat? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.enabled = enabled
        self.maxWidth = maxWidth
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(colors.onPrimary)
                .frame(maxWidth: maxWidth ?? .infinity)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .buttonStyle(.borderedProminent)
        .tint(colors.primary)
        .disabled(!enabled)
    }
}
