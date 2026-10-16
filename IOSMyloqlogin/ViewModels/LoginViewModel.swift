//
//  LoginViewModel.swift
//  IOSMyloqlogin
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// User entered mobile number (digits only or formatted)
    @Published var phoneNumber: String = "" {
        didSet {
            // Filter non-digits and cap to maxDigits
            let filtered = phoneNumber.filter { $0.isNumber }
            if filtered.count > selectedCountry.maxDigits {
                phoneNumber = String(filtered.prefix(selectedCountry.maxDigits))
            } else if filtered != phoneNumber && !phoneNumber.isEmpty {
                phoneNumber = filtered
            }
            if errorMessage != nil {
                errorMessage = nil
            }
        }
    }
    
    /// Currently selected country for dialing code
    @Published var selectedCountry: Country = Country.netherlands
    
    /// Currently selected user role (User or Provider)
    @Published var selectedRole: UserRole = .user {
        didSet {
            // Reset error state and navigation when switching between User and Provider
            errorMessage = nil
            showErrorAlert = false
            isProviderOnboardingPresented = false
            isOTPViewPresented = false
        }
    }
    
    /// Loading state for authentication
    @Published var isLoading: Bool = false
    
    /// Error message for validation or network errors
    @Published var errorMessage: String? = nil
    @Published var showErrorAlert: Bool = false
    
    /// Success feedback
    @Published var showSuccessAlert: Bool = false
    @Published var successMessage: String = ""
    
    /// Navigation & Sheet Presentation states
    @Published var isCountryPickerPresented: Bool = false
    @Published var isTermsPresented: Bool = false
    @Published var isPrivacyPresented: Bool = false
    @Published var isRegisterPresented: Bool = false
    @Published var isOTPViewPresented: Bool = false
    @Published var isProviderOnboardingPresented: Bool = false
    @Published var isBackTapped: Bool = false
    
    // MARK: - Role-based Phone Number Constants
    
    /// The only accepted phone number for User login
    static let acceptedUserPhoneNumber = "9092943541"
    
    /// The only accepted phone number for Provider login
    static let acceptedProviderPhoneNumber = "9999988888"
    
    /// The expected phone number for the currently active role
    var expectedPhoneNumber: String {
        switch selectedRole {
        case .user:
            return Self.acceptedUserPhoneNumber
        case .provider:
            return Self.acceptedProviderPhoneNumber
        }
    }
    
    // MARK: - Computed Properties
    
    /// Combined country dial code and phone number
    var fullPhoneNumber: String {
        "\(selectedCountry.dialCode) \(phoneNumber)"
    }
    
    /// Validates if entered phone number matches the expected number for the selected role
    var isPhoneValid: Bool {
        let digits = phoneNumber.filter { $0.isNumber }
        return digits == expectedPhoneNumber
    }
    
    // MARK: - Actions
    
    /// Initiates login / OTP verification flow
    func login() {
        let trimmed = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Please enter your mobile number"
            showErrorAlert = true
            return
        }
        
        let digits = phoneNumber.filter { $0.isNumber }
        let expected = expectedPhoneNumber
        
        // Strict role-specific validation:
        // User -> 9092943541
        // Provider -> 9999988888
        guard digits == expected else {
            errorMessage = "Only \(expected) is registered for \(selectedRole.rawValue) login."
            showErrorAlert = true
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Simulate asynchronous network authentication
        Task {
            try? await Task.sleep(nanoseconds: 600_000_000) // 0.6s
            self.isLoading = false
            
            if self.selectedRole == .provider {
                // Provider bypasses OTP verification and navigates directly to onboarding status
                self.isProviderOnboardingPresented = true
            } else {
                // User continues to OTP verification
                self.isOTPViewPresented = true
            }
        }
    }
    
    /// Navigates to registration flow
    func register() {
        isRegisterPresented = true
    }
    
    /// Selects a country from the country picker
    func selectCountry(_ country: Country) {
        selectedCountry = country
        isCountryPickerPresented = false
        // Re-trim phone number if it exceeds new country's max digits
        let digits = phoneNumber.filter { $0.isNumber }
        if digits.count > country.maxDigits {
            phoneNumber = String(digits.prefix(country.maxDigits))
        }
    }
    
    /// Handle back button action
    func handleBack() {
        isBackTapped = true
    }
    
    /// Clear the phone number field
    func clearPhoneNumber() {
        phoneNumber = ""
    }
}
