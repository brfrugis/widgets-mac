import Foundation
import SwiftUI

class TimeZoneManager: ObservableObject {
    static let shared = TimeZoneManager()
    
    @Published var selectedTimeZones: [TimeZoneInfo] = []
    
    private let maxTimeZones = 4
    private let userDefaultsKey = "selectedTimeZones"
    
    init() {
        loadTimeZones()
    }
    
    func addTimeZone(_ timeZone: TimeZoneInfo) {
        guard selectedTimeZones.count < maxTimeZones else { return }
        guard !selectedTimeZones.contains(where: { $0.identifier == timeZone.identifier }) else { return }
        
        selectedTimeZones.append(timeZone)
        saveTimeZones()
    }
    
    func removeTimeZone(at index: Int) {
        guard index < selectedTimeZones.count else { return }
        selectedTimeZones.remove(at: index)
        saveTimeZones()
    }
    
    func removeTimeZone(_ timeZone: TimeZoneInfo) {
        selectedTimeZones.removeAll { $0.identifier == timeZone.identifier }
        saveTimeZones()
    }
    
    func canAddMore() -> Bool {
        return selectedTimeZones.count < maxTimeZones
    }
    
    private func saveTimeZones() {
        let identifiers = selectedTimeZones.map { $0.identifier }
        UserDefaults.standard.set(identifiers, forKey: userDefaultsKey)
    }
    
    private func loadTimeZones() {
        guard let identifiers = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] else {
            // Load default timezones
            setDefaultTimeZones()
            return
        }
        
        selectedTimeZones = identifiers.compactMap { identifier in
            guard let timeZone = TimeZone(identifier: identifier) else { return nil }
            return TimeZoneInfo(from: timeZone)
        }
        
        // If no timezones loaded, set defaults
        if selectedTimeZones.isEmpty {
            setDefaultTimeZones()
        }
    }
    
    private func setDefaultTimeZones() {
        // Add local timezone and a few common ones
        if let local = TimeZone.current.identifier.isEmpty ? nil : TimeZone.current {
            selectedTimeZones.append(TimeZoneInfo(from: local))
        }
        
        let defaults = ["America/Sao_Paulo", "America/New_York", "Europe/London"]
        for identifier in defaults {
            if selectedTimeZones.count >= maxTimeZones { break }
            if let tz = TimeZone(identifier: identifier) {
                let info = TimeZoneInfo(from: tz)
                if !selectedTimeZones.contains(where: { $0.identifier == info.identifier }) {
                    selectedTimeZones.append(info)
                }
            }
        }
        
        saveTimeZones()
    }
}

struct TimeZoneInfo: Identifiable, Hashable {
    let id = UUID()
    let identifier: String
    let city: String
    let country: String
    
    init(from timeZone: TimeZone) {
        self.identifier = timeZone.identifier
        
        // Get proper country name from mapping
        self.country = TimeZoneData.getCountryName(for: timeZone.identifier)
        
        // Parse city from identifier
        let components = timeZone.identifier.split(separator: "/")
        if components.count >= 2 {
            self.city = String(components[1]).replacingOccurrences(of: "_", with: " ")
        } else {
            self.city = timeZone.identifier.replacingOccurrences(of: "_", with: " ")
        }
    }
    
    init(identifier: String, city: String, country: String) {
        self.identifier = identifier
        self.city = city
        self.country = country
    }
    
    var timeZone: TimeZone? {
        TimeZone(identifier: identifier)
    }
    
    func currentTime() -> Date {
        return Date()
    }
    
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "EEE, MMM d"
        return formatter.string(from: Date())
    }
    
    func timeOffset() -> String {
        guard let tz = timeZone else { return "" }
        let seconds = tz.secondsFromGMT()
        let hours = seconds / 3600
        let minutes = abs(seconds % 3600) / 60
        
        if minutes == 0 {
            return String(format: "GMT%+d", hours)
        } else {
            return String(format: "GMT%+d:%02d", hours, minutes)
        }
    }
}
