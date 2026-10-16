//
//  TermsAndPrivacyViews.swift
//  IOSMyloqlogin
//

import SwiftUI

struct TermsAndConditionsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Terms & Conditions")
                        .font(.title2.bold())
                        .foregroundColor(MyLooQTheme.darkText)
                    
                    Text("Last updated: October 2026")
                        .font(.footnote)
                        .foregroundColor(MyLooQTheme.secondaryText)
                    
                    Text("""
                    Welcome to MyLooQ. By accessing or using our application, you agree to be bound by these Terms and Conditions.
                    
                    1. Account Registration:
                    You must register using a valid mobile number. You agree to provide accurate and complete information and keep it updated.
                    
                    2. Security & Verification:
                    You are responsible for maintaining the confidentiality of verification codes sent to your registered device.
                    
                    3. Service Usage:
                    MyLooQ connects you with premium beauty and wellness service providers. All bookings are subject to availability and provider confirmation.
                    
                    4. Privacy:
                    Your personal information is governed by our Privacy Policy.
                    """)
                    .font(.body)
                    .foregroundColor(MyLooQTheme.darkText)
                    .lineSpacing(6)
                }
                .padding()
            }
            .navigationTitle("Terms & Conditions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(MyLooQTheme.primaryPurple)
                }
            }
        }
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Privacy Policy")
                        .font(.title2.bold())
                        .foregroundColor(MyLooQTheme.darkText)
                    
                    Text("Last updated: October 2026")
                        .font(.footnote)
                        .foregroundColor(MyLooQTheme.secondaryText)
                    
                    Text("""
                    At MyLooQ, your privacy and data security are our top priorities.
                    
                    1. Information We Collect:
                    We collect your mobile phone number for authentication and service communication.
                    
                    2. How We Use Information:
                    We use your details to verify your identity, send booking updates, and provide customer support.
                    
                    3. Data Protection:
                    We implement modern industry-standard encryption and security measures to protect your personal data.
                    
                    4. Contact Us:
                    If you have questions about our privacy practices, contact us at support@mylooq.com.
                    """)
                    .font(.body)
                    .foregroundColor(MyLooQTheme.darkText)
                    .lineSpacing(6)
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(MyLooQTheme.primaryPurple)
                }
            }
        }
    }
}
