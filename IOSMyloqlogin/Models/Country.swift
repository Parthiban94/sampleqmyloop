//
//  Country.swift
//  IOSMyloqlogin
//

import Foundation

struct Country: Identifiable, Hashable, Equatable {
    var id: String { code }
    let code: String          // ISO 2-letter code e.g. "NL"
    let name: String          // Country name e.g. "Netherlands"
    let dialCode: String      // Dial code e.g. "+31"
    let flagEmoji: String     // Flag emoji e.g. "🇳🇱"
    let exampleNumber: String // Format hint e.g. "6 1234 5678"
    let minDigits: Int
    let maxDigits: Int
    
    /// Default country from the design screenshot (Netherlands)
    static let netherlands = Country(
        code: "NL",
        name: "Netherlands",
        dialCode: "+31",
        flagEmoji: "🇳🇱",
        exampleNumber: "6 1234 5678",
        minDigits: 9,
        maxDigits: 10
    )
    
    static let allCountries: [Country] = [
        Country.netherlands,
        Country(code: "US", name: "United States", dialCode: "+1", flagEmoji: "🇺🇸", exampleNumber: "202 555 0123", minDigits: 10, maxDigits: 10),
        Country(code: "GB", name: "United Kingdom", dialCode: "+44", flagEmoji: "🇬🇧", exampleNumber: "7911 123456", minDigits: 10, maxDigits: 11),
        Country(code: "IN", name: "India", dialCode: "+91", flagEmoji: "🇮🇳", exampleNumber: "98765 43210", minDigits: 10, maxDigits: 10),
        Country(code: "DE", name: "Germany", dialCode: "+49", flagEmoji: "🇩🇪", exampleNumber: "151 23456789", minDigits: 10, maxDigits: 11),
        Country(code: "FR", name: "France", dialCode: "+33", flagEmoji: "🇫🇷", exampleNumber: "6 12 34 56 78", minDigits: 9, maxDigits: 9),
        Country(code: "CA", name: "Canada", dialCode: "+1", flagEmoji: "🇨🇦", exampleNumber: "416 555 0199", minDigits: 10, maxDigits: 10),
        Country(code: "AU", name: "Australia", dialCode: "+61", flagEmoji: "🇦🇺", exampleNumber: "412 345 678", minDigits: 9, maxDigits: 9),
        Country(code: "AE", name: "United Arab Emirates", dialCode: "+971", flagEmoji: "🇦🇪", exampleNumber: "50 123 4567", minDigits: 9, maxDigits: 9),
        Country(code: "SG", name: "Singapore", dialCode: "+65", flagEmoji: "🇸🇬", exampleNumber: "8123 4567", minDigits: 8, maxDigits: 8),
        Country(code: "ES", name: "Spain", dialCode: "+34", flagEmoji: "🇪🇸", exampleNumber: "612 345 678", minDigits: 9, maxDigits: 9),
        Country(code: "IT", name: "Italy", dialCode: "+39", flagEmoji: "🇮🇹", exampleNumber: "312 3456789", minDigits: 10, maxDigits: 10),
        Country(code: "BE", name: "Belgium", dialCode: "+32", flagEmoji: "🇧🇪", exampleNumber: "470 12 34 56", minDigits: 9, maxDigits: 9),
        Country(code: "CH", name: "Switzerland", dialCode: "+41", flagEmoji: "🇨🇭", exampleNumber: "79 123 45 67", minDigits: 9, maxDigits: 9),
        Country(code: "SE", name: "Sweden", dialCode: "+46", flagEmoji: "🇸🇪", exampleNumber: "70 123 45 67", minDigits: 9, maxDigits: 9),
        Country(code: "NO", name: "Norway", dialCode: "+47", flagEmoji: "🇳🇴", exampleNumber: "412 34 567", minDigits: 8, maxDigits: 8),
        Country(code: "DK", name: "Denmark", dialCode: "+45", flagEmoji: "🇩🇰", exampleNumber: "20 12 34 56", minDigits: 8, maxDigits: 8),
        Country(code: "NZ", name: "New Zealand", dialCode: "+64", flagEmoji: "🇳🇿", exampleNumber: "21 123 4567", minDigits: 9, maxDigits: 10),
        Country(code: "BR", name: "Brazil", dialCode: "+55", flagEmoji: "🇧🇷", exampleNumber: "11 91234 5678", minDigits: 11, maxDigits: 11),
        Country(code: "ZA", name: "South Africa", dialCode: "+27", flagEmoji: "🇿🇦", exampleNumber: "71 123 4567", minDigits: 9, maxDigits: 9),
        Country(code: "JP", name: "Japan", dialCode: "+81", flagEmoji: "🇯🇵", exampleNumber: "90 1234 5678", minDigits: 10, maxDigits: 10),
        Country(code: "KR", name: "South Korea", dialCode: "+82", flagEmoji: "🇰🇷", exampleNumber: "10 1234 5678", minDigits: 10, maxDigits: 10),
        Country(code: "MY", name: "Malaysia", dialCode: "+60", flagEmoji: "🇲🇾", exampleNumber: "12 345 6789", minDigits: 9, maxDigits: 10),
        Country(code: "ID", name: "Indonesia", dialCode: "+62", flagEmoji: "🇮🇩", exampleNumber: "812 3456 7890", minDigits: 10, maxDigits: 12),
        Country(code: "SA", name: "Saudi Arabia", dialCode: "+966", flagEmoji: "🇸🇦", exampleNumber: "50 123 4567", minDigits: 9, maxDigits: 9)
    ]
}
