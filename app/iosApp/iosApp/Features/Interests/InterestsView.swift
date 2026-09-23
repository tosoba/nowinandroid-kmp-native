import NiaKit
import SwiftUI

struct InterestsView: View {
    let onTopicClick: (String) -> Void

    @StateObject private var viewModel = InterestsViewModel()

    var body: some View {
        Group {
            switch viewModel.uiState {
            case _ as NiaKit.InterestsUiStateEmpty:
                Text(String(\.feature_interests_api_empty_header))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)

            case let state as NiaKit.InterestsUiStateInterests:
                interestsList(state)

            default:
                NiaLoadingWheelView(contentDescription: String(\.feature_interests_api_loading))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.interestsAnimationKey)
        .navigationTitle(String(\.feature_interests_api_title))
    }

    private func interestsList(_ state: InterestsUiStateInterests) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: NiaSpacing.none) {
                ForEach(state.topics, id: \.topic.id) { followableTopic in
                    InterestsItemView(
                        name: followableTopic.topic.name,
                        following: followableTopic.isFollowed,
                        topicImageUrl: followableTopic.topic.imageUrl,
                        onClick: {
                            viewModel.wrapped.onTopicClick(topicId: followableTopic.topic.id)
                            onTopicClick(followableTopic.topic.id)
                        },
                        onFollowButtonClick: { _ in
                            viewModel.wrapped.followTopic(
                                followedTopicId: followableTopic.topic.id,
                                followed: !followableTopic.isFollowed
                            )
                        },
                        description: followableTopic.topic.shortDescription,
                        isSelected: followableTopic.topic.id == state.selectedTopicId
                    )
                    .transition(.opacity)
                }
            }
            .padding(.horizontal, NiaSpacing.mediumLarge)
            .padding(.vertical, NiaSpacing.medium)
        }
    }
}
