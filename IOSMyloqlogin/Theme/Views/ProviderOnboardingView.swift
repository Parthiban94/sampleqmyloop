//
//  ProviderOnboardingView.swift
//  IOSMyloqlogin
//

import SwiftUI

struct ProviderOnboardingView: View {
    @StateObject private var viewModel = ProviderOnboardingViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. Purple Header Bar ("MyLooQ Pro" + Notification Bell)
            headerBar
            
            // 2. Scrollable Timeline & Steps
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    Spacer()
                        .frame(height: 4)
                    
                    ForEach(Array(viewModel.steps.enumerated()), id: \.element.id) { index, step in
                        ProviderStepCardView(
                            step: step,
                            isFirst: index == 0,
                            isLast: index == viewModel.steps.count - 1,
                            onAction: {
                                viewModel.handleStepAction(for: step)
                            }
                        )
                    }
                    
                    // Outlined "Check Account Status" Button
                    Button(action: {
                        viewModel.checkAccountStatus()
                    }) {
                        Text("Check Account Status")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(hex: "111111"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                Capsule()
                                    .fill(Color.white)
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color(hex: "111111"), lineWidth: 1.5)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                }
            }
            .background(Color.white)
            
            // 3. Dark Bottom Navigation Bar
            ProviderBottomTabBar(selectedTab: $viewModel.selectedTab)
        }
        .fullScreenCover(isPresented: $viewModel.isSelectDocumentPresented) {
            SelectDocumentView(
                initialFileName: viewModel.uploadedDocumentName,
                initialImage: viewModel.uploadedDocumentImage
            ) { fileName, image in
                viewModel.markDocumentUploaded(fileName: fileName, image: image)
            }
        }
        .fullScreenCover(isPresented: $viewModel.isNavigatingToHome) {
            HomeView()
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
    // MARK: - Header Bar
    
    private var headerBar: some View {
        HStack {
            Spacer()
            
            Text("MyLooQ Pro")
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
        }
        .overlay(alignment: .trailing) {
            Button(action: {
                viewModel.handleNotificationTapped()
            }) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    
                    // Red Alert Dot
                    Circle()
                        .fill(Color(hex: "FF3B30"))
                        .frame(width: 8, height: 8)
                        .offset(x: 2, y: -2)
                }
                .padding(.trailing, 20)
            }
            .buttonStyle(.plain)
        }
        .frame(height: 52)
        .background(
            MyLooQTheme.primaryPurple
                .ignoresSafeArea(edges: .top)
        )
    }
}

#Preview {
    ProviderOnboardingView()
}
