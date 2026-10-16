//
//  OTPInputView.swift
//  IOSMyloqlogin
//

import SwiftUI

struct OTPInputView: View {
    @Binding var otpCode: String
    @FocusState private var isFocused: Bool
    var autoFocus: Bool = false
    
    var body: some View {
        ZStack {
            // Invisible native TextField overlay to capture keyboard input, backspaces, and SMS auto-fill
            TextField("", text: $otpCode)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .opacity(0.01)
                .frame(width: 1, height: 1)
            
            // Visual 6 digit boxes
            HStack(spacing: 9) {
                ForEach(0..<6, id: \.self) { index in
                    digitBox(for: index)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
        .onAppear {
            if autoFocus {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    isFocused = true
                }
            }
        }
    }
    
    @ViewBuilder
    private func digitBox(for index: Int) -> some View {
        let character = char(at: index)
        let isFilled = !character.isEmpty
        
        ZStack {
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(isFilled ? Color.white : MyLooQTheme.otpBoxEmpty)
                .frame(width: 48, height: 54)
                .shadow(
                    color: isFilled ? Color.black.opacity(0.08) : Color.clear,
                    radius: 6,
                    x: 0,
                    y: 2
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .stroke(
                            isFilled ? Color.black.opacity(0.05) : Color.clear,
                            lineWidth: 1
                        )
                )
            
            if isFilled {
                Text(character)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(MyLooQTheme.darkText)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Text("-")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(MyLooQTheme.otpDashColor)
            }
        }
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: character)
    }
    
    private func char(at index: Int) -> String {
        let chars = Array(otpCode)
        if index < chars.count {
            return String(chars[index])
        }
        return ""
    }
}

#Preview {
    VStack(spacing: 20) {
        OTPInputView(otpCode: .constant("111"))
        OTPInputView(otpCode: .constant("123456"))
        OTPInputView(otpCode: .constant(""))
    }
    .padding()
    .background(Color.white)
}
