import SwiftUI

struct SearchView: View {
    @State private var query = ""

    var body: some View {
        if #available(iOS 26.0, *) {
            searchContent
                .searchable(text: $query)
        } else {
            searchContent
                .searchable(
                    text: $query,
                    placement: .navigationBarDrawer(displayMode: .always)
                )
        }
    }

    private var searchContent: some View {
        Text(query.isEmpty ? "SearchView" : "SearchView: \(query)")
            .navigationTitle(String(\.feature_search_api_title))
    }
}
