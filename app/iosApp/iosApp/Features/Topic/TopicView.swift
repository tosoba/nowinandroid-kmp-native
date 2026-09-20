import NiaKit
import SwiftUI

struct TopicView: View {
    let topicId: String
    @StateObject private var viewModel: TopicViewModel
    @Environment(\.openURL) private var openURL

    init(topicId: String) {
        self.topicId = topicId
        _viewModel = StateObject(wrappedValue: TopicViewModel(topicId: topicId))
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 0) {
                switch viewModel.topicUiState {
                case let state as NiaKit.TopicUiStateLoading:
                    NiaLoadingWheelView(contentDescription: String(\.feature_topic_api_loading))

                case is NiaKit.TopicUiStateError:
                    Text(String(\.feature_topic_api_error))
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 48)

                case let state as NiaKit.TopicUiStateSuccess:
                    TopicToolbarView(isFollowed: state.followableTopic.isFollowed) { newValue in
                        viewModel.wrapped.followTopicToggle(followed: newValue)
                    }

                    TopicHeaderView(
                        name: state.followableTopic.topic.name,
                        description: state.followableTopic.topic.longDescription,
                        imageUrl: state.followableTopic.topic.imageUrl
                    )

                    switch viewModel.newsUiState {
                    case let newsState as NiaKit.NewsUiStateLoading:
                        NiaLoadingWheelView(contentDescription: "Loading news")
                            .padding(24)

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
                            onTopicClick: { _ in }
                        )
                        .padding(24)

                    case is NiaKit.NewsUiStateError:
                        Text(String(\.feature_topic_api_error))
                            .padding(24)

                    default:
                        EmptyView()
                    }

                default:
                    EmptyView()
                }
            }
            .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct TopicToolbarView: View {
    @State private var isFollowed: Bool

    let onFollowClick: (Bool) -> Void

    init(isFollowed: Bool, onFollowClick: @escaping (Bool) -> Void) {
        _isFollowed = State(initialValue: isFollowed)
        self.onFollowClick = onFollowClick
    }

    var body: some View {
        HStack {
            Spacer()

            NiaFilterChipView(
                selected: isFollowed,
                text: isFollowed ? "FOLLOWING" : "NOT FOLLOWING"
            ) { newValue in
                isFollowed = newValue
                onFollowClick(newValue)
            }
            .padding(.trailing, 24)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 32)
    }
}

private struct TopicHeaderView: View {
    let name: String
    let description: String
    let imageUrl: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NiaDynamicAsyncImageView(imageUrl: imageUrl)
                .frame(width: 132, height: 132)
                .padding(.bottom, 12)

            Text(name)
                .font(.system(size: 34, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)

            if !description.isEmpty {
                Text(description)
                    .font(.body)
                    .padding(.top, 24)
            }
        }
        .padding(.horizontal, 24)
    }
}
