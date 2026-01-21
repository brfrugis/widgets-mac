import Foundation

struct TimeZoneData {
    // Map timezone identifiers to proper country names
    static let countryMapping: [String: String] = [
        // Americas
        "America/Sao_Paulo": "Brazil",
        "America/Rio_Branco": "Brazil",
        "America/Manaus": "Brazil",
        "America/Fortaleza": "Brazil",
        "America/Belem": "Brazil",
        "America/Recife": "Brazil",
        "America/Bahia": "Brazil",
        "America/Cuiaba": "Brazil",
        "America/Maceio": "Brazil",
        "America/Santarem": "Brazil",
        "America/Porto_Velho": "Brazil",
        "America/Boa_Vista": "Brazil",
        "America/Araguaina": "Brazil",
        "America/Campo_Grande": "Brazil",
        "America/Eirunepe": "Brazil",
        "America/Noronha": "Brazil",
        
        "America/New_York": "United States",
        "America/Chicago": "United States",
        "America/Denver": "United States",
        "America/Los_Angeles": "United States",
        "America/Phoenix": "United States",
        "America/Detroit": "United States",
        "America/Anchorage": "United States",
        "America/Honolulu": "United States",
        
        "America/Toronto": "Canada",
        "America/Vancouver": "Canada",
        "America/Montreal": "Canada",
        "America/Edmonton": "Canada",
        "America/Winnipeg": "Canada",
        "America/Halifax": "Canada",
        
        "America/Mexico_City": "Mexico",
        "America/Cancun": "Mexico",
        "America/Tijuana": "Mexico",
        
        "America/Buenos_Aires": "Argentina",
        "America/Santiago": "Chile",
        "America/Lima": "Peru",
        "America/Bogota": "Colombia",
        "America/Caracas": "Venezuela",
        
        // Europe
        "Europe/London": "United Kingdom",
        "Europe/Dublin": "Ireland",
        "Europe/Paris": "France",
        "Europe/Berlin": "Germany",
        "Europe/Rome": "Italy",
        "Europe/Madrid": "Spain",
        "Europe/Lisbon": "Portugal",
        "Europe/Amsterdam": "Netherlands",
        "Europe/Brussels": "Belgium",
        "Europe/Vienna": "Austria",
        "Europe/Zurich": "Switzerland",
        "Europe/Stockholm": "Sweden",
        "Europe/Copenhagen": "Denmark",
        "Europe/Oslo": "Norway",
        "Europe/Helsinki": "Finland",
        "Europe/Warsaw": "Poland",
        "Europe/Prague": "Czech Republic",
        "Europe/Athens": "Greece",
        "Europe/Budapest": "Hungary",
        "Europe/Moscow": "Russia",
        "Europe/Istanbul": "Turkey",
        
        // Asia
        "Asia/Tokyo": "Japan",
        "Asia/Seoul": "South Korea",
        "Asia/Shanghai": "China",
        "Asia/Hong_Kong": "Hong Kong",
        "Asia/Singapore": "Singapore",
        "Asia/Bangkok": "Thailand",
        "Asia/Jakarta": "Indonesia",
        "Asia/Manila": "Philippines",
        "Asia/Kuala_Lumpur": "Malaysia",
        "Asia/Dubai": "United Arab Emirates",
        "Asia/Tel_Aviv": "Israel",
        "Asia/Kolkata": "India",
        "Asia/Karachi": "Pakistan",
        "Asia/Dhaka": "Bangladesh",
        
        // Oceania
        "Pacific/Auckland": "New Zealand",
        "Australia/Sydney": "Australia",
        "Australia/Melbourne": "Australia",
        "Australia/Brisbane": "Australia",
        "Australia/Perth": "Australia",
        "Australia/Adelaide": "Australia",
        
        // Africa
        "Africa/Cairo": "Egypt",
        "Africa/Johannesburg": "South Africa",
        "Africa/Lagos": "Nigeria",
        "Africa/Nairobi": "Kenya",
        "Africa/Casablanca": "Morocco",
    ]
    
    static func getCountryName(for identifier: String) -> String {
        // First check our mapping
        if let country = countryMapping[identifier] {
            return country
        }
        
        // Fallback: extract region from identifier
        let components = identifier.split(separator: "/")
        if components.count >= 1 {
            let region = String(components[0])
            switch region {
            case "America":
                return "Americas"
            case "Europe":
                return "Europe"
            case "Asia":
                return "Asia"
            case "Pacific":
                return "Pacific"
            case "Africa":
                return "Africa"
            case "Atlantic":
                return "Atlantic"
            case "Indian":
                return "Indian Ocean"
            case "Australia":
                return "Australia"
            default:
                return region
            }
        }
        
        return "Other"
    }
}
