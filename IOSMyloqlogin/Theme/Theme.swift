//
//  Theme.swift
//  IOSMyloqlogin
//

import SwiftUI

enum MyLooQTheme {
    /// The primary signature purple color from the MyLooQ design
    static let primaryPurple = Color(hex: "6A2691")
    
    /// Darker purple for pressed state
    static let primaryPurplePressed = Color(hex: "561F77")
    
    /// Light gray background for the text input and back button
    static let lightGrayBackground = Color(hex: "F3F4F6")
    
    /// Secondary text color (e.g. "Use your MyLooQ registered mobile number")
    static let secondaryText = Color(hex: "7E7E7E")
    
    /// Muted text color for "or" and "By proceeding, I accept the"
    static let mutedText = Color(hex: "8E8E93")
    
    /// Dark text for headings and primary labels
    static let darkText = Color(hex: "111111")
    
    /// Border color for input box / register button
    static let darkBorder = Color(hex: "1A1A1A")
    static let lightDivider = Color(hex: "E5E7EB")
    
    /// Accent coral / pink color for phone number highlight and OTP stars
    static let accentCoral = Color(hex: "E85D75")
    
    /// Pastel purple shades for decorative illustration background
    static let pastelPurpleGlow = Color(hex: "F3EAF8")
    static let pastelPurpleSecondary = Color(hex: "ECE3F8")
    
    /// Empty OTP input box background and placeholder dash color
    static let otpBoxEmpty = Color(hex: "F3F4F6")
    static let otpDashColor = Color(hex: "A0A0A8")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
