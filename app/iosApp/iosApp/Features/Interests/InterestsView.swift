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
                            .transition(.opacity)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                }

            default:
                NiaLoadingWheelView(contentDescription: String(\.feature_interests_api_loading))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: interestsAnimationKey)
        .navigationTitle(String(\.feature_interests_api_title))
    }

    private var interestsAnimationKey: String {
        let state = String(describing: type(of: viewModel.uiState))
        guard let interests = viewModel.uiState as? NiaKit.InterestsUiStateInterests else {
            return state
        }

        let topicIds = interests.topics.map { $0.topic.id }.joined(separator: ",")
        return "\(state)|topics:\(topicIds)"
    }
}
