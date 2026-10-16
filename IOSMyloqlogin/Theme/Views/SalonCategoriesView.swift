//
//  SalonCategoriesView.swift
//  IOSMyloqlogin
//

import SwiftUI

struct SalonCategoriesView: View {
    @StateObject private var viewModel = SalonCategoriesViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Purple Status Area & Header Bar
                SalonHeaderBar(
                    locationText: viewModel.selectedLocation,
                    onBack: {
                        dismiss()
                    },
                    onLocationTap: {
                        viewModel.presentLocationSheet()
                    }
                )
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        // Section Title "Salon"
                        HStack {
                            Text("Salon")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(MyLooQTheme.darkText)
                            
                            Spacer()
                            
                            if !viewModel.categories.isEmpty {
                                Text("\(viewModel.categories.count) Categories")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(MyLooQTheme.primaryPurple)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(MyLooQTheme.pastelPurpleGlow)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Categories List loaded only from API with default images
                        salonCategoriesList
                        
                        // Bottom spacing so content is never hidden behind the Done button
                        Spacer().frame(height: 100)
                    }
                }
                .refreshable {
                    await viewModel.fetchCategoriesFromAPI()
                }
            }
            
            // Bottom "Done" Button (Prominently displayed when items are selected)
            if viewModel.canProceed {
                bottomDoneButton
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $viewModel.isNextPresented) {
            SalonBookingSummarySheet(
                selectedItems: viewModel.allSelectedItems,
                onDone: {
                    viewModel.printSelectedCategoryNames()
                    viewModel.isNextPresented = false
                },
                onDismiss: {
                    viewModel.isNextPresented = false
                }
            )
        }
        .sheet(isPresented: $viewModel.isLocationSheetPresented) {
            CurrentLocationSheet(
                locationService: viewModel.locationService,
                onUseCurrentLocation: {
                    viewModel.useCurrentLocation()
                },
                onDismiss: {
                    viewModel.isLocationSheetPresented = false
                }
            )
        }
    }
    
    // MARK: - Salon Categories List (API Default Images Only)
    private var salonCategoriesList: some View {
        LazyVStack(spacing: 12) {
            if viewModel.categories.isEmpty && !viewModel.isLoading {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 32))
                        .foregroundColor(.orange)
                    Text("No categories found or API error.")
                        .font(.system(size: 14))
                        .foregroundColor(MyLooQTheme.secondaryText)
                    Button("Retry") {
                        Task { await viewModel.fetchCategoriesFromAPI() }
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(MyLooQTheme.primaryPurple)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ForEach(viewModel.categories) { category in
                    SalonCategoryRow(
                        title: category.name,
                        iconType: .remoteImage,
                        remoteImageUrl: category.image,
                        isSelected: viewModel.isSelected(id: category.id),
                        onToggle: {
                            viewModel.toggleSelection(id: category.id)
                        }
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Bottom Done Button
    private var bottomDoneButton: some View {
        VStack(spacing: 0) {
            Button(action: {
                viewModel.proceedDone()
            }) {
                Text("Done")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        Capsule()
                            .fill(MyLooQTheme.primaryPurple)
                    )
            }
            .buttonStyle(ScaleButtonStyle())
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .padding(.top, 12)
            .background(
                LinearGradient(
                    colors: [Color.white.opacity(0.0), Color.white.opacity(0.95), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}

// MARK: - Booking Summary Sheet

struct SalonBookingSummarySheet: View {
    let selectedItems: [(id: String, name: String)]
    let onDone: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Top Success Icon
                ZStack {
                    Circle()
                        .fill(MyLooQTheme.pastelPurpleGlow)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 40))
                        .foregroundColor(MyLooQTheme.primaryPurple)
                }
                .padding(.top, 16)
                
                VStack(spacing: 6) {
                    Text("Selected Categories")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(MyLooQTheme.darkText)
                    
                    Text("\(selectedItems.count) item\(selectedItems.count > 1 ? "s" : "") selected")
                        .font(.system(size: 14))
                        .foregroundColor(MyLooQTheme.secondaryText)
                }
                
                // Card list displaying each selected item's Name and ID
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(selectedItems, id: \.id) { item in
                            HStack {
                                Text(item.name)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(MyLooQTheme.darkText)
                                
                                Spacer()
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.green)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(UIColor.secondarySystemBackground))
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Done Button
                Button(action: onDone) {
                    Text("Done")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Capsule().fill(MyLooQTheme.primaryPurple))
                }
                .buttonStyle(ScaleButtonStyle())
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .navigationTitle("Selection Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", action: onDismiss)
                        .foregroundColor(MyLooQTheme.primaryPurple)
                }
            }
        }
    }
}

#Preview {
    SalonCategoriesView()
}
