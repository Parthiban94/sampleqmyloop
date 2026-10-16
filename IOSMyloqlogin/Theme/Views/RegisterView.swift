//
//  RegisterView.swift
//  IOSMyloqlogin
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var fullName: String = ""
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var selectedCountry: Country = .netherlands
    @State private var isCountryPickerPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    MyLooQLogoView(size: 60)
                        .padding(.top, 16)
                    
                    VStack(spacing: 6) {
                        Text("Create Account")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(MyLooQTheme.darkText)
                        
                        Text("Sign up to experience MyLooQ services")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(MyLooQTheme.secondaryText)
                    }
                    
                    VStack(spacing: 16) {
                        // Full Name
                        TextField("Full Name", text: $fullName)
                            .padding(.horizontal, 16)
                            .frame(height: 54)
                            .background(
                                Capsule()
                                    .fill(MyLooQTheme.lightGrayBackground)
                            )
                        
                        // Mobile Number
                        PhoneNumberInputField(
                            phoneNumber: $phoneNumber,
                            selectedCountry: selectedCountry,
                            onCountryTapped: {
                                isCountryPickerPresented = true
                            }
                        )
                        
                        // Email
                        TextField("Email Address", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .padding(.horizontal, 16)
                            .frame(height: 54)
                            .background(
                                Capsule()
                                    .fill(MyLooQTheme.lightGrayBackground)
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    // Register Action Button
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Register account")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                Capsule()
                                    .fill(MyLooQTheme.primaryPurple)
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    
                    Spacer()
                }
            }
            .navigationTitle("Register")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(MyLooQTheme.primaryPurple)
                }
            }
            .sheet(isPresented: $isCountryPickerPresented) {
                CountryPickerSheet(selectedCountry: $selectedCountry)
            }
        }
    }
}

#Preview {
    RegisterView()
}
