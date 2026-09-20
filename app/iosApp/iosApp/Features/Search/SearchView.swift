import SwiftUI

/// Search destination, mirroring the shared Kotlin `feature/search` module.
/// On iOS 26+ it is hosted in the dedicated search tab; on earlier versions it
/// is presented via a navigation destination from the toolbar search button.
struct SearchView: View {
    @Binding var query: String

    var body: some View {
        Text(query.isEmpty ? "SearchView" : "SearchView: \(query)")
    }
}
