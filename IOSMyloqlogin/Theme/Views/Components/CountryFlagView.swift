//
//  CountryFlagView.swift
//  IOSMyloqlogin
//

import SwiftUI

struct CountryFlagView: View {
    let country: Country
    var size: CGFloat = 24
    
    var body: some View {
        Group {
            if country.code == "NL" {
                // Pixel-perfect Netherlands vector flag matching the screenshot
                NetherlandsFlagShape()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.08), lineWidth: 0.5)
                    )
            } else {
                // Standard flag display for other countries
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: size, height: size)
                    Text(country.flagEmoji)
                        .font(.system(size: size * 0.75))
                }
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.08), lineWidth: 0.5)
                )
            }
        }
    }
}

/// Precise Netherlands tricolor flag (Red, White, Cobalt Blue)
struct NetherlandsFlagShape: View {
    var body: some View {
        GeometryReader { geo in
            let h = geo.size.height / 3.0
            VStack(spacing: 0) {
                // Bright Vermilion / Red stripe
                Color(hex: "AE1C28")
                    .frame(height: h)
                // White stripe
                Color.white
                    .frame(height: h)
                // Cobalt Blue stripe
                Color(hex: "21468B")
                    .frame(height: h)
            }
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        CountryFlagView(country: Country.netherlands, size: 28)
        CountryFlagView(country: Country.allCountries[1], size: 28)
        CountryFlagView(country: Country.allCountries[3], size: 28)
    }
    .padding()
}
