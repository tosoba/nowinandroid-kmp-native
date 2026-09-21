import NiaKit
import SwiftUI

struct TopicView: View {
    let topicId: String
    let onTopicClick: (String) -> Void

    @StateObject private var viewModel: TopicViewModel

    @Environment(\.openURL) private var openURL

    init(topicId: String, onTopicClick: @escaping (String) -> Void) {
        self.topicId = topicId
        self.onTopicClick = onTopicClick

        _viewModel = StateObject(wrappedValue: TopicViewModel(topicId: topicId))
    }

    var navigationTitleText: String {
        guard let state = viewModel.topicUiState as? NiaKit.TopicUiStateSuccess else { return "" }
        return state.followableTopic.topic.name
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 0) {
                switch viewModel.topicUiState {
                case let state as NiaKit.TopicUiStateSuccess:
                    TopicHeaderView(
                        description: state.followableTopic.topic.longDescription,
                        imageUrl: state.followableTopic.topic.imageUrl
                    )
                    .padding(.top, 16)

                    switch viewModel.newsUiState {
                    case let newsState as NiaKit.NewsUiStateSuccess:
                        NewsFeedListView(
                            feed: newsState.news,
                            onToggleBookmark: { newsItem in
                                viewModel.wrapped.bookmarkNews(newsResourceId: newsItem.id, bookmarked: !newsItem.isSaved)
                            },
                            onClick: { newsItem in
                                if let url = URL(string: newsItem.url) {
                                    openURL(url)
                                }
                                viewModel.wrapped.setNewsResourceViewed(newsResourceId: newsItem.id, viewed: true)
                            },
                            onTopicClick: { id in onTopicClick(id) }
                        )
                        .padding(24)

                    case is NiaKit.NewsUiStateError:
                        Text(String(\.feature_topic_api_error))
                            .padding(24)

                    default:
                        NiaLoadingWheelView(contentDescription: "Loading news")
                            .padding(24)
                    }

                case is NiaKit.TopicUiStateError:
                    Text(String(\.feature_topic_api_error))
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 48)

                default:
                    NiaLoadingWheelView(contentDescription: String(\.feature_topic_api_loading))
                }
            }
            .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(navigationTitleText)
        .toolbar {
            if let state = viewModel.topicUiState as? NiaKit.TopicUiStateSuccess {
                ToolbarItem(placement: .topBarTrailing) {
                    NiaFilterChipView(
                        selected: state.followableTopic.isFollowed,
                        text: String(
                            state.followableTopic.isFollowed
                                ? \.feature_topic_api_following
                                : \.feature_topic_api_not_following
                        )
                    ) { newValue in
                        viewModel.wrapped.followTopicToggle(followed: newValue)
                    }
                }
            }
        }
    }
}

private struct TopicHeaderView: View {
    let description: String
    let imageUrl: String

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            NiaDynamicAsyncImageView(imageUrl: imageUrl)
                .frame(width: 132, height: 132)
                .padding(.bottom, 12)

            if !description.isEmpty {
                Text(description)
                    .font(.body)
                    .padding(.top, 24)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 24)
    }
}
