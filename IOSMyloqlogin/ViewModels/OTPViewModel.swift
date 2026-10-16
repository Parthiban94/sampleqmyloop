//
//  OTPViewModel.swift
//  IOSMyloqlogin
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class OTPViewModel: ObservableObject {
    // MARK: - Constants
    
    /// The expected OTP code as specified in requirements
    static let acceptedOTP = "123456"
    
    // MARK: - Published Properties
    
    /// The user-entered 6 digit OTP string
    @Published var otpCode: String = "" {
        didSet {
            // Keep only digits and cap to 6
            let filtered = otpCode.filter { $0.isNumber }
            if filtered.count > 6 {
                otpCode = String(filtered.prefix(6))
            } else if filtered != otpCode {
                otpCode = filtered
            }
            if errorMessage != nil {
                errorMessage = nil
            }
        }
    }
    
    /// Mobile phone number passed from login flow
    @Published var phoneNumber: String
    
    /// Loading state for the verification process
    @Published var isLoading: Bool = false
    
    /// Error message for validation feedback
    @Published var errorMessage: String? = nil
    @Published var showErrorAlert: Bool = false
    
    /// Flag indicating whether OTP has been successfully verified
    @Published var isVerified: Bool = false
    
    /// Simulated SMS Push Banner visibility
    @Published var showSMSBanner: Bool = false
    @Published var smsBannerDismissTask: Task<Void, Never>? = nil
    
    /// Resend cooldown timer state
    @Published var resendCooldown: Int = 0
    private var timerCancellable: AnyCancellable?
    
    // MARK: - Initialization
    
    init(phoneNumber: String = "9092943541", initialOTP: String = "", autoTriggerSMS: Bool = true) {
        self.phoneNumber = phoneNumber
        self.otpCode = initialOTP
        if autoTriggerSMS {
            // Schedule simulated incoming SMS with the code 123456
            triggerIncomingSMS()
        }
    }
    
    // MARK: - Computed Properties
    
    /// Masked representation of phone number matching "XX XXX 4567" from design
    var maskedPhoneNumber: String {
        let digits = phoneNumber.filter { $0.isNumber }
        if digits.count >= 4 {
            let last4 = String(digits.suffix(4))
            return "XX XXX \(last4)"
        }
        return "XX XXX 4567"
    }
    
    /// Array of 6 characters for the OTP box display
    var boxDigits: [String] {
        var result: [String] = []
        let chars = Array(otpCode)
        for i in 0..<6 {
            if i < chars.count {
                result.append(String(chars[i]))
            } else {
                result.append("")
            }
        }
        return result
    }
    
    /// Whether the Confirm button is ready
    var canConfirm: Bool {
        otpCode.count == 6 && !isLoading
    }
    
    // MARK: - Actions
    
    /// Simulates receiving an incoming SMS banner containing OTP 123456
    func triggerIncomingSMS() {
        Task {
            try? await Task.sleep(nanoseconds: 700_000_000) // 0.7s delay
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                self.showSMSBanner = true
            }
            
            // Auto dismiss banner after 8 seconds if not interacted
            self.smsBannerDismissTask?.cancel()
            self.smsBannerDismissTask = Task {
                try? await Task.sleep(nanoseconds: 8_000_000_000)
                if !Task.isCancelled {
                    withAnimation(.easeOut(duration: 0.3)) {
                        self.showSMSBanner = false
                    }
                }
            }
        }
    }
    
    /// Dismiss SMS banner manually
    func dismissSMSBanner() {
        smsBannerDismissTask?.cancel()
        withAnimation(.easeOut(duration: 0.25)) {
            showSMSBanner = false
        }
    }
    
    /// Autofill code from SMS banner (123456)
    func autofillReceivedOTP() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            otpCode = Self.acceptedOTP
        }
        dismissSMSBanner()
    }
    
    /// Confirm and verify the OTP code
    func confirmOTP() {
        let trimmed = otpCode.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count == 6 else {
            errorMessage = "Please enter the complete 6-digit verification code"
            showErrorAlert = true
            return
        }
        
        guard trimmed == Self.acceptedOTP else {
            errorMessage = "Incorrect code. Please enter the received OTP: \(Self.acceptedOTP)"
            showErrorAlert = true
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1.0s network simulation
            self.isLoading = false
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                self.isVerified = true
            }
        }
    }
    
    /// Resend OTP code action
    func resendOTP() {
        guard resendCooldown == 0 else { return }
        
        otpCode = ""
        errorMessage = nil
        resendCooldown = 30
        
        // Trigger simulated SMS with code 123456 again
        triggerIncomingSMS()
        
        // Run countdown timer
        timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.resendCooldown > 1 {
                    self.resendCooldown -= 1
                } else {
                    self.resendCooldown = 0
                    self.timerCancellable?.cancel()
                }
            }
    }
}
