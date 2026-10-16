//
//  MyLooQLogoView.swift
//  IOSMyloqlogin
//

import SwiftUI

struct MyLooQLogoView: View {
    var size: CGFloat = 52
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(MyLooQTheme.primaryPurple)
                .frame(width: size, height: size)
            
            // Stylized MyLooQ Eye Icon in white
            MyLooQEyeShape()
                .frame(width: size * 0.56, height: size * 0.42)
        }
    }
}

/// Precise reproduction of the MyLooQ brand eye symbol
struct MyLooQEyeShape: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            
            ZStack {
                // 1. Eyebrow / Upper curved arch
                Path { path in
                    path.move(to: CGPoint(x: w * 0.12, y: h * 0.22))
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.88, y: h * 0.22),
                        control: CGPoint(x: w * 0.50, y: -h * 0.08)
                    )
                }
                .stroke(Color.white, style: StrokeStyle(lineWidth: w * 0.10, lineCap: .round))
                
                // 2. Eye almond contour (lower and mid curves)
                Path { path in
                    // Upper curve of eye
                    path.move(to: CGPoint(x: w * 0.08, y: h * 0.62))
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.92, y: h * 0.62),
                        control: CGPoint(x: w * 0.50, y: h * 0.28)
                    )
                    // Lower curve of eye
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.08, y: h * 0.62),
                        control: CGPoint(x: w * 0.50, y: h * 0.98)
                    )
                    path.closeSubpath()
                }
                .stroke(Color.white, style: StrokeStyle(lineWidth: w * 0.08, lineCap: .round, lineJoin: .round))
                
                // 3. Central Pupil
                Circle()
                    .fill(Color.white)
                    .frame(width: w * 0.32, height: w * 0.32)
                    .position(x: w * 0.50, y: h * 0.62)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        MyLooQLogoView(size: 60)
        MyLooQLogoView(size: 100)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
