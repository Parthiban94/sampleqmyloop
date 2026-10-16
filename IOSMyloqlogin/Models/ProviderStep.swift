//
//  ProviderStep.swift
//  IOSMyloqlogin
//

import Foundation

struct ProviderStep: Identifiable, Equatable {
    let id: Int
    let stepNumber: Int
    var title: String
    var description: String?
    var buttonTitle: String?
    var isCompleted: Bool
    
    static let defaultSteps: [ProviderStep] = [
        ProviderStep(
            id: 1,
            stepNumber: 1,
            title: "Registration successful",
            description: nil,
            buttonTitle: nil,
            isCompleted: true
        ),
        ProviderStep(
            id: 2,
            stepNumber: 2,
            title: "Add your services",
            description: "Please select your services as per your expertise and industries",
            buttonTitle: "Select services",
            isCompleted: false
        ),
        ProviderStep(
            id: 3,
            stepNumber: 3,
            title: "Work location",
            description: "Add your work location. you can manage or update it at anytime if needed",
            buttonTitle: "Add work location",
            isCompleted: false
        ),
        ProviderStep(
            id: 4,
            stepNumber: 4,
            title: "Upload your document",
            description: "We need to verify your documents to activate your account",
            buttonTitle: "Upload documents",
            isCompleted: false
        ),
        ProviderStep(
            id: 5,
            stepNumber: 5,
            title: "Add your Availability",
            description: "Add your availability for scheduled booking requests only for other services.",
            buttonTitle: "Set availability",
            isCompleted: false
        ),
        ProviderStep(
            id: 6,
            stepNumber: 6,
            title: "Waiting for admin approval",
            description: "We will check your provided information and get back to you soon.",
            buttonTitle: nil,
            isCompleted: false
        )
    ]
}
