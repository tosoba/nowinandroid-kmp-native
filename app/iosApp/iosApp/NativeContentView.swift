import CoreModel
import CoreUi
import FeatureForYou
import NiaKit
import SwiftUI

private typealias UserNewsResource = CoreModel.data.UserNewsResource
private typealias NewsFeedUiState = CoreUi.NewsFeedUiState
private typealias OnboardingUiState = FeatureForYou.OnboardingUiState

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

struct ForYouView: View {
    @StateObject private var viewModel = ForYouViewModel()

    var body: some View {
        Text("ForYouView")
            .task {
                await viewModel.observeState()
            }
    }
}

@MainActor
class ForYouViewModel: ObservableObject {
    private let owner = IosViewModelStoreOwner()
    private let wrapped: FeatureForYou.ForYouViewModel

    @Published private(set) var isSyncing: Bool = false
    @Published private(set) var deepLinkedNewsResource: UserNewsResource? = nil
    @Published private(set) var feedState: any NewsFeedUiState = NewsFeedUiStateLoading.shared
    @Published private(set) var onboardingUiState: any OnboardingUiState = OnboardingUiStateLoading.shared

    init() {
        wrapped = IosViewModelProvider.shared.createForYouViewModel()
        owner.put(viewModel: wrapped)
    }

    func observeState() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { [wrapped] in
                try? await self.collect(wrapped.isSyncing.asAsyncSequence()) { value in
                    self.isSyncing = value
                }
            }
            group.addTask { [wrapped] in
                try? await self.collect(wrapped.deepLinkedNewsResource.asAsyncSequence()) { value in
                    self.deepLinkedNewsResource = value
                }
            }
            group.addTask { [wrapped] in
                try? await self.collect(wrapped.feedState.asAsyncSequence()) { value in
                    self.feedState = value
                }
            }
            group.addTask { [wrapped] in
                try? await self.collect(wrapped.onboardingUiState.asAsyncSequence()) { value in
                    self.onboardingUiState = value
                }
            }
        }
    }

    private func collect<Sequence: AsyncSequence>(
        _ sequence: Sequence,
        onValue: @escaping (Sequence.Element) -> Void
    ) async throws {
        for try await value in sequence {
            onValue(value)
        }
    }

    deinit {
        owner.clear()
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
