import SwiftUI

struct ClockCardView: View {
    let timeZone: TimeZoneInfo
    let index: Int
    
    @EnvironmentObject var timeZoneManager: TimeZoneManager
    @State private var currentTime = Date()
    @State private var showingDeleteConfirmation = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with city and delete button
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(timeZone.city)
                        .font(.system(size: 18, weight: .semibold))
                        .lineLimit(1)
                    
                    Text(timeZone.timeOffset())
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: { showingDeleteConfirmation = true }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .help("Remove timezone")
            }
            
            Divider()
            
            // Time Display
            VStack(alignment: .center, spacing: 8) {
                Text(timeZone.formattedTime())
                    .font(.system(size: 48, weight: .light, design: .rounded))
                    .monospacedDigit()
                
                Text(timeZone.formattedDate())
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .onReceive(timer) { _ in
                currentTime = Date()
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .confirmationDialog(
            "Remove \(timeZone.city)?",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Remove", role: .destructive) {
                timeZoneManager.removeTimeZone(at: index)
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
