import NiaKit
import SwiftUI

@MainActor
final class BookmarksViewModel: ObservableObject {
    private let owner = IosViewModelStoreOwner()
    private let wrapper: BookmarksViewModelWrapper

    var wrapped: NiaKit.BookmarksViewModel {
        wrapper.wrapped
    }

    @Published private(set) var feedState: any NewsFeedUiState = NewsFeedUiStateLoading.shared

    init() {
        let viewModel = IosViewModelProvider.shared.createBookmarksViewModel()
        wrapper = BookmarksViewModelWrapper(wrapped: viewModel)
        owner.put(viewModel: viewModel)

        wrapper.observeFeedUiState { [weak self] state in self?.feedState = state }
    }

    deinit {
        owner.clear()
    }

    var feedAnimationKey: String {
        let prefix = String(describing: type(of: feedState))
        guard let state = feedState as? NewsFeedUiStateSuccess else { return prefix }
        let resourceIds = state.feed.map(\.id).joined(separator: ",")
        return "\(prefix)|resources:\(resourceIds)"
    }
}
