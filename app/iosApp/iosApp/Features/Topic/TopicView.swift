import NiaKit
import SwiftUI

struct TopicView: View {
    private let topicId: String
    private let onTopicClick: (String) -> Void

    @StateObject private var viewModel: TopicViewModel

    @Environment(\.openURL) private var openURL

    init(topicId: String, onTopicClick: @escaping (String) -> Void) {
        self.topicId = topicId
        self.onTopicClick = onTopicClick

        _viewModel = StateObject(wrappedValue: TopicViewModel(topicId: topicId))
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: NiaSpacing.none) {
                switch viewModel.topicUiState {
                case let state as NiaKit.TopicUiStateSuccess:
                    TopicHeaderView(
                        description: state.followableTopic.topic.longDescription,
                        imageUrl: state.followableTopic.topic.imageUrl
                    )
                    .padding(.top, NiaSpacing.medium)

                    switch viewModel.newsUiState {
                    case let state as NiaKit.NewsUiStateSuccess:
                        newsFeedList(state)

                    case is NiaKit.NewsUiStateError:
                        Text(String(\.feature_topic_api_error))
                            .padding(NiaSpacing.mediumLarge)

                    default:
                        NiaLoadingWheelView(contentDescription: "Loading news")
                            .padding(NiaSpacing.mediumLarge)
                    }

                case is NiaKit.TopicUiStateError:
                    Text(String(\.feature_topic_api_error))
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, NiaSpacing.mediumLarge)
                        .padding(.vertical, NiaSpacing.extraLarge)

                default:
                    NiaLoadingWheelView(contentDescription: String(\.feature_topic_api_loading))
                }
            }
            .padding(.bottom, NiaSpacing.small)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.25), value: viewModel.topicAnimationKey)
        .animation(.easeInOut(duration: 0.25), value: viewModel.newsAnimationKey)
        .navigationTitle(viewModel.topicName)
        .toolbar {
            if let isFollowed = viewModel.isFollowed {
                ToolbarItem(placement: .topBarTrailing) {
                    NiaFilterChipView(
                        selected: isFollowed,
                        text: String(
                            isFollowed
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

    private func newsFeedList(_ state: NewsUiStateSuccess) -> some View {
        NewsFeedListView(
            feed: state.news,
            onToggleBookmark: { newsItem in
                viewModel.wrapped.bookmarkNews(newsResourceId: newsItem.id, bookmarked: !newsItem.isSaved)
            },
            onClick: { newsItem in
                if let url = URL(string: newsItem.url) {
                    openURL(url)
                }
                viewModel.wrapped.setNewsResourceViewed(newsResourceId: newsItem.id, viewed: true)
            },
            onTopicClick: onTopicClick
        )
        .padding(NiaSpacing.mediumLarge)
    }
}

private struct TopicHeaderView: View {
    let description: String
    let imageUrl: String

    var body: some View {
        VStack(alignment: .center, spacing: NiaSpacing.none) {
            NiaDynamicAsyncImageView(imageUrl: imageUrl)
                .frame(width: 132, height: 132)
                .padding(.bottom, NiaSpacing.mediumSmall)

            if !description.isEmpty {
                Text(description)
                    .font(.body)
                    .padding(.top, NiaSpacing.mediumLarge)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, NiaSpacing.mediumLarge)
    }
}
