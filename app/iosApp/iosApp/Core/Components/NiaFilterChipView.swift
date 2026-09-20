import NiaKit
import SwiftUI

struct NiaFilterChipView: View {
    @Environment(\.niaColors) private var colors

    let selected: Bool
    let text: String
    let onSelectedChange: (Bool) -> Void
    let enabled: Bool

    init(
        selected: Bool,
        text: String,
        enabled: Bool = true,
        onSelectedChange: @escaping (Bool) -> Void
    ) {
        self.selected = selected
        self.text = text
        self.enabled = enabled
        self.onSelectedChange = onSelectedChange
    }

    var body: some View {
        Button(action: { onSelectedChange(!selected) }) {
            Text(text)
                .font(.caption2)
                .foregroundColor(colors.onBackground)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule().fill(selected ? colors.primaryContainer : Color.clear)
                )
                .overlay(
                    Capsule().strokeBorder(colors.onBackground, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }
}
