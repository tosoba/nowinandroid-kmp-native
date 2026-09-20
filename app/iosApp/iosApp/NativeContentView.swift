import NiaKit
import SwiftUI

struct NativeContentView: View {
    enum TabSelection: Hashable {
        case forYou
        case bookmarks
        case interests
        case search
    }

    @State private var selection: TabSelection = .forYou

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
        TabView(selection: $selection) {
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
        TabView(selection: $selection) {
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
        NavigationStack {
            ForYouView()
        }
    }

    private var bookmarksContent: some View {
        NavigationStack {
            BookmarksView()
        }
    }

    private var interestsContent: some View {
        NavigationStack {
            InterestsView()
        }
    }

    private var searchContent: some View {
        NavigationStack {
            SearchView()
        }
    }
}
