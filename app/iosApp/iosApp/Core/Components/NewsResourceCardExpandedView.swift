import NiaKit
import SwiftUI

struct NewsResourceCardExpandedView: View {
    @Environment(\.niaColors) private var colors

    let news: ModelUserNewsResource
    let onToggleBookmark: () -> Void
    let onClick: () -> Void
    let onTopicClick: (String) -> Void

    private enum LayoutMetrics {
        static let sectionSpacing: CGFloat = 14
        static let metadataSpacing: CGFloat = 6
    }

    private var formattedDate: String {
        NiaDateFormatter.mediumDateString(epochMilliseconds: news.publishDate.toEpochMilliseconds())
    }

    var body: some View {
        Button(action: onClick) {
            VStack(alignment: .leading, spacing: NiaSpacing.none) {
                if let headerImageUrl = news.headerImageUrl, !headerImageUrl.isEmpty {
                    NewsResourceHeaderImageView(urlString: headerImageUrl)
                }

                VStack(alignment: .leading, spacing: NiaSpacing.none) {
                    HStack(alignment: .top) {
                        Text(news.title)
                            .font(.title3.weight(.bold))
                            .foregroundColor(colors.onSurface)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        NiaIconToggleButtonView(
                            checked: news.isSaved,
                            icon: NiaIcons.shared.BookmarkBorder,
                            checkedIcon: NiaIcons.shared.Bookmark,
                            contentDescription: String(
                                news.isSaved ? \.core_ui_unbookmark : \.core_ui_bookmark
                            )
                        ) {
                            _ in onToggleBookmark()
                        }
                    }
                    .padding(.top, NiaSpacing.mediumSmall)

                    HStack(spacing: LayoutMetrics.metadataSpacing) {
                        if !news.hasBeenViewed {
                            NiaNotificationDotView(color: colors.tertiary, size: 8)
                                .accessibilityLabel(String(\.core_ui_unread_resource_dot_content_description))
                        }

                        Text(
                            news.type.isEmpty
                                ? formattedDate
                                : formattedDate + " • " + news.type
                        )
                    }
                    .font(.caption)
                    .foregroundColor(colors.onSurfaceVariant)
                    .padding(.top, LayoutMetrics.sectionSpacing)

                    Text(news.content)
                        .font(.body)
                        .foregroundColor(colors.onSurface)
                        .padding(.top, LayoutMetrics.sectionSpacing)

                    topicsRow
                        .padding(.top, NiaSpacing.mediumSmall)
                }
                .padding(NiaSpacing.medium)
            }
            .background(RoundedRectangle(cornerRadius: 16).fill(colors.surface))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private var topicsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: NiaSpacing.extraSmall) {
                ForEach(news.followableTopics, id: \.topic.id) { followableTopic in
                    NiaTopicTagView(
                        followed: followableTopic.isFollowed,
                        text: followableTopic.topic.name.uppercased()
                    ) {
                        onTopicClick(followableTopic.topic.id)
                    }
                    .accessibilityLabel(
                        followableTopic.isFollowed
                            ? String(
                                \.core_ui_topic_chip_content_description_when_followed,
                                parameter: followableTopic.topic.name
                            )
                            : String(
                                \.core_ui_topic_chip_content_description_when_not_followed,
                                parameter: followableTopic.topic.name
                            )
                    )
                }
            }
        }
    }
}

private struct NewsResourceHeaderImageView: View {
    let urlString: String

    var body: some View {
        NiaDynamicAsyncImageView(imageUrl: urlString)
            .frame(height: 180)
            .frame(maxWidth: .infinity)
            .clipped()
    }
}
