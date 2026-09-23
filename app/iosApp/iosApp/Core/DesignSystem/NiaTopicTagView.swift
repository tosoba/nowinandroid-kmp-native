import NiaKit
import SwiftUI

struct NiaTopicTagView: View {
    @Environment(\.niaColors) private var colors

    let followed: Bool
    let text: String
    let enabled: Bool
    let onClick: () -> Void

    init(
        followed: Bool,
        text: String,
        enabled: Bool = true,
        onClick: @escaping () -> Void
    ) {
        self.followed = followed
        self.text = text
        self.enabled = enabled
        self.onClick = onClick
    }

    private enum NiaTagDefaults {
        static let unfollowedTopicTagContainerAlpha = 0.5
        static let disabledTopicTagContainerAlpha = 0.12
        static let chipBorderWidth: CGFloat = 1
    }

    private var containerColor: Color {
        if !enabled {
            return colors.onSurface.opacity(NiaTagDefaults.disabledTopicTagContainerAlpha)
        }
        return followed
            ? colors.primaryContainer
            : colors.surfaceVariant.opacity(NiaTagDefaults.unfollowedTopicTagContainerAlpha)
    }

    var body: some View {
        Button(action: onClick) {
            Text(text)
                .font(.caption)
                .foregroundColor(colors.onSurface)
                .padding(.horizontal, NiaSpacing.medium)
                .padding(.vertical, NiaSpacing.mediumSmall)
                .background(Capsule().fill(containerColor))
                .overlay(
                    Capsule().strokeBorder(
                        colors.onBackground.opacity(
                            followed ? NiaTagDefaults.chipBorderWidth : 0
                        ),
                        lineWidth: NiaTagDefaults.chipBorderWidth
                    )
                )
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }
}
