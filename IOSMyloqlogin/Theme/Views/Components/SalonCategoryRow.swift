//
//  SalonCategoryRow.swift
//  IOSMyloqlogin
//

import SwiftUI

struct SalonCategoryRow: View {
    let title: String
    var iconType: SalonIconType = .remoteImage
    let remoteImageUrl: String?
    let isSelected: Bool
    let onToggle: () -> Void
    
    init(
        title: String,
        iconType: SalonIconType = .remoteImage,
        remoteImageUrl: String?,
        isSelected: Bool,
        onToggle: @escaping () -> Void
    ) {
        self.title = title
        self.iconType = iconType
        self.remoteImageUrl = remoteImageUrl
        self.isSelected = isSelected
        self.onToggle = onToggle
    }
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                // Category Avatar / Icon
                SalonCategoryIconView(
                    iconType: iconType,
                    remoteImageUrl: remoteImageUrl,
                    size: 44
                )
                
                // Category Title
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(MyLooQTheme.darkText)
                    .lineLimit(1)
                
                Spacer()
                
                // Toggle Button (+ purple or ✓ green)
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(isSelected ? Color(hex: "00B67A") : MyLooQTheme.primaryPurple)
                        .frame(width: 32, height: 32)
                        .shadow(
                            color: isSelected ? Color(hex: "00B67A").opacity(0.3) : MyLooQTheme.primaryPurple.opacity(0.2),
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        Image(systemName: "plus")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isSelected)
            }
            .padding(.horizontal, 16)
            .frame(height: 68)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(hex: "F8F9FA"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(isSelected ? Color(hex: "00B67A").opacity(0.3) : Color.clear, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 12) {
        SalonCategoryRow(
            title: "Bridal facial",
            iconType: .bridalFacial,
            remoteImageUrl: nil,
            isSelected: false,
            onToggle: {}
        )
        SalonCategoryRow(
            title: "Classic facial",
            iconType: .classicFacial,
            remoteImageUrl: nil,
            isSelected: true,
            onToggle: {}
        )
    }
    .padding()
}
