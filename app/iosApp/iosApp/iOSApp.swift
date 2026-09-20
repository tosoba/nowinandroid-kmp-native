import NiaKit
import SDWebImage
import SDWebImageSVGCoder
import SwiftUI

@main
struct iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }

    var body: some Scene {
        WindowGroup {
            #if COMPOSE_UI
                ComposeContentView()
            #else
                NativeContentView()
            #endif
        }
    }
}
