import SwiftUI

struct TimeZoneSelectorView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var timeZoneManager: TimeZoneManager
    
    @State private var searchText = ""
    @State private var allTimeZones: [TimeZoneInfo] = []
    
    var filteredTimeZones: [TimeZoneInfo] {
        if searchText.isEmpty {
            return allTimeZones
        }
        return allTimeZones.filter {
            $0.city.localizedCaseInsensitiveContains(searchText) ||
            $0.country.localizedCaseInsensitiveContains(searchText) ||
            $0.identifier.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Add Timezone")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding()
            
            Divider()
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search cities or countries", text: $searchText)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(10)
            .background(Color(nsColor: .controlBackgroundColor))
            .cornerRadius(8)
            .padding()
            
            // Timezone List
            List {
                ForEach(filteredTimeZones) { timeZone in
                    TimeZoneRowView(timeZone: timeZone)
                }
            }
            .listStyle(.plain)
        }
        .frame(width: 500, height: 600)
        .onAppear {
            loadAllTimeZones()
        }
    }
    
    private func loadAllTimeZones() {
        allTimeZones = TimeZone.knownTimeZoneIdentifiers
            .compactMap { identifier in
                guard let tz = TimeZone(identifier: identifier) else { return nil }
                return TimeZoneInfo(from: tz)
            }
            .sorted { $0.city < $1.city }
    }
}

struct TimeZoneRowView: View {
    let timeZone: TimeZoneInfo
    @EnvironmentObject var timeZoneManager: TimeZoneManager
    @Environment(\.dismiss) var dismiss
    
    var isSelected: Bool {
        timeZoneManager.selectedTimeZones.contains(where: { $0.identifier == timeZone.identifier })
    }
    
    var body: some View {
        Button(action: {
            if !isSelected {
                timeZoneManager.addTimeZone(timeZone)
                if timeZoneManager.selectedTimeZones.count >= 4 {
                    dismiss()
                }
            }
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(timeZone.city)
                        .font(.system(size: 14, weight: .medium))
                    
                    HStack(spacing: 8) {
                        Text(timeZone.country)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        
                        Text(timeZone.timeOffset())
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 18))
                } else {
                    Text(timeZone.formattedTime())
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .disabled(isSelected)
        .opacity(isSelected ? 0.5 : 1.0)
    }
}
