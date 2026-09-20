import NiaKit
import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var query = ""

    var body: some View {
        Group {
            switch viewModel.searchResultUiState {
            case let state as NiaKit.SearchResultUiStateLoading:
                NiaLoadingWheelView(contentDescription: String(\.feature_search_api_loading))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case let state as NiaKit.SearchResultUiStateLoadFailed:
                Text(String(\.feature_search_api_load_failed))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case is NiaKit.SearchResultUiStateSearchNotReady:
                SearchNotReadyBodyView()

            case is NiaKit.SearchResultUiStateEmptyQuery:
                if case let recentState as NiaKit.RecentSearchQueriesUiStateSuccess = viewModel.recentSearchesUiState {
                    RecentSearchesBodyView(
                        recentSearchQueries: recentState.recentQueries.map {query in query.query},
                        onClearRecentSearches: { viewModel.wrapped.clearRecentSearches() },
                        onRecentSearchClicked: { searchQuery in
                            query = searchQuery
                            viewModel.wrapped.onSearchTriggered(query: searchQuery)
                        }
                    )
                }

            case let state as NiaKit.SearchResultUiStateSuccess:
                if state.topics.isEmpty && state.newsResources.isEmpty {
                    ScrollView {
                        VStack {
                            EmptySearchResultBodyView(searchQuery: query)
                            if case let recentState as NiaKit.RecentSearchQueriesUiStateSuccess = viewModel.recentSearchesUiState {
                                RecentSearchesBodyView(
                                    recentSearchQueries: recentState.recentQueries.map {query in query.query},
                                    onClearRecentSearches: { viewModel.wrapped.clearRecentSearches() },
                                    onRecentSearchClicked: { searchQuery in
                                        query = searchQuery
                                        viewModel.wrapped.onSearchTriggered(query: searchQuery)
                                    }
                                )
                            }
                        }
                    }
                } else {
                    SearchResultBodyView(
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
                        onTopicClick: { _ in }
                    )
                }

            default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
}


private struct SearchNotReadyBodyView: View {
    var body: some View {
        Text(String(\.feature_search_api_not_ready))
            .font(.body)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 48)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
    }
}

private struct EmptySearchResultBodyView: View {
    let searchQuery: String

    var body: some View {
        let message = String(\.feature_search_api_result_not_found, parameter: searchQuery)

        VStack(spacing: 0) {
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.vertical, 24)

            (Text(String(\.feature_search_api_try_another_search) + " ")
                .foregroundColor(.secondary)
             + Text(String(\.feature_search_api_interests))
                .foregroundColor(.accentColor)
                .underline()
                .bold()
             + Text(" " + String(\.feature_search_api_to_browse_topics))
                .foregroundColor(.secondary)
            )
            .font(.body)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 36)
            .padding(.bottom, 24)
            .onTapGesture { } // TODO: navigate to interests
        }
        .padding(.horizontal, 48)
    }
}

private struct RecentSearchesBodyView: View {
    let recentSearchQueries: [String]
    let onClearRecentSearches: () -> Void
    let onRecentSearchClicked: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(String(\.feature_search_api_recent_searches))
                    .font(.headline)
                    .padding(.leading, 16)
                    .padding(.vertical, 8)

                Spacer()

                if !recentSearchQueries.isEmpty {
                    Button(action: onClearRecentSearches) {
                        Image(NiaIcons.shared.Close)
                    }
                    .accessibilityLabel(String(\.feature_search_api_clear_recent_searches_content_desc))
                    .padding(.trailing, 16)
                }
            }

            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(recentSearchQueries, id: \.self) { recentSearch in
                    Button(action: { onRecentSearchClicked(recentSearch) }) {
                        Text(recentSearch)
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 16)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct SearchResultBodyView: View {
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
            LazyVStack(alignment: .leading, spacing: 24) {
                if !topics.isEmpty {
                    sectionHeader(String(\.feature_search_api_topics))

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
                    }
                }

                if !newsResources.isEmpty {
                    sectionHeader(String(\.feature_search_api_updates))

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
                        onTopicClick: { _ in }
                    )
                }
            }
            .padding(16)
            .padding(.bottom, 8)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
    }
}
