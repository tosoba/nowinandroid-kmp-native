import NiaKit
import SwiftUI

struct BookmarksView: View {
    private let onTopicClick: (String) -> Void

    @StateObject private var viewModel = BookmarksViewModel()
    @State private var showUndoBanner = false

    @Environment(\.openURL) private var openURL
    @Environment(\.niaColors) private var colors

    init(onTopicClick: @escaping (String) -> Void) {
        self.onTopicClick = onTopicClick
    }

    private var feedAnimationKey: String {
        let prefix = String(describing: type(of: viewModel.feedState))
        guard let state = viewModel.feedState as? NiaKit.NewsFeedUiStateSuccess else { return prefix }
        let resourceIds = state.feed.map { $0.id }.joined(separator: ",")
        return "\(prefix)|resources:\(resourceIds)"
    }

    var body: some View {
        Group {
            if let state = viewModel.feedState as? NiaKit.NewsFeedUiStateSuccess {
                if state.feed.isEmpty {
                    emptyState
                        .transition(.opacity)
                } else {
                    bookmarksList(state)
                        .transition(.opacity)
                }
            } else {
                loadingState
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.25), value: feedAnimationKey)
        .navigationTitle(String(\.feature_bookmarks_api_title))
        .overlay(alignment: .bottom) {
            Group {
                if showUndoBanner {
                    undoBanner
                        .padding(.bottom, 16)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.25), value: showUndoBanner)
        }
        .onChange(of: showUndoBanner) { _, shown in
            guard shown else { return }

            Task {
                try? await Task.sleep(nanoseconds: 4_000_000_000)
                if showUndoBanner {
                    showUndoBanner = false
                    viewModel.wrapped.clearUndoState()
                }
            }
        }
    }

    private func bookmarksList(_ state: NewsFeedUiStateSuccess) -> some View {
        ScrollView {
            NewsFeedListView(
                feed: state.feed,
                onToggleBookmark: { news in
                    viewModel.wrapped.removeFromSavedResources(newsResourceId: news.id)
                    showUndoBanner = true
                },
                onClick: { news in
                    if let url = URL(string: news.url) {
                        openURL(url)
                    }
                    viewModel.wrapped.setNewsResourceViewed(
                        newsResourceId: news.id,
                        viewed: true
                    )
                },
                onTopicClick: { id in onTopicClick(id) }
            )
            .padding(16)
            .padding(.bottom, 8)
        }
    }

    private var loadingState: some View {
        NiaLoadingWheelView(contentDescription: String(\.feature_bookmarks_api_loading))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(FeatureBookmarksApiMR.images().feature_bookmarks_api_mg_empty_bookmarks)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 64)
                .padding(.horizontal, 16)

            Spacer().frame(height: 40)

            Text(String(\.feature_bookmarks_api_empty_error))
                .font(.system(.body, design: .default).weight(.semibold))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            Text(String(\.feature_bookmarks_api_empty_description))
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var undoBanner: some View {
        HStack {
            Text(String(\.feature_bookmarks_api_removed))

            Spacer()

            Button(String(\.feature_bookmarks_api_undo)) {
                showUndoBanner = false
                viewModel.wrapped.undoBookmarkRemoval()
            }
            .bold()
        }
        .font(.subheadline)
        .foregroundStyle(colors.inverseOnSurface)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Capsule().fill(colors.inverseSurface.shadow(.drop(color: .black.opacity(0.3), radius: 8, y: 2)))
        )
        .padding(.horizontal, 16)
    }
}
