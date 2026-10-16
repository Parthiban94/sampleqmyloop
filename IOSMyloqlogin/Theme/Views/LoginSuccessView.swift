//
//  LoginSuccessView.swift
//  IOSMyloqlogin
//

import SwiftUI

struct LoginSuccessView: View {
    let phoneNumber: String
    let onContinue: () -> Void
    let onSignOut: () -> Void
    
    @State private var animateCheckmark: Bool = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            BottomCurvedBackground(height: 240)
                .ignoresSafeArea(edges: .bottom)
            
            VStack(spacing: 24) {
                Spacer()
                
                // Animated Success Checkmark
                ZStack {
                    Circle()
                        .fill(MyLooQTheme.pastelPurpleGlow)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .stroke(MyLooQTheme.primaryPurple, lineWidth: 3)
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(MyLooQTheme.primaryPurple)
                        .scaleEffect(animateCheckmark ? 1.0 : 0.4)
                        .opacity(animateCheckmark ? 1.0 : 0.0)
                }
                .padding(.bottom, 8)
                
                // Success Texts
                VStack(spacing: 10) {
                    Text("Verification Successful!")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(MyLooQTheme.darkText)
                    
                    Text("Welcome to MyLooQ")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(MyLooQTheme.primaryPurple)
                    
                    Text("Your mobile number \(phoneNumber) has been successfully authenticated.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(MyLooQTheme.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                Spacer()
                
                // Buttons
                VStack(spacing: 12) {
                    Button(action: onContinue) {
                        Text("Continue to Home")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                Capsule()
                                    .fill(MyLooQTheme.primaryPurple)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())
                    
                    Button(action: onSignOut) {
                        Text("Sign out / Back to Login")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(MyLooQTheme.darkText)
                            .frame(height: 44)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 36)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1)) {
                animateCheckmark = true
            }
        }
    }
}

#Preview {
    LoginSuccessView(
        phoneNumber: "+31 9092943541",
        onContinue: {},
        onSignOut: {}
    )
}
