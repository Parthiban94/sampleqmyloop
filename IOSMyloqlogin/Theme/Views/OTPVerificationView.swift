//
//  OTPVerificationView.swift
//  IOSMyloqlogin
//

import SwiftUI

struct OTPVerificationView: View {
    @StateObject private var viewModel: OTPViewModel
    @Environment(\.dismiss) private var dismiss
    let userRole: UserRole
    
    init(phoneNumber: String = "9092943541", userRole: UserRole = .user, initialOTP: String = "", autoTriggerSMS: Bool = true) {
        self.userRole = userRole
        _viewModel = StateObject(wrappedValue: OTPViewModel(phoneNumber: phoneNumber, initialOTP: initialOTP, autoTriggerSMS: autoTriggerSMS))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Background
                Color.white
                    .ignoresSafeArea()
                
                // Bottom curved background
                BottomCurvedBackground(height: 220)
                    .ignoresSafeArea(edges: .bottom)
                
                // Main Content
                VStack(spacing: 0) {
                    // Header Bar (Back button)
                    headerBar
                        .padding(.top, 12)
                        .padding(.horizontal, 24)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            // Center Illustration
                            OTPInboxIllustrationView()
                                .padding(.top, 24)
                                .padding(.bottom, 28)
                            
                            // Title & Subtitle
                            VStack(spacing: 8) {
                                Text("Check your message inbox")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(MyLooQTheme.darkText)
                                    .multilineTextAlignment(.center)
                                
                                Text("Enter the verification code send to")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(MyLooQTheme.secondaryText)
                                    .multilineTextAlignment(.center)
                                
                                Text(viewModel.maskedPhoneNumber)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(MyLooQTheme.accentCoral)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal, 24)
                            
                            // 6-digit OTP Input Boxes
                            OTPInputView(otpCode: $viewModel.otpCode)
                                .padding(.top, 32)
                                .padding(.horizontal, 20)
                            
                            // Inline Error message if code is incorrect
                            if let error = viewModel.errorMessage {
                                HStack(spacing: 6) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.system(size: 13))
                                    Text(error)
                                        .font(.system(size: 13, weight: .medium))
                                }
                                .foregroundColor(.red)
                                .padding(.top, 10)
                                .padding(.horizontal, 28)
                                .transition(.opacity)
                            }
                            
                            // "Didn't receive it? Resend it"
                            resendSection
                                .padding(.top, 20)
                            
                            // Purple Pill "Confirm" Button
                            confirmButton
                                .padding(.top, 28)
                                .padding(.horizontal, 24)
                        }
                    }
                    
                    Spacer(minLength: 16)
                    
                    // Bottom "Back to login" inside the curved dome
                    backToLoginButton
                        .padding(.bottom, 36)
                }
                
                // Floating Incoming SMS Banner (Simulating received OTP 123456)
                if viewModel.showSMSBanner {
                    VStack {
                        SMSNotificationBanner(
                            code: OTPViewModel.acceptedOTP,
                            onAutofill: {
                                viewModel.autofillReceivedOTP()
                            },
                            onDismiss: {
                                viewModel.dismissSMSBanner()
                            }
                        )
                        .padding(.top, 10)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        
                        Spacer()
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            // Alert for verification error
            .alert("Verification Error", isPresented: $viewModel.showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            // Navigate to ProviderOnboardingView for Provider, or SalonCategoriesView for User
            .fullScreenCover(isPresented: $viewModel.isVerified) {
                if userRole == .provider {
                    ProviderOnboardingView()
                } else {
                    SalonCategoriesView()
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    /// Top Header with Circular Back Button
    private var headerBar: some View {
        HStack {
            Button(action: {
                dismiss()
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
        }
    }
    
    /// Resend code text and button
    private var resendSection: some View {
        HStack(spacing: 4) {
            Text("Didn't receive it?")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(MyLooQTheme.secondaryText)
            
            Button(action: {
                viewModel.resendOTP()
            }) {
                if viewModel.resendCooldown > 0 {
                    Text("Resend in \(viewModel.resendCooldown)s")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(MyLooQTheme.mutedText)
                } else {
                    Text("Resend it")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(MyLooQTheme.darkText)
                }
            }
            .buttonStyle(.plain)
            .disabled(viewModel.resendCooldown > 0)
        }
    }
    
    /// Primary Purple Confirm Button
    private var confirmButton: some View {
        Button(action: {
            viewModel.confirmOTP()
        }) {
            HStack(spacing: 8) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                
                Text("Confirm")
                    .font(.system(size: 16, weight: .bold))
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
    
    /// "Back to login" button positioned inside the bottom curved dome
    private var backToLoginButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Back to login")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(MyLooQTheme.darkText)
                .padding(.vertical, 8)
                .padding(.horizontal, 24)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OTPVerificationView(phoneNumber: "9092943541")
}
