import NiaKit
import SwiftUI

@MainActor
final class InterestsViewModel: ObservableObject {
    private let owner = IosViewModelStoreOwner()
    private let wrapper: InterestsViewModelWrapper

    var wrapped: NiaKit.InterestsViewModel {
        wrapper.wrapped
    }

    @Published private(set) var uiState: any NiaKit.InterestsUiState = NiaKit.InterestsUiStateLoading.shared

    init(initialTopicId: String? = nil) {
        let viewModel = IosViewModelProvider.shared.createInterestsViewModel(initialTopicId: initialTopicId)
        wrapper = InterestsViewModelWrapper(wrapped: viewModel)
        owner.put(viewModel: viewModel)

        wrapper.observeUiState { [weak self] state in self?.uiState = state }
    }

    deinit {
        owner.clear()
    }
}
