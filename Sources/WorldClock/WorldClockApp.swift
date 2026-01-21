import SwiftUI

@main
struct WorldClockApp: App {
    @StateObject private var timeZoneManager = TimeZoneManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timeZoneManager)
                .frame(minWidth: 500, minHeight: 400)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        
        MenuBarExtra("World Clock", systemImage: "clock.fill") {
            MenuBarView()
                .environmentObject(timeZoneManager)
        }
    }
}
