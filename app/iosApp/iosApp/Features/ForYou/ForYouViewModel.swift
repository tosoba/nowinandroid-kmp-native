import NiaKit
import SwiftUI

@MainActor
final class ForYouViewModel: ObservableObject {
    private let owner = IosViewModelStoreOwner()
    private let wrapper: ForYouViewModelWrapper

    var wrapped: NiaKit.ForYouViewModel {
        wrapper.wrapped
    }

    @Published private(set) var isSyncing: Bool = false
    @Published private(set) var deepLinkedNewsResource: ModelUserNewsResource? = nil
    @Published private(set) var feedState: any NewsFeedUiState = NewsFeedUiStateLoading.shared
    @Published private(set) var onboardingUiState: any OnboardingUiState = OnboardingUiStateLoading.shared

    init() {
        let viewModel = IosViewModelProvider.shared.createForYouViewModel()
        wrapper = ForYouViewModelWrapper(wrapped: viewModel)
        owner.put(viewModel: viewModel)

        wrapper.observeIsSyncing(onChange: { [weak self] value in self?.isSyncing = value.boolValue })
        wrapper.observeDeepLinkedNewsResource(onChange: { [weak self] value in self?.deepLinkedNewsResource = value })
        wrapper.observeFeedState(onChange: { [weak self] state in self?.feedState = state })
        wrapper.observeOnboardingUiState(onChange: { [weak self] state in self?.onboardingUiState = state })
    }

    deinit {
        owner.clear()
    }

    var isLoading: Bool {
        isSyncing || feedState is NewsFeedUiStateLoading || onboardingUiState is OnboardingUiStateLoading
    }

    var showsOnboarding: Bool {
        onboardingUiState is OnboardingUiStateShown
    }

    var feedAnimationKey: String {
        let prefix = String(describing: type(of: feedState))
        guard let state = feedState as? NewsFeedUiStateSuccess else { return prefix }
        let resourceIds = state.feed.map(\.id).joined(separator: ",")
        return "\(prefix)|resources:\(resourceIds)"
    }

    func consumeDeepLinkURL() -> URL? {
        guard let newsResource = deepLinkedNewsResource else { return nil }

        if !newsResource.hasBeenViewed {
            wrapped.onDeepLinkOpened(newsResourceId: newsResource.id)
        }

        return URL(string: newsResource.url)
    }
}
