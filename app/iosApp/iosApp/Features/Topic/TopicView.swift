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

    private var navigationTitleText: String {
        guard let state = viewModel.topicUiState as? NiaKit.TopicUiStateSuccess else { return "" }
        return state.followableTopic.topic.name
    }

    private var topicAnimationKey: String {
        String(describing: type(of: viewModel.topicUiState))
    }

    private var newsAnimationKey: String {
        let state = String(describing: type(of: viewModel.newsUiState))
        guard let success = viewModel.newsUiState as? NiaKit.NewsUiStateSuccess else { return state }

        let resourceIds = success.news.map { $0.id }.joined(separator: ",")
        return "\(state)|resources:\(resourceIds)"
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
                        newsFeedList(newsState)

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
        .animation(.easeInOut(duration: 0.25), value: topicAnimationKey)
        .animation(.easeInOut(duration: 0.25), value: newsAnimationKey)
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

    private func newsFeedList(_ newsState: NewsUiStateSuccess) -> some View {
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
