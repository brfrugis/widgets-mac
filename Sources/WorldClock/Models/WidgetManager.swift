import Foundation
import AppKit
import Combine

class WidgetManager: ObservableObject {
    static let shared = WidgetManager()
    
    @Published var isWidgetVisible = true
    var desktopWindow: NSWindow? // Changed to strong reference
    
    private init() {}
    
    func toggleWidget() {
        if isWidgetVisible {
            hideWidget()
        } else {
            showWidget()
        }
    }
    
    func showWidget() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let window = self.desktopWindow else { 
                print("⚠️ Cannot show widget - window reference is nil")
                return 
            }
            
            print("✅ Showing widget window")
            self.isWidgetVisible = true
            
            // Make window visible
            window.orderFront(nil)
            window.makeKeyAndOrderFront(nil)
            
            // Force redraw
            window.display()
        }
    }
    
    func hideWidget() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let window = self.desktopWindow else { 
                print("⚠️ Cannot hide widget - window reference is nil")
                return 
            }
            
            print("✅ Hiding widget window")
            self.isWidgetVisible = false
            window.orderOut(nil)
        }
    }
}
