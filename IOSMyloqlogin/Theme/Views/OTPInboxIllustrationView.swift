//
//  OTPInboxIllustrationView.swift
//  IOSMyloqlogin
//

import SwiftUI

/// Vector speech bubble shape with a small downward-left pointing tail
struct SpeechBubbleShape: Shape {
    var cornerRadius: CGFloat = 14
    var tailWidth: CGFloat = 10
    var tailHeight: CGFloat = 10
    var tailLeadingOffset: CGFloat = 32
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let r = cornerRadius
        
        // Start after top-left corner
        path.move(to: CGPoint(x: r, y: 0))
        // Top edge
        path.addLine(to: CGPoint(x: w - r, y: 0))
        // Top-right corner
        path.addArc(
            center: CGPoint(x: w - r, y: r),
            radius: r,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )
        // Right edge
        path.addLine(to: CGPoint(x: w, y: h - r))
        // Bottom-right corner
        path.addArc(
            center: CGPoint(x: w - r, y: h - r),
            radius: r,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        // Bottom edge toward tail
        path.addLine(to: CGPoint(x: tailLeadingOffset + tailWidth, y: h))
        // Tail tip pointing down-left
        path.addLine(to: CGPoint(x: tailLeadingOffset - 2, y: h + tailHeight))
        // Tail return to bottom edge
        path.addLine(to: CGPoint(x: tailLeadingOffset, y: h))
        // Bottom edge to bottom-left corner
        path.addLine(to: CGPoint(x: r, y: h))
        // Bottom-left corner
        path.addArc(
            center: CGPoint(x: r, y: h - r),
            radius: r,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        // Left edge
        path.addLine(to: CGPoint(x: 0, y: r))
        // Top-left corner
        path.addArc(
            center: CGPoint(x: r, y: r),
            radius: r,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}

/// Faithful replication of the illustration from the OTP screen
struct OTPInboxIllustrationView: View {
    var body: some View {
        ZStack {
            // Background soft lavender circles
            Circle()
                .fill(MyLooQTheme.pastelPurpleSecondary)
                .frame(width: 80, height: 80)
                .offset(x: 36, y: -26)
            
            Circle()
                .fill(MyLooQTheme.pastelPurpleGlow)
                .frame(width: 82, height: 82)
                .offset(x: -38, y: 24)
            
            // Phone outline
            phoneBody
            
            // Radiating vibration / signal rays to the right
            signalRays
                .offset(x: 64, y: -20)
            
            // Message bubble overlapping the phone
            messageBubble
                .offset(y: -4)
        }
        .frame(width: 170, height: 160)
    }
    
    // MARK: - Phone Body
    private var phoneBody: some View {
        ZStack {
            // Phone outer shell
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(MyLooQTheme.primaryPurple, lineWidth: 2.8)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.white)
                )
                .frame(width: 92, height: 136)
            
            // Top speaker notch
            Capsule()
                .fill(MyLooQTheme.primaryPurple)
                .frame(width: 22, height: 3.2)
                .offset(y: -54)
            
            // Bottom home button
            Capsule()
                .stroke(MyLooQTheme.primaryPurple, lineWidth: 2.2)
                .frame(width: 16, height: 7.5)
                .offset(y: 53)
        }
    }
    
    // MARK: - Message Bubble
    private var messageBubble: some View {
        ZStack {
            // Bubble background fill
            SpeechBubbleShape(cornerRadius: 13, tailWidth: 9, tailHeight: 9, tailLeadingOffset: 34)
                .fill(Color.white)
            
            // Bubble stroke
            SpeechBubbleShape(cornerRadius: 13, tailWidth: 9, tailHeight: 9, tailLeadingOffset: 34)
                .stroke(MyLooQTheme.primaryPurple, lineWidth: 2.6)
            
            // 4 pink asterisks inside the bubble
            HStack(spacing: 7) {
                ForEach(0..<4, id: \.self) { _ in
                    Image(systemName: "asterisk")
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundColor(MyLooQTheme.accentCoral)
                }
            }
            .offset(y: -2)
        }
        .frame(width: 114, height: 38)
    }
    
    // MARK: - Signal Rays
    private var signalRays: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Slanted upper ray
            Capsule()
                .fill(MyLooQTheme.primaryPurple)
                .frame(width: 14, height: 2.5)
                .rotationEffect(.degrees(-32))
            
            // Horizontal middle ray
            Capsule()
                .fill(MyLooQTheme.primaryPurple)
                .frame(width: 12, height: 2.5)
                .offset(x: 2)
        }
    }
}

#Preview {
    OTPInboxIllustrationView()
        .padding(40)
}
