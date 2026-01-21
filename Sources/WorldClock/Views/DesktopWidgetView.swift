import SwiftUI
import AppKit

struct DesktopWidgetView: View {
    @EnvironmentObject var timeZoneManager: TimeZoneManager
    @EnvironmentObject var widgetManager: WidgetManager
    @State private var currentTime = Date()
    @State private var showingSettings = false
    @State private var isHovered = false
    @State private var dragOffset = CGSize.zero
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header - Draggable area
            HStack {
                Text("🌍 World Clock")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if isHovered {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .buttonStyle(.plain)
                    .help("Settings")
                    
                    Button(action: { widgetManager.hideWidget() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .buttonStyle(.plain)
                    .help("Hide Widget")
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.4))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                        if let window = NSApp.windows.first(where: { $0.isVisible && $0.contentView is NSHostingView<DesktopWidgetView> }) {
                            let currentOrigin = window.frame.origin
                            let newOrigin = NSPoint(
                                x: currentOrigin.x + value.translation.width,
                                y: currentOrigin.y - value.translation.height
                            )
                            window.setFrameOrigin(newOrigin)
                        }
                        dragOffset = .zero
                    }
                    .onEnded { _ in
                        dragOffset = .zero
                    }
            )
            
            // Clock Grid (2x2 Table Layout)
            if timeZoneManager.selectedTimeZones.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clock.badge.questionmark")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("No Timezones")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    Button("Add Timezone") {
                        showingSettings = true
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(Color.black.opacity(0.2))
            } else {
                // Grid Layout - 2 columns
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ],
                    spacing: 10
                ) {
                    ForEach(Array(timeZoneManager.selectedTimeZones.enumerated()), id: \.element.id) { index, timezone in
                        GridClockView(timeZone: timezone, index: index, currentTime: $currentTime)
                    }
                    
                    // Add placeholder for empty slots
                    ForEach(timeZoneManager.selectedTimeZones.count..<4, id: \.self) { _ in
                        if isHovered && timeZoneManager.canAddMore() {
                            AddTimezoneCard(showingSettings: $showingSettings)
                        } else {
                            EmptyClockSlot()
                        }
                    }
                }
                .padding(12)
                .background(Color.black.opacity(0.2))
            }
        }
        .frame(width: 480, height: 380)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .opacity(0.95)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.4), radius: 15, x: 0, y: 5)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
        .sheet(isPresented: $showingSettings) {
            TimeZoneSelectorView()
        }
    }
}

// Grid Clock Card - Compact 2x2 layout
struct GridClockView: View {
    let timeZone: TimeZoneInfo
    let index: Int
    @Binding var currentTime: Date
    
    @EnvironmentObject var timeZoneManager: TimeZoneManager
    @State private var showingDelete = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text(timeZone.city)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Text(timeZone.country)
                        .font(.system(size: 9))
                        .foregroundColor(.white.opacity(0.6))
                        .lineLimit(1)
                }
                
                Spacer(minLength: 4)
                
                if showingDelete {
                    Button(action: {
                        withAnimation {
                            timeZoneManager.removeTimeZone(at: index)
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.red.opacity(0.9))
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            // Time Display
            VStack(spacing: 4) {
                Text(timeZone.formattedTime())
                    .font(.system(size: 36, weight: .thin, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .id(currentTime) // Force update when currentTime changes
                
                HStack(spacing: 4) {
                    Text(timeZone.formattedDate())
                        .font(.system(size: 9))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("•")
                        .foregroundColor(.white.opacity(0.4))
                    
                    Text(timeZone.timeOffset())
                        .font(.system(size: 9))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(10)
        .frame(height: 150)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(showingDelete ? 0.08 : 0.04))
                .background(.thinMaterial.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(showingDelete ? 0.4 : 0.2), lineWidth: 1)
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                showingDelete = hovering
            }
        }
    }
}

// Empty slot placeholder
struct EmptyClockSlot: View {
    var body: some View {
        VStack {
            Image(systemName: "clock.badge.plus")
                .font(.system(size: 24))
                .foregroundColor(.white.opacity(0.2))
        }
        .frame(height: 150)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.02))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        .foregroundColor(.white.opacity(0.25))
                )
        )
    }
}

// Add timezone card (appears on hover)
struct AddTimezoneCard: View {
    @Binding var showingSettings: Bool
    
    var body: some View {
        Button(action: { showingSettings = true }) {
            VStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Add Timezone")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.plain)
        .frame(height: 150)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.accentColor.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentColor.opacity(0.5), lineWidth: 1)
                )
        )
    }
}

