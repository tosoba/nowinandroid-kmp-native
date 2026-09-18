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
    @State private var searchQuery = ""
    /// Fallback state for iOS < 26 (pre search-tab activation).
    @State private var isSearchPresented = false

    var body: some View {
        if #available(iOS 26.0, *) {
            modernTabView
        } else {
            legacyTabView
        }
    }

    @available(iOS 26.0, *)
    private var modernTabView: some View {
        TabView(selection: $selection) {
            Tab(value: TabSelection.forYou) {
                ForYouView()
            } label: {
                Label(String(\.feature_foryou_api_title), systemImage: "house")
            }

            Tab(value: TabSelection.bookmarks) {
                BookmarksView()
            } label: {
                Label(String(\.feature_bookmarks_api_title), systemImage: "bookmark")
            }

            Tab(value: TabSelection.interests) {
                InterestsView()
            } label: {
                Label(String(\.feature_interests_api_title), systemImage: "star")
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
                        Label(String(\.feature_foryou_api_title), systemImage: "house")
                    }

                BookmarksView()
                    .tabItem {
                        Label(String(\.feature_bookmarks_api_title), systemImage: "bookmark")
                    }

                InterestsView()
                    .tabItem {
                        Label(String(\.feature_interests_api_title), systemImage: "star")
                    }
            }
            .navigationTitle(String(\.app_name))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isSearchPresented = true
                    } label: {
                        Image(systemName: "magnifyingglass")
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

struct ForYouView: View {
    var body: some View {
        Text("ForYouView")
    }
}

struct BookmarksView: View {
    var body: some View {
        Text("BookmarksView")
    }
}

struct InterestsView: View {
    var body: some View {
        Text("InterestsView")
    }
}

struct TopicView: View {
    var body: some View {
        Text("TopicView")
    }
}

struct SearchView: View {
    @Binding var query: String

    var body: some View {
        Text(query.isEmpty ? "SearchView" : "SearchView: \(query)")
    }
}
