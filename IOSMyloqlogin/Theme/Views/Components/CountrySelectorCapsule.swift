//
//  CountrySelectorCapsule.swift
//  IOSMyloqlogin
//

import SwiftUI

struct CountrySelectorCapsule: View {
    let country: Country
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                CountryFlagView(country: country, size: 24)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(MyLooQTheme.darkText)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CountrySelectorCapsule(country: .netherlands) {}
        .padding()
        .background(MyLooQTheme.lightGrayBackground)
}
