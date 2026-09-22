import NiaKit
import SwiftUI

struct NativeContentView: View {
    private enum TabDestination: Hashable {
        case topic(id: String)
    }

    private enum TabSelection: Hashable {
        case forYou
        case bookmarks
        case interests
        case search
    }

    @State private var tabSelection: TabSelection = .forYou

    @State private var forYouPath: [TabDestination] = []
    @State private var bookmarksPath: [TabDestination] = []
    @State private var interestsPath: [TabDestination] = []
    @State private var searchPath: [TabDestination] = []

    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                modernTabs
            } else {
                legacyTabs
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .niaTheme()
    }

    @available(iOS 26.0, *)
    private var modernTabs: some View {
        TabView(selection: $tabSelection) {
            Tab(value: TabSelection.forYou) {
                forYouContent
            } label: {
                Label(String(\.feature_foryou_api_title), iconResource: NiaIcons.shared.Upcoming)
            }

            Tab(value: TabSelection.bookmarks) {
                bookmarksContent
            } label: {
                Label(String(\.feature_bookmarks_api_title), iconResource: NiaIcons.shared.Bookmarks)
            }

            Tab(value: TabSelection.interests) {
                interestsContent
            } label: {
                Label(String(\.feature_interests_api_title), iconResource: NiaIcons.shared.Grid3x3)
            }

            Tab(value: TabSelection.search, role: .search) {
                searchContent
            }
        }
        .tabViewSearchActivation(.searchTabSelection)
    }

    private var legacyTabs: some View {
        TabView(selection: $tabSelection) {
            forYouContent
                .tabItem {
                    Label(String(\.feature_foryou_api_title), iconResource: NiaIcons.shared.Upcoming)
                }

            bookmarksContent
                .tabItem {
                    Label(String(\.feature_bookmarks_api_title), iconResource: NiaIcons.shared.Bookmarks)
                }

            interestsContent
                .tabItem {
                    Label(String(\.feature_interests_api_title), iconResource: NiaIcons.shared.Grid3x3)
                }

            searchContent
                .tabItem {
                    Label(String(\.feature_search_api_title), iconResource: NiaIcons.shared.Search)
                }
        }
    }

    private var forYouContent: some View {
        navigationStack(path: $forYouPath) {
            ForYouView { topicID in
                forYouPath.append(.topic(id: topicID))
            }
        }
    }

    private var bookmarksContent: some View {
        navigationStack(path: $bookmarksPath) {
            BookmarksView { topicID in
                bookmarksPath.append(.topic(id: topicID))
            }
        }
    }

    private var interestsContent: some View {
        navigationStack(path: $interestsPath) {
            InterestsView { topicID in
                interestsPath.append(.topic(id: topicID))
            }
        }
    }

    private var searchContent: some View {
        navigationStack(path: $searchPath) {
            SearchView { topicID in
                searchPath.append(.topic(id: topicID))
            }
        }
    }

    private func navigationStack<Content: View>(
        path: Binding<[TabDestination]>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationStack(path: path) {
            content()
                .navigationDestination(for: TabDestination.self) { destination in
                    switch destination {
                    case let .topic(id):
                        TopicView(
                            topicId: id,
                            onTopicClick: { topicID in
                                guard case let .topic(id) = path.wrappedValue.last, id == topicID else {
                                    path.wrappedValue.append(.topic(id: topicID))
                                    return
                                }
                            }
                        )
                    }
                }
        }
    }
}
