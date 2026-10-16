//
//  PhoneNumberInputField.swift
//  IOSMyloqlogin
//

import SwiftUI

struct PhoneNumberInputField: View {
    @Binding var phoneNumber: String
    let selectedCountry: Country
    let onCountryTapped: () -> Void
    
    var isError: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Flag + Chevron capsule button
            CountrySelectorCapsule(country: selectedCountry, action: onCountryTapped)
                .padding(.leading, 6)
            
            // Text Input
            ZStack(alignment: .leading) {
                if phoneNumber.isEmpty {
                    Text("Mobile number")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color(hex: "9E9E9E"))
                }
                
                TextField("", text: $phoneNumber)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(MyLooQTheme.darkText)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
            }
            
            // Clear button if text is entered
            if !phoneNumber.isEmpty {
                Button(action: {
                    phoneNumber = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(hex: "B0B0B0"))
                        .font(.system(size: 16))
                }
                .padding(.trailing, 12)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 6)
        .frame(height: 58)
        .background(
            Capsule()
                .fill(MyLooQTheme.lightGrayBackground)
        )
        .overlay(
            Capsule()
                .stroke(isError ? Color.red.opacity(0.7) : Color.clear, lineWidth: 1.2)
        )
    }
}

#Preview {
    PhoneNumberInputField(
        phoneNumber: .constant(""),
        selectedCountry: .netherlands,
        onCountryTapped: {}
    )
    .padding()
}
