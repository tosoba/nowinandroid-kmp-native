import NiaKit
import SwiftUI

struct ForYouView: View {
    private let onTopicClick: (String) -> Void

    @StateObject private var viewModel = ForYouViewModel()

    @Environment(\.niaColors) private var colors
    @Environment(\.openURL) private var openURL

    init(onTopicClick: @escaping (String) -> Void) {
        self.onTopicClick = onTopicClick
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    onboarding

                    newsFeed
                        .padding(.horizontal, 16)
                }
                .padding(.bottom, 8)
            }

            if isLoading {
                loadingOverlay
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.25), value: isLoading)
        .animation(.easeInOut(duration: 0.25), value: showsOnboarding)
        .animation(.easeInOut(duration: 0.25), value: feedAnimationKey)
        .navigationTitle(String(\.feature_foryou_api_title))
        .onChange(of: viewModel.deepLinkedNewsResource?.id) { _, _ in
            handleDeepLink()
        }
    }

    private var showsOnboarding: Bool {
        viewModel.onboardingUiState is OnboardingUiStateShown
    }

    private var feedAnimationKey: String {
        let prefix = String(describing: type(of: viewModel.feedState))
        guard let state = viewModel.feedState as? NewsFeedUiStateSuccess else { return prefix }
        let resourceIds = state.feed.map { $0.id }.joined(separator: ",")
        return "\(prefix)|resources:\(resourceIds)"
    }

    private var isLoading: Bool {
        viewModel.isSyncing || isFeedLoading || isOnboardingLoading
    }

    private var isFeedLoading: Bool {
        viewModel.feedState is NewsFeedUiStateLoading
    }

    private var isOnboardingLoading: Bool {
        viewModel.onboardingUiState is OnboardingUiStateLoading
    }

    private var loadingOverlay: some View {
        HStack {
            Spacer()
            NiaLoadingWheelView(
                contentDescription: String(\.feature_foryou_api_loading),
                style: .overlay
            )
            Spacer()
        }
        .padding(.top, 8)
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    @ViewBuilder
    private var onboarding: some View {
        if let state = viewModel.onboardingUiState as? OnboardingUiStateShown {
            ForYouOnboardingView(
                state: state,
                onTopicCheckedChanged: { topicId, isChecked in
                    viewModel.wrapped.updateTopicSelection(topicId: topicId, isChecked: isChecked)
                },
                saveFollowedTopics: { viewModel.wrapped.dismissOnboarding() }
            )
            .transition(.opacity)
        }
    }

    @ViewBuilder
    private var newsFeed: some View {
        if let state = viewModel.feedState as? NewsFeedUiStateSuccess {
            NewsFeedListView(
                feed: state.feed,
                onToggleBookmark: { news in
                    viewModel.wrapped.updateNewsResourceSaved(
                        newsResourceId: news.id,
                        isChecked: !news.isSaved
                    )
                },
                onClick: { news in
                    guard let url = URL(string: news.url) else { return }
                    openURL(url)
                    viewModel.wrapped.setNewsResourceViewed(newsResourceId: news.id, viewed: true)
                },
                onTopicClick: onTopicClick
            )
            .transition(.opacity)
        }
    }
    
    private func handleDeepLink() {
        guard let newsResource = viewModel.deepLinkedNewsResource else { return }

        if !newsResource.hasBeenViewed {
            viewModel.wrapped.onDeepLinkOpened(newsResourceId: newsResource.id)
        }

        guard let url = URL(string: newsResource.url) else { return }
        openURL(url)
    }
}

private struct ForYouOnboardingView: View {
    let state: OnboardingUiStateShown
    let onTopicCheckedChanged: (String, Bool) -> Void
    let saveFollowedTopics: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(String(\.feature_foryou_api_onboarding_guidance_title))
                .font(.system(.title3, design: .default).weight(.medium))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 24)

            Text(String(\.feature_foryou_api_onboarding_guidance_subtitle))
                .font(.body)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                .padding(.horizontal, 24)

            TopicSelectionView(
                topics: state.topics,
                onTopicCheckedChanged: onTopicCheckedChanged
            )
            .padding(.bottom, 8)

            HStack {
                Spacer()

                NiaFilledButtonView(
                    title: String(\.feature_foryou_api_done),
                    enabled: state.isDismissable,
                    maxWidth: 364
                ) {
                    saveFollowedTopics()
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

private struct TopicSelectionView: View {
    @Environment(\.niaColors) private var colors

    let topics: [ModelFollowableTopic]
    let onTopicCheckedChanged: (String, Bool) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(), GridItem(), GridItem()], spacing: 12) {
                ForEach(topics, id: \.topic.id) { followableTopic in
                    TopicButtonView(
                        topic: followableTopic.topic,
                        isSelected: followableTopic.isFollowed,
                        onClick: { checked in
                            onTopicCheckedChanged(followableTopic.topic.id, checked)
                        }
                    )
                }
            }
        }
        .contentMargins(.horizontal, 24, for: .scrollContent)
        .contentMargins(.vertical, 24, for: .scrollContent)
        .frame(height: 240)
        .frame(maxWidth: .infinity)
    }
}

private struct TopicButtonView: View {
    @Environment(\.niaColors) private var colors

    let topic: ModelTopic
    let isSelected: Bool
    let onClick: (Bool) -> Void

    var body: some View {
        Button(action: { onClick(!isSelected) }) {
            HStack(spacing: 0) {
                NiaDynamicAsyncImageView(
                    imageUrl: topic.imageUrl,
                    placeholder: FeatureForyouApiMR.images().feature_foryou_api_ic_icon_placeholder
                )
                .frame(width: 32, height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding(10)

                Text(topic.name)
                    .font(.system(.body, design: .default).weight(.medium))
                    .foregroundColor(colors.onSurface)
                    .lineLimit(1)
                    .padding(.horizontal, 12)

                Spacer(minLength: 0)

                NiaIconToggleButtonView(
                    checked: isSelected,
                    icon: NiaIcons.shared.Add,
                    checkedIcon: NiaIcons.shared.Check,
                    contentDescription: topic.name
                ) {
                    _ in onClick(!isSelected)
                }
                .padding(.trailing, 8)
            }
            .frame(minHeight: 56)
            .frame(width: 312)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? colors.primaryContainer : colors.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(isSelected ? colors.primary : colors.outline, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
