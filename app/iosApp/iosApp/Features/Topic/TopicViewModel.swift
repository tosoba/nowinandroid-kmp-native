import NiaKit
import SwiftUI

@MainActor
final class TopicViewModel: ObservableObject {
    private let owner = IosViewModelStoreOwner()
    private let wrapper: TopicViewModelWrapper

    var wrapped: NiaKit.TopicViewModel {
        wrapper.wrapped
    }

    let topicId: String

    @Published private(set) var topicUiState: any TopicUiState = TopicUiStateLoading.shared
    @Published private(set) var newsUiState: any NewsUiState = NewsUiStateLoading.shared

    init(topicId: String) {
        self.topicId = topicId
        let viewModel = IosViewModelProvider.shared.createTopicViewModel(topicId: topicId)
        wrapper = TopicViewModelWrapper(wrapped: viewModel)
        owner.put(viewModel: viewModel)

        wrapper.observeTopicUiState { [weak self] state in self?.topicUiState = state }
        wrapper.observeNewsUiState { [weak self] state in self?.newsUiState = state }
    }

    deinit {
        owner.clear()
    }
}
