import NiaKit
import SwiftUI

struct NiaIconToggleButtonView: View {
    @Environment(\.niaColors) private var colors

    let checked: Bool
    let icon: NiaKit.ImageResource
    let enabled: Bool
    let checkedIcon: NiaKit.ImageResource?
    let contentDescription: String?
    let checkedContentDescription: String?
    let onCheckedChange: (Bool) -> Void

    init(
        checked: Bool,
        icon: NiaKit.ImageResource,
        enabled: Bool = true,
        checkedIcon: NiaKit.ImageResource? = nil,
        contentDescription: String? = nil,
        checkedContentDescription: String? = nil,
        onCheckedChange: @escaping (Bool) -> Void
    ) {
        self.checked = checked
        self.icon = icon
        self.enabled = enabled
        self.checkedIcon = checkedIcon
        self.contentDescription = contentDescription
        self.checkedContentDescription = checkedContentDescription
        self.onCheckedChange = onCheckedChange
    }

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
        .accessibilityLabel(
            (checked ? (checkedContentDescription ?? contentDescription) : contentDescription) ?? ""
        )
        .accessibilityAddTraits(checked ? .isSelected : [])
    }
}
