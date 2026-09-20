import NiaKit
import SwiftUI

/// Root view of the native (SwiftUI) UI: owns the main tab navigation and
/// hosts one destination view per shared Kotlin feature module (the feature
/// views live under `Features/`, mirroring the shared module layout).
struct NativeContentView: View {
    enum TabSelection: Hashable {
        case forYou
        case bookmarks
        case interests
        case search
    }

    @State private var selection: TabSelection = .forYou
    @State private var searchQuery = ""
    /// Fallback state for iOS < 26 (pre search-tab activation).
    @State private var isSearchPresented = false

    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                modernTabView
            } else {
                legacyTabView
            }
        }
        .niaTheme()
    }

    @available(iOS 26.0, *)
    private var modernTabView: some View {
        TabView(selection: $selection) {
            Tab(value: TabSelection.forYou) {
                ForYouView()
            } label: {
                Label(String(\.feature_foryou_api_title), iconResource: NiaIcons.shared.Upcoming)
            }

            Tab(value: TabSelection.bookmarks) {
                BookmarksView()
            } label: {
                Label(String(\.feature_bookmarks_api_title), iconResource: NiaIcons.shared.Bookmarks)
            }

            Tab(value: TabSelection.interests) {
                InterestsView()
            } label: {
                Label(String(\.feature_interests_api_title), iconResource: NiaIcons.shared.Grid3x3)
            }

            Tab(value: TabSelection.search, role: .search) {
                NavigationStack {
                    SearchView(query: $searchQuery)
                }
            }
        }
        .searchable(text: $searchQuery)
        .tabViewSearchActivation(.searchTabSelection)
        .tabViewStyle(.sidebarAdaptable)
    }

    private var legacyTabView: some View {
        NavigationStack {
            TabView {
                ForYouView()
                    .tabItem {
                        Label(String(\.feature_foryou_api_title), iconResource: NiaIcons.shared.Upcoming)
                    }

                BookmarksView()
                    .tabItem {
                        Label(String(\.feature_bookmarks_api_title), iconResource: NiaIcons.shared.Bookmarks)
                    }

                InterestsView()
                    .tabItem {
                        Label(String(\.feature_interests_api_title), iconResource: NiaIcons.shared.Grid3x3)
                    }
            }
            .navigationTitle(String(\.app_name))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isSearchPresented = true
                    } label: {
                        Image(NiaIcons.shared.Search)
                    }
                    .accessibilityLabel("Search")
                }
            }
            .navigationDestination(isPresented: $isSearchPresented) {
                SearchView(query: $searchQuery)
            }
            .tabViewStyle(.sidebarAdaptable)
        }
    }
}
