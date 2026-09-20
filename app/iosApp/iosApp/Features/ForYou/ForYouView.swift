import NiaKit
import SwiftUI

/// `forYou` tab destination, mirroring the shared Kotlin `feature/foryou` module.
struct ForYouView: View {
    @StateObject private var viewModel = ForYouViewModel()

    var body: some View {
        Text("ForYouView")
    }
}
