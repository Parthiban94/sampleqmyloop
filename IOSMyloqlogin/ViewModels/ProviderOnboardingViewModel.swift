//
//  ProviderOnboardingViewModel.swift
//  IOSMyloqlogin
//

import Foundation
import SwiftUI
import Combine

enum ProviderTab: String, CaseIterable, Identifiable {
    case home = "Home"
    case orders = "Orders"
    case wallet = "Wallet"
    case profile = "Profile"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .orders: return "list.clipboard"
        case .wallet: return "creditcard"
        case .profile: return "person"
        }
    }
}

@MainActor
final class ProviderOnboardingViewModel: ObservableObject {
    @Published var steps: [ProviderStep] = ProviderStep.defaultSteps
    @Published var selectedTab: ProviderTab = .home
    
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    // Notifications state
    @Published var unreadNotificationsCount: Int = 1
    
    // Navigation state
    @Published var isSelectDocumentPresented: Bool = false
    @Published var uploadedDocumentName: String? = nil
    @Published var uploadedDocumentImage: UIImage? = nil
    @Published var isNavigatingToHome: Bool = false
    
    // MARK: - Actions
    
    /// Handles action tap for a step
    func handleStepAction(for step: ProviderStep) {
        if step.stepNumber == 4 {
            // Upload documents step opens the Select Document screen
            isSelectDocumentPresented = true
        } else if step.stepNumber == 6 {
            // Tapping step 6 checks/shows approval status or navigates to home if approved
            checkAccountStatus()
        } else {
            // Toggle completion state for interactive steps (2, 3, 5)
            if let index = steps.firstIndex(where: { $0.id == step.id }) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    steps[index].isCompleted.toggle()
                }
                updateStep6ApprovalStatus()
            }
        }
    }
    
    /// Called when a document is uploaded from SelectDocumentView
    func markDocumentUploaded(fileName: String, image: UIImage? = nil) {
        uploadedDocumentName = fileName
        uploadedDocumentImage = image
        if let index = steps.firstIndex(where: { $0.stepNumber == 4 }) {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                steps[index].isCompleted = true
            }
            updateStep6ApprovalStatus()
        }
    }
    
    /// Automatically updates Step 6 when the first 5 steps are completed
    func updateStep6ApprovalStatus() {
        let firstFiveCompleted = steps
            .filter { $0.stepNumber >= 1 && $0.stepNumber <= 5 }
            .allSatisfy { $0.isCompleted }
        
        if let step6Index = steps.firstIndex(where: { $0.stepNumber == 6 }) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                if firstFiveCompleted {
                    steps[step6Index].isCompleted = true
                    steps[step6Index].title = "Approved"
                    steps[step6Index].description = "Your provided information has been verified and approved."
                    steps[step6Index].buttonTitle = nil
                } else {
                    steps[step6Index].isCompleted = false
                    steps[step6Index].title = "Waiting for admin approval"
                    steps[step6Index].description = "We will check your provided information and get back to you soon."
                    steps[step6Index].buttonTitle = nil
                }
            }
        }
    }
    
    func checkAccountStatus() {
        let firstFiveCompleted = steps
            .filter { $0.stepNumber >= 1 && $0.stepNumber <= 5 }
            .allSatisfy { $0.isCompleted }
        
        if firstFiveCompleted {
            isNavigatingToHome = true
        } else {
            alertTitle = "Account Status"
            let completedCount = steps.filter { $0.stepNumber <= 5 && $0.isCompleted }.count
            alertMessage = "\(completedCount) of 5 steps completed. Please complete all requirements to receive approval and proceed to the Home page."
            showAlert = true
        }
    }
    
    func handleNotificationTapped() {
        alertTitle = "Notifications"
        alertMessage = "Welcome to MyLooQ Pro! Complete your profile to start receiving client bookings."
        showAlert = true
    }
}
