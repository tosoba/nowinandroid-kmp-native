import NiaKit
import SwiftUI

struct NiaIconToggleButtonView: View {
    @Environment(\.niaColors) private var colors

    let checked: Bool
    let icon: NiaKit.ImageResource
    var enabled: Bool = true
    var checkedIcon: NiaKit.ImageResource? = nil
    var contentDescription: String? = nil
    let onCheckedChange: (Bool) -> Void

    var body: some View {
        Button(action: { onCheckedChange(!checked) }) {
            Image(checked ? (checkedIcon ?? icon) : icon)
                .foregroundColor(checked ? colors.onPrimaryContainer : colors.onSurfaceVariant)
                .frame(width: 40, height: 40)
                .background(
                    Circle().fill(checked ? colors.primaryContainer : Color.clear)
                )
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .accessibilityLabel(contentDescription ?? "")
        .accessibilityAddTraits(checked ? .isSelected : [])
    }
}
