import NiaKit
import SwiftUI

struct ForYouView: View {
    let onTopicClick: (String) -> Void

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
        .animation(.easeInOut(duration: 0.25), value: feedCount)
        .navigationTitle(String(\.feature_foryou_api_title))
    }

    private var showsOnboarding: Bool {
        viewModel.onboardingUiState is OnboardingUiStateShown
    }

    private var feedCount: Int {
        (viewModel.feedState as? NewsFeedUiStateSuccess)?.feed.count ?? 0
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
            NiaOverlayLoadingWheel(contentDescription: String(\.feature_foryou_api_loading))
            Spacer()
        }
        .padding(.top, 8)
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    // MARK: - Onboarding

    @ViewBuilder
    private var onboarding: some View {
        if let shown = viewModel.onboardingUiState as? OnboardingUiStateShown {
            ForYouOnboardingView(
                shown: shown,
                onTopicCheckedChanged: { topicId, isChecked in
                    viewModel.wrapped.updateTopicSelection(topicId: topicId, isChecked: isChecked)
                },
                saveFollowedTopics: { viewModel.wrapped.dismissOnboarding() }
            )
            .transition(.opacity)
        }
    }

    // MARK: - News feed

    @ViewBuilder
    private var newsFeed: some View {
        if let success = viewModel.feedState as? NewsFeedUiStateSuccess {
            NewsFeedListView(
                feed: success.feed,
                onToggleBookmark: { news in
                    viewModel.wrapped.updateNewsResourceSaved(
                        newsResourceId: news.id,
                        isChecked: !news.isSaved
                    )
                },
                onClick: { news in
                    if let url = URL(string: news.url) {
                        openURL(url)
                    }
                    viewModel.wrapped.setNewsResourceViewed(newsResourceId: news.id, viewed: true)
                },
                onTopicClick: onTopicClick
            )
        }
    }
}

// MARK: - Onboarding

private struct ForYouOnboardingView: View {
    let shown: OnboardingUiStateShown
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
                topics: shown.topics,
                onTopicCheckedChanged: onTopicCheckedChanged
            )
            .padding(.bottom, 8)

            HStack {
                Spacer()

                NiaFilledButtonView(
                    title: String(\.feature_foryou_api_done),
                    enabled: shown.isDismissable,
                    maxWidth: 364
                ) {
                    saveFollowedTopics()
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

// MARK: - Topic selection

private struct TopicSelectionView: View {
    @Environment(\.niaColors) private var colors

    let topics: [ModelFollowableTopic]
    let onTopicCheckedChanged: (String, Bool) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(), GridItem(), GridItem()], spacing: 12) {
                ForEach(topics, id: \.topic.id) { followableTopic in
                    SingleTopicButtonView(
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

private struct SingleTopicButtonView: View {
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
