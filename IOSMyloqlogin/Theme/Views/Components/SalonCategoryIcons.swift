//
//  SalonCategoryIcons.swift
//  IOSMyloqlogin
//

import SwiftUI

struct SalonCategoryIconView: View {
    var iconType: SalonIconType = .remoteImage
    let remoteImageUrl: String?
    var size: CGFloat = 44
    
    init(iconType: SalonIconType = .remoteImage, remoteImageUrl: String? = nil, size: CGFloat = 44) {
        self.iconType = iconType
        self.remoteImageUrl = remoteImageUrl
        self.size = size
    }
    
    var body: some View {
        ZStack {
            switch iconType {
            case .bridalFacial:
                bridalFacialIcon
            case .classicFacial:
                classicFacialIcon
            case .mask:
                maskIcon
            case .premiumFacial:
                premiumFacialIcon
            case .waxing:
                waxingIcon
            case .threading:
                threadingIcon
            case .remoteImage:
                remoteImageView
            }
        }
        .frame(width: size, height: size)
    }
    
    // MARK: - 1. Bridal Facial Icon
    private var bridalFacialIcon: some View {
        ZStack {
            // Face base
            Circle()
                .fill(Color(hex: "FEDCC8"))
                .frame(width: size * 0.72, height: size * 0.72)
                .offset(y: size * 0.08)
            
            // Pink Headband / Towel Wrap
            Capsule()
                .fill(Color(hex: "F8A5A5"))
                .frame(width: size * 0.76, height: size * 0.28)
                .offset(y: -size * 0.22)
            
            // Hair strands on forehead
            Circle()
                .fill(Color(hex: "E88B8B"))
                .frame(width: size * 0.22, height: size * 0.22)
                .offset(x: -size * 0.16, y: -size * 0.18)
            
            // Closed happy eyes
            HStack(spacing: size * 0.18) {
                ArcEyeShape()
                    .stroke(Color(hex: "8A4B38"), lineWidth: 1.5)
                    .frame(width: size * 0.12, height: size * 0.06)
                ArcEyeShape()
                    .stroke(Color(hex: "8A4B38"), lineWidth: 1.5)
                    .frame(width: size * 0.12, height: size * 0.06)
            }
            .offset(y: size * 0.04)
            
            // Blush cheeks
            HStack(spacing: size * 0.32) {
                Circle()
                    .fill(Color(hex: "F87171").opacity(0.5))
                    .frame(width: size * 0.1, height: size * 0.06)
                Circle()
                    .fill(Color(hex: "F87171").opacity(0.5))
                    .frame(width: size * 0.1, height: size * 0.06)
            }
            .offset(y: size * 0.12)
            
            // Cute smile
            ArcSmileShape()
                .stroke(Color(hex: "E11D48"), lineWidth: 1.2)
                .frame(width: size * 0.1, height: size * 0.05)
                .offset(y: size * 0.18)
            
            // Shoulders / towel drape
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: "FCA5A5"))
                .frame(width: size * 0.8, height: size * 0.18)
                .offset(y: size * 0.38)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: - 2. Classic Facial Icon
    private var classicFacialIcon: some View {
        ZStack {
            // Face
            Circle()
                .fill(Color(hex: "FEDCC8"))
                .frame(width: size * 0.72, height: size * 0.72)
                .offset(y: size * 0.06)
            
            // Brown hair
            Path { path in
                path.addArc(center: CGPoint(x: size * 0.5, y: size * 0.4), radius: size * 0.38, startAngle: .degrees(160), endAngle: .degrees(20), clockwise: false)
            }
            .fill(Color(hex: "A3485E"))
            .frame(width: size, height: size)
            
            // Hands massaging cheeks on both sides
            Capsule()
                .fill(Color(hex: "FBC4AB"))
                .frame(width: size * 0.14, height: size * 0.36)
                .rotationEffect(.degrees(-30))
                .offset(x: -size * 0.34, y: size * 0.12)
            
            Capsule()
                .fill(Color(hex: "FBC4AB"))
                .frame(width: size * 0.14, height: size * 0.36)
                .rotationEffect(.degrees(30))
                .offset(x: size * 0.34, y: size * 0.12)
            
            // Gentle closed eyes
            HStack(spacing: size * 0.18) {
                ArcEyeShape()
                    .stroke(Color(hex: "8A4B38"), lineWidth: 1.5)
                    .frame(width: size * 0.12, height: size * 0.06)
                ArcEyeShape()
                    .stroke(Color(hex: "8A4B38"), lineWidth: 1.5)
                    .frame(width: size * 0.12, height: size * 0.06)
            }
            .offset(y: size * 0.04)
            
            // Cheeks glow
            HStack(spacing: size * 0.28) {
                Circle().fill(Color(hex: "FB7185").opacity(0.6)).frame(width: size * 0.09, height: size * 0.06)
                Circle().fill(Color(hex: "FB7185").opacity(0.6)).frame(width: size * 0.09, height: size * 0.06)
            }
            .offset(y: size * 0.12)
            
            // Shoulders
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: "FDA4AF"))
                .frame(width: size * 0.76, height: size * 0.16)
                .offset(y: size * 0.38)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: - 3. Green Mask Icon
    private var maskIcon: some View {
        ZStack {
            // Face base
            Circle()
                .fill(Color(hex: "FEDCC8"))
                .frame(width: size * 0.72, height: size * 0.72)
                .offset(y: size * 0.06)
            
            // Mint Green Face Mask
            Circle()
                .fill(Color(hex: "34D399")) // Mint green
                .frame(width: size * 0.58, height: size * 0.58)
                .offset(y: size * 0.08)
            
            // Cutouts for eyes
            HStack(spacing: size * 0.14) {
                Circle().fill(Color(hex: "FEDCC8")).frame(width: size * 0.14, height: size * 0.1)
                Circle().fill(Color(hex: "FEDCC8")).frame(width: size * 0.14, height: size * 0.1)
            }
            .offset(y: size * 0.04)
            
            // Eyes
            HStack(spacing: size * 0.16) {
                Circle().fill(Color(hex: "1F2937")).frame(width: size * 0.06, height: size * 0.06)
                Circle().fill(Color(hex: "1F2937")).frame(width: size * 0.06, height: size * 0.06)
            }
            .offset(y: size * 0.04)
            
            // Pink Headband
            Capsule()
                .fill(Color(hex: "F472B6"))
                .frame(width: size * 0.74, height: size * 0.22)
                .offset(y: -size * 0.24)
            
            // Smile
            ArcSmileShape()
                .stroke(Color.white, lineWidth: 1.5)
                .frame(width: size * 0.1, height: size * 0.05)
                .offset(y: size * 0.2)
            
            // Shoulders
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: "F472B6"))
                .frame(width: size * 0.76, height: size * 0.16)
                .offset(y: size * 0.38)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: - 4. Premium Facial Icon
    private var premiumFacialIcon: some View {
        ZStack {
            // Face
            Circle()
                .fill(Color(hex: "FEDCC8"))
                .frame(width: size * 0.72, height: size * 0.72)
                .offset(y: size * 0.06)
            
            // Blonde / Light Pink hair
            Capsule()
                .fill(Color(hex: "FCA5A5"))
                .frame(width: size * 0.76, height: size * 0.24)
                .offset(y: -size * 0.22)
            
            // Eyes
            HStack(spacing: size * 0.18) {
                ArcEyeShape()
                    .stroke(Color(hex: "8A4B38"), lineWidth: 1.5)
                    .frame(width: size * 0.12, height: size * 0.06)
                ArcEyeShape()
                    .stroke(Color(hex: "8A4B38"), lineWidth: 1.5)
                    .frame(width: size * 0.12, height: size * 0.06)
            }
            .offset(y: size * 0.04)
            
            // Serum Dropper Pipette applying drop
            ZStack {
                // Pipette tube
                Capsule()
                    .fill(Color(hex: "93C5FD"))
                    .frame(width: size * 0.08, height: size * 0.38)
                    .rotationEffect(.degrees(35))
                
                // Pipette top bulb
                Circle()
                    .fill(Color(hex: "3B82F6"))
                    .frame(width: size * 0.14, height: size * 0.14)
                    .offset(x: size * 0.12, y: -size * 0.16)
                
                // Serum drop falling on cheek
                Circle()
                    .fill(Color(hex: "60A5FA"))
                    .frame(width: size * 0.08, height: size * 0.08)
                    .offset(x: -size * 0.12, y: size * 0.12)
            }
            .offset(x: size * 0.2, y: -size * 0.04)
            
            // Shoulders
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: "FDA4AF"))
                .frame(width: size * 0.76, height: size * 0.16)
                .offset(y: size * 0.38)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: - 5. Waxing Icon
    private var waxingIcon: some View {
        ZStack {
            // Background soft circle
            Circle()
                .fill(Color(hex: "FEF3C7"))
                .frame(width: size, height: size)
            
            // Leg Shape
            Path { path in
                path.move(to: CGPoint(x: size * 0.35, y: size * 0.15))
                path.addQuadCurve(to: CGPoint(x: size * 0.45, y: size * 0.65), control: CGPoint(x: size * 0.38, y: size * 0.4))
                // Ankle and Foot
                path.addQuadCurve(to: CGPoint(x: size * 0.75, y: size * 0.82), control: CGPoint(x: size * 0.5, y: size * 0.78))
                path.addQuadCurve(to: CGPoint(x: size * 0.65, y: size * 0.9), control: CGPoint(x: size * 0.75, y: size * 0.9))
                path.addQuadCurve(to: CGPoint(x: size * 0.32, y: size * 0.75), control: CGPoint(x: size * 0.42, y: size * 0.88))
                path.addQuadCurve(to: CGPoint(x: size * 0.22, y: size * 0.15), control: CGPoint(x: size * 0.25, y: size * 0.45))
                path.closeSubpath()
            }
            .fill(Color(hex: "FDE68A"))
            
            // Waxing strip / applicator
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: "38BDF8"))
                .frame(width: size * 0.16, height: size * 0.36)
                .rotationEffect(.degrees(-25))
                .offset(x: size * 0.08, y: -size * 0.06)
            
