import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var timeZoneManager: TimeZoneManager
    @State private var currentTime = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if timeZoneManager.selectedTimeZones.isEmpty {
                Text("No timezones configured")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(timeZoneManager.selectedTimeZones) { timezone in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(timezone.city)
                                .font(.system(size: 12, weight: .medium))
                            Text(timezone.timeOffset())
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(timezone.formattedTime())
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .monospacedDigit()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    
                    if timezone.id != timeZoneManager.selectedTimeZones.last?.id {
                        Divider()
                    }
                }
                .onReceive(timer) { _ in
                    currentTime = Date()
                }
            }
            
            Divider()
            
            Button("Open World Clock") {
                NSApp.activate(ignoringOtherApps: true)
                if let window = NSApp.windows.first(where: { $0.isVisible && !$0.isSheet }) {
                    window.makeKeyAndOrderFront(nil)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .keyboardShortcut("q")
        }
        .frame(width: 250)
    }
}
