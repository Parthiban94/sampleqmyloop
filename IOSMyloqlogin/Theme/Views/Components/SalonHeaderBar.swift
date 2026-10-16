//
//  SalonHeaderBar.swift
//  IOSMyloqlogin
//

import SwiftUI

struct SalonHeaderBar: View {
    let locationText: String
    let onBack: () -> Void
    var onLocationTap: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            // White Back Arrow
            Button(action: onBack) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)
            
            // Location Capsule Dropdown
            Button(action: {
                onLocationTap?()
            }) {
                HStack(spacing: 8) {
                    if locationText.contains("Detecting") {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(0.7)
                            .frame(width: 14, height: 14)
                    } else {
                        Image(systemName: "location.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Text(locationText)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer(minLength: 4)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(MyLooQTheme.primaryPurple)
    }
}

#Preview {
    SalonHeaderBar(
        locationText: "Current Location",
        onBack: {}
    )
}
