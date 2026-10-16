//
//  ShopCategoryCardView.swift
//  IOSMyloqlogin
//

import SwiftUI

struct ShopCategoryCardView: View {
    let category: ShopCategory
    let pastelHex: String
    var isFullWidth: Bool = false
    let onSelect: () -> Void
    
    // Fixed image dimensions for uniform sizing across all cards
    private var imageWidth: CGFloat {
        isFullWidth ? 82 : 100
    }
    
    private var imageHeight: CGFloat {
        isFullWidth ? 82 : 60
    }
    
    var body: some View {
        Button(action: onSelect) {
            ZStack(alignment: .bottomTrailing) {
                // Background pastel color
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: pastelHex))
                
                // Category Title at Top-Left
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.name)
                        .font(.system(size: isFullWidth ? 16 : 13.5, weight: .bold))
                        .foregroundColor(Color(hex: "1A1A1A"))
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding(.leading, isFullWidth ? 18 : 14)
                .padding(.top, isFullWidth ? 14 : 12)
                .padding(.trailing, isFullWidth ? 98 : 74)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Category Image at Bottom-Right: fully covers bottom right corner with uniform half-grid size
                if let imageUrlString = category.image, let url = URL(string: imageUrlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .scaleEffect(0.7)
                                .frame(width: imageWidth, height: imageHeight)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: isFullWidth ? .fit : .fill)
                                .frame(width: imageWidth, height: imageHeight)
                                .clipped()
                                .clipShape(
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: 12,
                                        bottomLeadingRadius: 0,
                                        bottomTrailingRadius: 16,
                                        topTrailingRadius: 0
                                    )
                                )
                        case .failure:
                            Image(systemName: "sparkles")
                                .font(.system(size: 26))
                                .foregroundColor(Color.gray.opacity(0.5))
                                .frame(width: imageWidth, height: imageHeight)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            .frame(height: 105)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black.opacity(0.04), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
