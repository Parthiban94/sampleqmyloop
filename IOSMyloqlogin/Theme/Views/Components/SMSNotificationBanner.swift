//
//  SMSNotificationBanner.swift
//  IOSMyloqlogin
//

import SwiftUI

struct SMSNotificationBanner: View {
    let code: String
    let onAutofill: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Messages App Green Icon
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(hex: "34C759"))
                    .frame(width: 38, height: 38)
                
                Image(systemName: "message.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("MESSAGES")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: "6B7280"))
                    
                    Text("•")
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "9CA3AF"))
                    
                    Text("now")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(Color(hex: "9CA3AF"))
                    
                    Spacer()
                    
                    // Close button
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Color(hex: "9CA3AF"))
                            .padding(4)
                    }
                }
                
                Text("Your MyLooQ code is ")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(MyLooQTheme.darkText)
                + Text(code)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(MyLooQTheme.primaryPurple)
                + Text(". Do not share it.")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(MyLooQTheme.darkText)
            }
            
            // Autofill Action Pill
            Button(action: onAutofill) {
                Text("Autofill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(MyLooQTheme.primaryPurple)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 6)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    SMSNotificationBanner(
        code: "123456",
        onAutofill: {},
        onDismiss: {}
    )
    .padding()
}