            // Wax sparkle
            Image(systemName: "sparkle")
                .font(.system(size: size * 0.18))
                .foregroundColor(Color(hex: "0284C7"))
                .offset(x: size * 0.22, y: -size * 0.18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: - 6. Threading Icon
    private var threadingIcon: some View {
        ZStack {
            // Background soft circle
            Circle()
                .fill(Color(hex: "E0F2FE"))
                .frame(width: size, height: size)
            
            // Eyebrow
            Path { path in
                path.move(to: CGPoint(x: size * 0.18, y: size * 0.32))
                path.addQuadCurve(to: CGPoint(x: size * 0.82, y: size * 0.36), control: CGPoint(x: size * 0.52, y: size * 0.18))
            }
            .stroke(Color(hex: "4B5563"), style: StrokeStyle(lineWidth: 3, lineCap: .round))
            
            // Eye shape
            ZStack {
                // Eye white / iris
                Circle()
                    .fill(Color.white)
                    .frame(width: size * 0.5, height: size * 0.35)
                
                // Iris blue
                Circle()
                    .fill(Color(hex: "38BDF8"))
                    .frame(width: size * 0.26, height: size * 0.26)
                
                // Pupil black
                Circle()
                    .fill(Color(hex: "0F172A"))
                    .frame(width: size * 0.14, height: size * 0.14)
                
                // White highlight
                Circle()
                    .fill(Color.white)
                    .frame(width: size * 0.05, height: size * 0.05)
                    .offset(x: -size * 0.03, y: -size * 0.03)
            }
            .offset(y: size * 0.08)
            
            // Threading threads crossed `X`
            Path { path in
                path.move(to: CGPoint(x: size * 0.2, y: size * 0.18))
                path.addLine(to: CGPoint(x: size * 0.8, y: size * 0.45))
                path.move(to: CGPoint(x: size * 0.8, y: size * 0.18))
                path.addLine(to: CGPoint(x: size * 0.2, y: size * 0.45))
            }
            .stroke(Color(hex: "0284C7"), style: StrokeStyle(lineWidth: 1.2, dash: [3, 2]))
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: - Remote Image View (for API categories)
    private var remoteImageView: some View {
        Group {
            if let urlString = remoteImageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size, height: size)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    case .failure:
                        fallbackCategoryIcon
                    case .empty:
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color(hex: "F3F4F6"))
                            ProgressView()
                                .scaleEffect(0.6)
                        }
                        .frame(width: size, height: size)
                    @unknown default:
                        fallbackCategoryIcon
                    }
                }
            } else {
                fallbackCategoryIcon
            }
        }
    }
    
    private var fallbackCategoryIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(MyLooQTheme.pastelPurpleGlow)
            Image(systemName: "sparkles")
                .font(.system(size: size * 0.4))
                .foregroundColor(MyLooQTheme.primaryPurple)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Helper Shapes

struct ArcEyeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addQuadCurve(to: CGPoint(x: rect.width, y: rect.height), control: CGPoint(x: rect.width / 2, y: 0))
        return path
    }
}

struct ArcSmileShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addQuadCurve(to: CGPoint(x: rect.width, y: 0), control: CGPoint(x: rect.width / 2, y: rect.height))
        return path
    }
}

#Preview {
    HStack(spacing: 12) {
        SalonCategoryIconView(iconType: .bridalFacial, remoteImageUrl: nil, size: 48)
        SalonCategoryIconView(iconType: .classicFacial, remoteImageUrl: nil, size: 48)
        SalonCategoryIconView(iconType: .mask, remoteImageUrl: nil, size: 48)
        SalonCategoryIconView(iconType: .premiumFacial, remoteImageUrl: nil, size: 48)
        SalonCategoryIconView(iconType: .waxing, remoteImageUrl: nil, size: 48)
        SalonCategoryIconView(iconType: .threading, remoteImageUrl: nil, size: 48)
    }
    .padding()
}
