//
//  BottomCurvedBackground.swift
//  IOSMyloqlogin
//

import SwiftUI

/// An upward-curving dome shape that matches the bottom background in the screenshot
struct DomeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Starts on the left edge, about 55% down from top of rect
        let edgeY = rect.height * 0.52
        let topY = rect.height * 0.08
        
        path.move(to: CGPoint(x: 0, y: edgeY))
        
        // Gentle smooth upward arch to the right edge
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: edgeY),
            control: CGPoint(x: rect.width / 2.0, y: topY)
        )
        
        // Down to bottom-right
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        // Over to bottom-left
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

struct BottomCurvedBackground: View {
    var height: CGFloat = 220
    
    var body: some View {
        ZStack {
            // Soft gradient outline along the arch edge
            DomeShape()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.02),
                            Color.black.opacity(0.08),
                            Color.black.opacity(0.02)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 1.5
                )
                .blur(radius: 2)
            
            // Shaded fill inside the dome
            DomeShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white,
                            Color(hex: "F7F8FA"),
                            Color(hex: "ECEEF2")
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .frame(height: height)
    }
}

#Preview {
    VStack {
        Spacer()
        BottomCurvedBackground()
    }
    .background(Color.white)
}
