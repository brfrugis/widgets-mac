import SwiftUI
import AppKit

@main
struct WorldClockApp: App {
    @StateObject private var timeZoneManager = TimeZoneManager.shared
    @StateObject private var widgetManager = WidgetManager.shared
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("World Clock", systemImage: "clock.fill") {
            MenuBarView()
                .environmentObject(timeZoneManager)
                .environmentObject(widgetManager)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var desktopWindow: FloatingWindow? // Strong reference to keep window alive
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create desktop widget window
        let contentView = DesktopWidgetView()
            .environmentObject(TimeZoneManager.shared)
            .environmentObject(WidgetManager.shared)
        
        let window = FloatingWindow(
            contentRect: NSRect(x: 100, y: 100, width: 480, height: 380),
            styleMask: [.borderless, .titled, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        // Create hosting view
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.wantsLayer = true
        window.contentView = hostingView
        
        window.backgroundColor = .clear
        window.isOpaque = false
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        
        // Set window level BELOW normal windows but above desktop
        // This makes it go behind active app windows
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.normalWindow)) - 1)
        
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]
        window.isMovableByWindowBackground = true
        window.hasShadow = true
        
        // CRITICAL: Make sure window captures mouse events
        window.ignoresMouseEvents = false
        
        // Prevent hiding on deactivate
        window.hidesOnDeactivate = false
        
        // Position window at bottom right
        if let screen = NSScreen.main {
            let screenRect = screen.visibleFrame
            let windowRect = window.frame
            let x = screenRect.maxX - windowRect.width - 20
            let y = screenRect.minY + 20
            window.setFrameOrigin(NSPoint(x: x, y: y))
        }
        
        window.orderFront(nil)
        
        // Keep strong references in both places
        self.desktopWindow = window
        WidgetManager.shared.desktopWindow = window
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}

// Custom floating window that properly captures mouse events
class FloatingWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
    }
    
    override var canBecomeKey: Bool { 
        return true
    }
    
    override var canBecomeMain: Bool { 
        return false 
    }
}
