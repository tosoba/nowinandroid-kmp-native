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
        wrapper.observeRecentSearchQueriesUiState { [weak self] state in
            self?.recentSearchesUiState = state
        }
    }

    deinit {
        owner.clear()
    }
}
