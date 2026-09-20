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

            case let state as NiaKit.InterestsUiStateInterests:
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
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
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                }

            default:
                NiaLoadingWheelView(contentDescription: String(\.feature_interests_api_loading))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(String(\.feature_interests_api_title))
    }
}
