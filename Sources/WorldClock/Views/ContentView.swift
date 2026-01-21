import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timeZoneManager: TimeZoneManager
    @State private var showingAddTimeZone = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("World Clock")
                    .font(.system(size: 24, weight: .bold))
                
                Spacer()
                
                Button(action: { showingAddTimeZone = true }) {
                    Label("Add Timezone", systemImage: "plus.circle.fill")
                        .font(.system(size: 14, weight: .medium))
                }
                .buttonStyle(.bordered)
                .disabled(!timeZoneManager.canAddMore())
            }
            .padding()
            .background(Color(nsColor: .windowBackgroundColor))
            
            Divider()
            
            // Clock Grid
            if timeZoneManager.selectedTimeZones.isEmpty {
                EmptyStateView(showingAddTimeZone: $showingAddTimeZone)
            } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(Array(timeZoneManager.selectedTimeZones.enumerated()), id: \.element.id) { index, timezone in
                            ClockCardView(timeZone: timezone, index: index)
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingAddTimeZone) {
            TimeZoneSelectorView()
        }
    }
}

struct EmptyStateView: View {
    @Binding var showingAddTimeZone: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.badge.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Timezones Added")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add up to 4 timezones to track time around the world")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: { showingAddTimeZone = true }) {
                Label("Add Your First Timezone", systemImage: "plus.circle.fill")
                    .font(.system(size: 16, weight: .medium))
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
