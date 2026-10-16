//
//  LoginView.swift
//  IOSMyloqlogin
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Background
                Color.white
                    .ignoresSafeArea()
                
                // Bottom curved dome background decoration
                BottomCurvedBackground(height: 240)
                    .ignoresSafeArea(edges: .bottom)
                
                // Main content
                VStack(spacing: 0) {
                    // Top Navigation Bar (Back button and Logo)
                    headerBar
                        .padding(.top, 12)
                        .padding(.horizontal, 24)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            // Title & Subtitle
                            VStack(spacing: 8) {
                                Text("Login Account")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(MyLooQTheme.darkText)
                                
                                Text("Use your MyLooQ registered mobile number")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(MyLooQTheme.secondaryText)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 36)
                            .padding(.horizontal, 24)
                            
                            // User & Provider Tab Bar
                            RoleTabBar(selectedRole: $viewModel.selectedRole)
                                .padding(.top, 24)
                                .padding(.horizontal, 24)
                            
                            // Phone Number Input Field
                            PhoneNumberInputField(
                                phoneNumber: $viewModel.phoneNumber,
                                selectedCountry: viewModel.selectedCountry,
                                onCountryTapped: {
                                    viewModel.isCountryPickerPresented = true
                                },
                                isError: viewModel.errorMessage != nil
                            )
                            .padding(.top, 16)
                            .padding(.horizontal, 24)
                            
                            // Inline Error message if phone number is not valid
                            if let error = viewModel.errorMessage {
                                HStack(spacing: 6) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.system(size: 13))
                                    Text(error)
                                        .font(.system(size: 13, weight: .medium))
                                }
                                .foregroundColor(.red)
                                .padding(.top, 8)
                                .padding(.horizontal, 28)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.opacity)
                            }
                            
                            // Primary Button: "Login account"
                            loginButton
                                .padding(.top, 16)
                                .padding(.horizontal, 24)
                        
                            // "or" Divider
                            orDivider
                                .padding(.top, 28)
                                .padding(.bottom, 28)
                                .padding(.horizontal, 24)
                            
                            // Secondary Button: "Register account"
                            registerButton
                                .padding(.horizontal, 24)
                        }
                    }
                    
                    Spacer(minLength: 16)
                    
                    // Bottom Legal Text
                    legalFooterView
                        .padding(.bottom, 28)
                        .padding(.horizontal, 24)
                }
            }
            .sheet(isPresented: $viewModel.isCountryPickerPresented) {
                CountryPickerSheet(selectedCountry: $viewModel.selectedCountry)
            }
            .sheet(isPresented: $viewModel.isTermsPresented) {
                TermsAndConditionsView()
            }
            .sheet(isPresented: $viewModel.isPrivacyPresented) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $viewModel.isRegisterPresented) {
                RegisterView()
            }
            .fullScreenCover(isPresented: $viewModel.isOTPViewPresented) {
                OTPVerificationView(phoneNumber: viewModel.phoneNumber, userRole: viewModel.selectedRole)
            }
            .fullScreenCover(isPresented: $viewModel.isProviderOnboardingPresented) {
                ProviderOnboardingView()
            }
            .alert("Notice", isPresented: $viewModel.showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .alert("Verification Sent", isPresented: $viewModel.showSuccessAlert) {
                Button("Continue", role: .cancel) {}
            } message: {
                Text(viewModel.successMessage)
            }
            .alert("Back Navigation", isPresented: $viewModel.isBackTapped) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Back button tapped.")
            }
        }
    }
    
    // MARK: - Subviews
    
    /// Header with circular back button on leading edge and MyLooQ logo in center
    private var headerBar: some View {
        HStack {
            // Circular Back Button
            Button(action: {
                viewModel.handleBack()
            }) {
                ZStack {
                    Circle()
                        .fill(MyLooQTheme.lightGrayBackground)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(MyLooQTheme.darkText)
                }
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // Centered MyLooQ Logo
            MyLooQLogoView(size: 48)
            
            Spacer()
            
            // Invisible placeholder of equal width to keep logo perfectly centered
            Color.clear
                .frame(width: 44, height: 44)
        }
    }
    
    /// Primary Purple Login Button
    private var loginButton: some View {
        Button(action: {
            viewModel.login()
        }) {
            HStack(spacing: 8) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                
                Text("Login account")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                Capsule()
                    .fill(MyLooQTheme.primaryPurple)
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(viewModel.isLoading)
    }
    
    /// "or" Divider with horizontal lines
    private var orDivider: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(MyLooQTheme.lightDivider)
                .frame(height: 1)
            
            Text("or")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(MyLooQTheme.mutedText)
            
            Rectangle()
                .fill(MyLooQTheme.lightDivider)
                .frame(height: 1)
        }
    }
    
    /// Outlined Register Button
    private var registerButton: some View {
        Button(action: {
            viewModel.register()
        }) {
            Text("Register account")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(MyLooQTheme.darkText)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    Capsule()
                        .stroke(MyLooQTheme.darkBorder, lineWidth: 1.5)
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    /// Terms & Conditions and Privacy Policy footer
    private var legalFooterView: some View {
        VStack(spacing: 5) {
            Text("By proceeding, I accept the")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(MyLooQTheme.secondaryText)
            
            HStack(spacing: 4) {
                Button(action: {
                    viewModel.isTermsPresented = true
                }) {
                    Text("Terms & Conditions")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(MyLooQTheme.darkText)
                }
                .buttonStyle(.plain)
                
                Text("and")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(MyLooQTheme.secondaryText)
                
                Button(action: {
                    viewModel.isPrivacyPresented = true
                }) {
                    Text("Privacy policy")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(MyLooQTheme.darkText)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

/// Subtle spring scale effect on tap
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    LoginView()
}
