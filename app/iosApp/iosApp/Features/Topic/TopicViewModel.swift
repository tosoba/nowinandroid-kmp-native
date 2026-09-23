import NiaKit
import SwiftUI

@MainActor
final class TopicViewModel: ObservableObject {
    private let topicId: String

    private let owner = IosViewModelStoreOwner()
    private let wrapper: TopicViewModelWrapper

    var wrapped: NiaKit.TopicViewModel {
        wrapper.wrapped
    }

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

    var topicName: String {
        guard let state = topicUiState as? TopicUiStateSuccess else { return "" }
        return state.followableTopic.topic.name
    }

    var isFollowed: Bool? {
        (topicUiState as? TopicUiStateSuccess)?.followableTopic.isFollowed
    }

    var topicAnimationKey: String {
        String(describing: type(of: topicUiState))
    }

    var newsAnimationKey: String {
        let prefix = String(describing: type(of: newsUiState))
        guard let state = newsUiState as? NewsUiStateSuccess else { return prefix }
        let resourceIds = state.news.map(\.id).joined(separator: ",")
        return "\(prefix)|resources:\(resourceIds)"
    }
}
