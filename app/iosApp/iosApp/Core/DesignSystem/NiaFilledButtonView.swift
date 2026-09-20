import SwiftUI

struct NiaFilledButtonView: View {
    @Environment(\.niaColors) private var colors

    let title: String
    var enabled: Bool = true
    var maxWidth: CGFloat? = nil
    let action: () -> Void

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
