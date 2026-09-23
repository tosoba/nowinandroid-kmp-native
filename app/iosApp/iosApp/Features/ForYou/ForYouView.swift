import NiaKit
import SwiftUI

struct ForYouView: View {
    private let onTopicClick: (String) -> Void

    @StateObject private var viewModel = ForYouViewModel()

    @Environment(\.openURL) private var openURL

    init(onTopicClick: @escaping (String) -> Void) {
        self.onTopicClick = onTopicClick
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: NiaSpacing.mediumLarge) {
                    onboarding

                    newsFeed
                        .padding(.horizontal, NiaSpacing.medium)
                }
                .padding(.bottom, NiaSpacing.small)
            }

            if viewModel.isLoading {
                loadingOverlay
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.25), value: viewModel.isLoading)
        .animation(.easeInOut(duration: 0.25), value: viewModel.showsOnboarding)
        .animation(.easeInOut(duration: 0.25), value: viewModel.feedAnimationKey)
        .navigationTitle(String(\.feature_foryou_api_title))
        .onChange(of: viewModel.deepLinkedNewsResource?.id) { _, _ in
            if let url = viewModel.consumeDeepLinkURL() {
                openURL(url)
            }
        }
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
        .padding(.top, NiaSpacing.small)
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
}

private struct ForYouOnboardingView: View {
    let state: OnboardingUiStateShown
    let onTopicCheckedChanged: (String, Bool) -> Void
    let saveFollowedTopics: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: NiaSpacing.none) {
            Text(String(\.feature_foryou_api_onboarding_guidance_title))
                .font(.system(.title3, design: .default).weight(.medium))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, NiaSpacing.mediumLarge)

            Text(String(\.feature_foryou_api_onboarding_guidance_subtitle))
                .font(.body)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, NiaSpacing.small)
                .padding(.horizontal, NiaSpacing.mediumLarge)

            TopicSelectionView(
                topics: state.topics,
                onTopicCheckedChanged: onTopicCheckedChanged
            )
            .padding(.bottom, NiaSpacing.small)

            HStack {
                Spacer()

                NiaFilledButtonView(
                    title: String(\.feature_foryou_api_done),
                    enabled: state.isDismissable,
                    maxWidth: 364
                ) {
                    saveFollowedTopics()
                }
                .padding(.horizontal, NiaSpacing.mediumLarge)
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
            LazyHGrid(rows: [GridItem(), GridItem(), GridItem()], spacing: NiaSpacing.mediumSmall) {
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
        .contentMargins(.horizontal, NiaSpacing.mediumLarge, for: .scrollContent)
        .contentMargins(.vertical, NiaSpacing.mediumLarge, for: .scrollContent)
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
            HStack(spacing: NiaSpacing.none) {
                NiaDynamicAsyncImageView(
                    imageUrl: topic.imageUrl,
                    placeholder: ForYouImages().feature_foryou_api_ic_icon_placeholder
                )
                .frame(width: 32, height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding(NiaSpacing.mediumSmall)

                Text(topic.name)
                    .font(.system(.body, design: .default).weight(.medium))
                    .foregroundColor(colors.onSurface)
                    .lineLimit(1)
                    .padding(.horizontal, NiaSpacing.mediumSmall)

                Spacer(minLength: 0)

                NiaIconToggleButtonView(
                    checked: isSelected,
                    icon: NiaIcons.shared.Add,
                    checkedIcon: NiaIcons.shared.Check,
                    contentDescription: topic.name
                ) {
                    _ in onClick(!isSelected)
                }
                .padding(.trailing, NiaSpacing.small)
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
