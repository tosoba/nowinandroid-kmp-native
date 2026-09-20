import NiaKit
import SwiftUI

struct ForYouView: View {
    @StateObject private var viewModel = ForYouViewModel()

    var body: some View {
        Text("ForYouView")
            .navigationTitle(String(\.app_name))
    }
}
