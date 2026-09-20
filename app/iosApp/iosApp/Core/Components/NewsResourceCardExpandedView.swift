import NiaKit
import SwiftUI

struct NewsResourceCardExpandedView: View {
    @Environment(\.niaColors) private var colors

    let news: ModelUserNewsResource
    let onToggleBookmark: () -> Void
    let onClick: () -> Void
    let onTopicClick: (String) -> Void

    private var formattedDate: String {
        NiaDateFormatter.mediumDateString(epochMilliseconds: news.publishDate.toEpochMilliseconds())
    }

    var body: some View {
        Button(action: onClick) {
            VStack(alignment: .leading, spacing: 0) {
                if let headerImageUrl = news.headerImageUrl, !headerImageUrl.isEmpty {
                    NewsResourceHeaderImageView(urlString: headerImageUrl)
                }

                VStack(alignment: .leading, spacing: 0) {
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
                    .padding(.top, 12)

                    HStack(spacing: 6) {
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
                    .padding(.top, 14)

                    Text(news.content)
                        .font(.body)
                        .foregroundColor(colors.onSurface)
                        .padding(.top, 14)

                    topicsRow
                        .padding(.top, 12)
                }
                .padding(16)
            }
            .background(RoundedRectangle(cornerRadius: 16).fill(colors.surface))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private var topicsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
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

struct NewsFeedListView: View {
    let feed: [ModelUserNewsResource]
    let onToggleBookmark: (ModelUserNewsResource) -> Void
    let onClick: (ModelUserNewsResource) -> Void
    let onTopicClick: (String) -> Void

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 24) {
            ForEach(feed, id: \.id) { news in
                NewsResourceCardExpandedView(
                    news: news,
                    onToggleBookmark: { onToggleBookmark(news) },
                    onClick: { onClick(news) },
                    onTopicClick: onTopicClick
                )
                .transition(.opacity)
            }
        }
    }
}
