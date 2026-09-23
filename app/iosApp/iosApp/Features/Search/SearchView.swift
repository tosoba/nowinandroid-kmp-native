import NiaKit
import SwiftUI

struct SearchView: View {
    private let onTopicClick: (String) -> Void

    @StateObject private var viewModel = SearchViewModel()
    @State private var query = ""

    init(onTopicClick: @escaping (String) -> Void) {
        self.onTopicClick = onTopicClick
    }

    var body: some View {
        Group {
            switch viewModel.searchResultUiState {
            case is NiaKit.SearchResultUiStateLoadFailed:
                Text(String(\.feature_search_api_load_failed))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)

            case is NiaKit.SearchResultUiStateSearchNotReady:
                SearchNotReadyBodyView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .transition(.opacity)

            case is NiaKit.SearchResultUiStateEmptyQuery:
                ScrollView {
                    recentSearchesListView
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)

            case let state as NiaKit.SearchResultUiStateSuccess:
                if state.topics.isEmpty && state.newsResources.isEmpty {
                    emptySearchResultView
                } else {
                    searchResultListView(state)
                }

            default:
                NiaLoadingWheelView(contentDescription: String(\.feature_search_api_loading))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.25), value: viewModel.searchResultAnimationKey)
        .animation(.easeInOut(duration: 0.25), value: viewModel.recentSearchesAnimationKey)
        .searchable(
            text: $query,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: String(\.feature_search_api_title)
        )
        .onChange(of: query) { _, newValue in
            viewModel.wrapped.onSearchQueryChanged(query: newValue)
        }
        .onSubmit(of: .search) {
            viewModel.wrapped.onSearchTriggered(query: query)
        }
    }

    private var recentSearchesListView: some View {
        RecentSearchesListView(
            recentSearchQueries: viewModel.recentSearchQueries,
            onClearRecentSearches: { viewModel.wrapped.clearRecentSearches() },
            onRecentSearchClicked: { searchQuery in
                query = searchQuery
                viewModel.wrapped.onSearchTriggered(query: searchQuery)
            }
        )
    }

    private var emptySearchResultView: some View {
        ScrollView {
            VStack {
                EmptySearchResultBodyView(searchQuery: query)

                recentSearchesListView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity)
    }

    private func searchResultListView(_ state: SearchResultUiStateSuccess) -> some View {
        SearchResultListView(
            searchQuery: query,
            topics: state.topics,
            newsResources: state.newsResources,
            onClearRecentSearches: { viewModel.wrapped.clearRecentSearches() },
            onRecentSearchClicked: { searchQuery in
                query = searchQuery
                viewModel.wrapped.onSearchTriggered(query: searchQuery)
            },
            onFollowTopic: { topicId, followed in
                viewModel.wrapped.followTopic(followedTopicId: topicId, followed: followed)
            },
            onToggleBookmark: { newsResourceId, isChecked in
                viewModel.wrapped.setNewsResourceBookmarked(newsResourceId: newsResourceId, isChecked: isChecked)
            },
            onNewsResourceViewed: { newsResourceId in
                viewModel.wrapped.setNewsResourceViewed(newsResourceId: newsResourceId, viewed: true)
            },
            onTopicClick: onTopicClick
        )
        .transition(.opacity)
    }
}

private struct SearchNotReadyBodyView: View {
    var body: some View {
        Text(String(\.feature_search_api_not_ready))
            .font(.body)
            .multilineTextAlignment(.center)
            .padding(.horizontal, NiaSpacing.extraLarge)
            .padding(.vertical, NiaSpacing.mediumLarge)
            .frame(maxWidth: .infinity)
    }
}

private struct EmptySearchResultBodyView: View {
    let searchQuery: String

    var body: some View {
        let message = String(\.feature_search_api_result_not_found, parameter: searchQuery)

        VStack(spacing: NiaSpacing.none) {
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.vertical, NiaSpacing.mediumLarge)

            (Text(String(\.feature_search_api_try_another_search) + " ")
                .foregroundColor(.secondary)
                + Text(String(\.feature_search_api_interests))
                .foregroundColor(.accentColor)
                .underline()
                .bold()
                + Text(" " + String(\.feature_search_api_to_browse_topics))
                .foregroundColor(.secondary))
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, NiaSpacing.large)
                .padding(.bottom, NiaSpacing.mediumLarge)
                .onTapGesture {} // TODO: navigate to interests
        }
        .padding(.horizontal, NiaSpacing.extraLarge)
    }
}

private struct RecentSearchesListView: View {
    let recentSearchQueries: [String]
    let onClearRecentSearches: () -> Void
    let onRecentSearchClicked: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: NiaSpacing.none) {
            HStack {
                Text(String(\.feature_search_api_recent_searches))
                    .font(.headline)
                    .padding(.vertical, NiaSpacing.small)

                Spacer()

                if !recentSearchQueries.isEmpty {
                    Button(action: onClearRecentSearches) {
                        Image(NiaIcons.shared.Close)
                    }
                    .accessibilityLabel(String(\.feature_search_api_clear_recent_searches_content_desc))
                    .transition(.opacity)
                }
            }

            VStack(alignment: .leading, spacing: NiaSpacing.none) {
                ForEach(recentSearchQueries, id: \.self) { recentSearch in
                    Button(action: { onRecentSearchClicked(recentSearch) }) {
                        Text(recentSearch)
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, NiaSpacing.medium)
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity)
                }
            }
        }
        .padding(.horizontal, NiaSpacing.medium)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

private struct SearchResultListView: View {
    @Environment(\.openURL) private var openURL

    let searchQuery: String
    let topics: [NiaKit.ModelFollowableTopic]
    let newsResources: [NiaKit.ModelUserNewsResource]
    let onClearRecentSearches: () -> Void
    let onRecentSearchClicked: (String) -> Void
    let onFollowTopic: (String, Bool) -> Void
    let onToggleBookmark: (String, Bool) -> Void
    let onNewsResourceViewed: (String) -> Void
    let onTopicClick: (String) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: NiaSpacing.mediumLarge) {
                if !topics.isEmpty {
                    sectionHeader(String(\.feature_search_api_topics))
                        .transition(.opacity)

                    ForEach(topics, id: \.topic.id) { followableTopic in
                        InterestsItemView(
                            name: followableTopic.topic.name,
                            following: followableTopic.isFollowed,
                            topicImageUrl: followableTopic.topic.imageUrl,
                            onClick: {
                                onTopicClick(followableTopic.topic.id)
                            },
                            onFollowButtonClick: { _ in
                                onFollowTopic(followableTopic.topic.id, !followableTopic.isFollowed)
                            },
                            description: followableTopic.topic.shortDescription
                        )
                        .transition(.opacity)
                    }
                }

                if !newsResources.isEmpty {
                    sectionHeader(String(\.feature_search_api_updates))
                        .transition(.opacity)

                    NewsFeedListView(
                        feed: newsResources,
                        onToggleBookmark: { news in
                            onToggleBookmark(news.id, !news.isSaved)
                        },
                        onClick: { news in
                            if let url = URL(string: news.url) {
                                openURL(url)
                            }
                            onNewsResourceViewed(news.id)
                        },
                        onTopicClick: onTopicClick
                    )
                }
            }
            .padding(NiaSpacing.medium)
            .padding(.bottom, NiaSpacing.small)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.horizontal, NiaSpacing.medium)
            .padding(.vertical, NiaSpacing.small)
    }
}
