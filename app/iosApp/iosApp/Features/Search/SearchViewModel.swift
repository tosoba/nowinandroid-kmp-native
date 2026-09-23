import NiaKit
import SwiftUI

@MainActor
final class SearchViewModel: ObservableObject {
    private let owner = IosViewModelStoreOwner()
    private let wrapper: SearchViewModelWrapper

    var wrapped: NiaKit.SearchViewModel {
        wrapper.wrapped
    }

    @Published private(set) var searchQuery: String = ""
    @Published private(set) var recentSearchesUiState: any RecentSearchQueriesUiState =
        RecentSearchQueriesUiStateLoading.shared
    @Published private(set) var searchResultUiState: any SearchResultUiState =
        SearchResultUiStateEmptyQuery.shared

    init() {
        let viewModel = IosViewModelProvider.shared.createSearchViewModel()
        wrapper = SearchViewModelWrapper(wrapped: viewModel)
        owner.put(viewModel: viewModel)

        wrapper.observeSearchQuery { [weak self] query in self?.searchQuery = query }
        wrapper.observeSearchResultUiState { [weak self] state in self?.searchResultUiState = state }
        wrapper.observeRecentSearchQueriesUiState { [weak self] state in self?.recentSearchesUiState = state }
    }

    deinit {
        owner.clear()
    }

    var recentSearchQueries: [String] {
        guard let state = recentSearchesUiState as? RecentSearchQueriesUiStateSuccess else { return [] }
        return state.recentQueries.map(\.query)
    }

    var searchResultAnimationKey: String {
        let prefix = String(describing: type(of: searchResultUiState))
        guard let state = searchResultUiState as? SearchResultUiStateSuccess else { return prefix }
        let topicIds = state.topics.map(\.topic.id).joined(separator: ",")
        let newsResourceIds = state.newsResources.map(\.id).joined(separator: ",")
        return "\(prefix)|topics:\(topicIds)|news:\(newsResourceIds)"
    }

    var recentSearchesAnimationKey: String {
        let prefix = String(describing: type(of: recentSearchesUiState))
        guard let state = recentSearchesUiState as? RecentSearchQueriesUiStateSuccess else { return prefix }
        let queries = state.recentQueries.map(\.query).joined(separator: "\u{1f}")
        return "\(prefix)|queries:\(queries)"
    }
}
