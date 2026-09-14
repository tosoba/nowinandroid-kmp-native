import SwiftUI

@main
struct iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
#if COMPOSE_UI
            ContentView()
                .ignoresSafeArea(.all)
#else
            NativeContentView()
                .ignoresSafeArea(.all)
#endif
        }
    }
}
