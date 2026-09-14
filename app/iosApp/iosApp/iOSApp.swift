import SwiftUI

@main
struct iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            #if COMPOSE_UI
                ComposeContentView()
                    .ignoresSafeArea(.all)
            #else
                NativeContentView()
                    .ignoresSafeArea(.all)
            #endif
        }
    }
}
