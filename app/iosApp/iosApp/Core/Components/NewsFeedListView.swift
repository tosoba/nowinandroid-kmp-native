import NiaKit
import SwiftUI

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
