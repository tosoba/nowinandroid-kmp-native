import NiaKit
import SwiftUI

struct InterestsItemView: View {
    @Environment(\.niaColors) private var colors

    let name: String
    let following: Bool
    let topicImageUrl: String
    let onClick: () -> Void
    let onFollowButtonClick: (Bool) -> Void
    var description: String = ""
    var isSelected: Bool = false

    init(
        name: String,
        following: Bool,
        topicImageUrl: String,
        onClick: @escaping () -> Void,
        onFollowButtonClick: @escaping (Bool) -> Void,
        description: String = "",
        isSelected: Bool = false
    ) {
        self.name = name
        self.following = following
        self.topicImageUrl = topicImageUrl
        self.onClick = onClick
        self.onFollowButtonClick = onFollowButtonClick
        self.description = description
        self.isSelected = isSelected
    }

    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 16) {
                icon

                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.body)
                        .foregroundColor(colors.onSurface)
                    if !description.isEmpty {
                        Text(description)
                            .font(.body)
                            .foregroundColor(colors.onSurfaceVariant)
                    }
                }

                Spacer(minLength: 0)

                NiaIconToggleButtonView(
                    checked: following,
                    icon: NiaIcons.shared.Add,
                    checkedIcon: NiaIcons.shared.Check,
                    contentDescription: String(\.core_ui_interests_card_follow_button_content_desc),
                    checkedContentDescription: String(\.core_ui_interests_card_unfollow_button_content_desc)
                ) { _ in
                    onFollowButtonClick(!following)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? colors.surfaceVariant : Color.clear)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    @ViewBuilder
    private var icon: some View {
        if topicImageUrl.isEmpty {
            NiaDynamicAsyncImageView(
                imageUrl: "",
                placeholder: NiaIcons.shared.Person
            )
            .frame(width: 48, height: 48)
            .background(colors.surface)
        } else {
            NiaDynamicAsyncImageView(imageUrl: topicImageUrl)
                .frame(width: 48, height: 48)
        }
    }
}
