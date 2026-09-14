import NiaKit
import SwiftUI
import UIKit

struct ComposeView: UIViewControllerRepresentable {
    func makeUIViewController(context _: Context) -> UIViewController {
        MainViewControllerKt.MainViewController()
    }

    func updateUIViewController(_: UIViewController, context _: Context) {}
}

struct ComposeContentView: View {
    var body: some View {
        ComposeView()
            .ignoresSafeArea()
    }
}
