import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var timeZoneManager: TimeZoneManager
    @EnvironmentObject var widgetManager: WidgetManager
    @State private var currentTime = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("🌍 World Clock")
                    .font(.system(size: 13, weight: .bold))
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            
            Divider()
            
            // Grid Layout matching desktop widget
            if timeZoneManager.selectedTimeZones.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "clock.badge.questionmark")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)
                    
                    Text("No timezones configured")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                // Mini grid view - using VStack + HStack for better compatibility
                VStack(spacing: 8) {
                    // Row 1
                    HStack(spacing: 8) {
                        if timeZoneManager.selectedTimeZones.count > 0 {
                            MenuBarClockCard(timeZone: timeZoneManager.selectedTimeZones[0], currentTime: $currentTime)
                        }
                        if timeZoneManager.selectedTimeZones.count > 1 {
                            MenuBarClockCard(timeZone: timeZoneManager.selectedTimeZones[1], currentTime: $currentTime)
                        }
                    }
                    
                    // Row 2
                    if timeZoneManager.selectedTimeZones.count > 2 {
                        HStack(spacing: 8) {
                            MenuBarClockCard(timeZone: timeZoneManager.selectedTimeZones[2], currentTime: $currentTime)
                            
                            if timeZoneManager.selectedTimeZones.count > 3 {
                                MenuBarClockCard(timeZone: timeZoneManager.selectedTimeZones[3], currentTime: $currentTime)
                            }
                        }
                    }
                }
                .padding(12)
            }
            
            Divider()
                .onReceive(timer) { _ in
                    currentTime = Date()
                }
            
            // Controls
            VStack(spacing: 0) {
                Button(action: { widgetManager.toggleWidget() }) {
                    HStack {
                        Image(systemName: widgetManager.isWidgetVisible ? "eye.slash" : "eye")
                        Text(widgetManager.isWidgetVisible ? "Hide Widget" : "Show Widget")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
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
        }
        .frame(width: 300)
    }
}

// Menu bar clock card - compact version with live updates
struct MenuBarClockCard: View {
    let timeZone: TimeZoneInfo
    @Binding var currentTime: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // City name
            Text(timeZone.city)
                .font(.system(size: 10, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            // Time
            Text(timeZone.formattedTime())
                .font(.system(size: 20, weight: .light, design: .rounded))
                .monospacedDigit()
            
            // Offset
            Text(timeZone.timeOffset())
                .font(.system(size: 8))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(6)
        .id(currentTime) // Force refresh when currentTime changes
    }
}
