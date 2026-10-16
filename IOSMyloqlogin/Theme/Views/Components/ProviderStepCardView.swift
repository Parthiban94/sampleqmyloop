//
//  ProviderStepCardView.swift
//  IOSMyloqlogin
//

import SwiftUI

struct ProviderStepCardView: View {
    let step: ProviderStep
    let isFirst: Bool
    let isLast: Bool
    let onAction: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            // Left Stepper Indicator with Continuous Dotted Connectors
            ZStack(alignment: .top) {
                // Background vertical dashed line
                GeometryReader { geo in
                    Path { path in
                        let startY: CGFloat = isFirst ? 18 : 0
                        let endY: CGFloat = isLast ? 18 : geo.size.height
                        path.move(to: CGPoint(x: geo.size.width / 2.0, y: startY))
                        path.addLine(to: CGPoint(x: geo.size.width / 2.0, y: endY))
                    }
                    .stroke(Color(hex: "D1D5DB"), style: StrokeStyle(lineWidth: 1.5, dash: [4, 4]))
                }
                .frame(width: 36)
                
                // Step Indicator Circle
                if step.isCompleted {
                    // Completed state: Green circle with white checkmark
                    Circle()
                        .fill(Color(hex: "00C853"))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        )
                } else {
                    // Incomplete state: White circle with subtle gray border and step number
                    Circle()
                        .fill(Color.white)
                        .frame(width: 36, height: 36)
                        .overlay(
                            Circle()
                                .stroke(Color(hex: "E5E7EB"), lineWidth: 1.5)
                        )
                        .overlay(
                            Text("\(step.stepNumber)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: "222222"))
                        )
                }
            }
            .frame(width: 36)
            
            // Right Content Card
            VStack(alignment: .leading, spacing: 6) {
                Text(step.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(hex: "1A1A1A"))
                
                if let description = step.description {
                    Text(description)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(hex: "7E7E7E"))
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                if let buttonTitle = step.buttonTitle {
                    // Step buttons change to green background with checkmark when completed
                    let hasGreenButton = step.isCompleted
                    
                    Button(action: onAction) {
                        HStack(spacing: 6) {
                            if hasGreenButton {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 11, weight: .bold))
                            }
                            
                            Text(buttonTitle)
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(hasGreenButton ? .white : Color(hex: "111111"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(hasGreenButton ? Color(hex: "00C853") : Color(hex: "F0F1F5"))
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.top, 4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, step.description == nil ? 14 : 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
            )
        }
        .padding(.horizontal, 18)
    }
}

/// Helper shape to draw a vertical line for the dashed connector
struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
        return path
    }
}

#Preview {
    VStack(spacing: 0) {
        ProviderStepCardView(step: ProviderStep.defaultSteps[0], isFirst: true, isLast: false, onAction: {})
        ProviderStepCardView(step: ProviderStep.defaultSteps[1], isFirst: false, isLast: false, onAction: {})
        ProviderStepCardView(step: ProviderStep.defaultSteps[5], isFirst: false, isLast: true, onAction: {})
    }
    .padding()
}
