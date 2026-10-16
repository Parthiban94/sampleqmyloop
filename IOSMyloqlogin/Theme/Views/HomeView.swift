//
//  HomeView.swift
//  IOSMyloqlogin
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.dismiss) private var dismiss
    
    // Palette for rotating pastel card backgrounds matching design screenshot
    private let pastelPalette = [
        "FDECEF", // Soft Pink (LooQer tone)
        "FFF5EA", // Peach Cream (Hair tone)
        "FCEEF6", // Rose Blush (Salon tone)
        "F2F0FF", // Lavender (Makeup tone)
        "E8F7F4", // Mint Green (Spa tone)
        "FAF0F7", // Soft Lilac (Hair & care tone)
        "FDEEEF", // Warm Coral (Massage tone)
        "EEF6FF", // Soft Sky Blue
        "FFF8E7", // Soft Butter
        "F3E8FF"  // Pale Purple
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Purple Header Bar (Avatar + Hello William + Bell + Location)
                headerSection
                
                // 2. Scrollable Body Content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        // Section Header
                        Text("How can we assist you today")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "1A1A1A"))
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                        
                        // Search Bar
                        searchBar
                            .padding(.horizontal, 20)
                        
                        // Live API Categories Grid
                        liveCategoriesGridSection
                        
                        // Bottom spacing for tab bar
                        Spacer()
                            .frame(height: 90)
                    }
                }
                .refreshable {
                    await viewModel.loadShopHomeData()
                }
            }
            
            // 3. Black Bottom Navigation Bar
            bottomDockTabBar
        }
        .ignoresSafeArea(edges: .bottom)
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
        .confirmationDialog("Profile", isPresented: $viewModel.isProfileDialogPresented, titleVisibility: .visible) {
            Button("Return to Onboarding", role: .none) {
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Logged in as William\nAddress: \(viewModel.address)")
        }
        .sheet(isPresented: $viewModel.isShowingAddressSheet) {
            CurrentLocationSheet(
                locationService: viewModel.locationService,
                onUseCurrentLocation: {
                    viewModel.refreshLocation()
                },
                onDismiss: {
                    viewModel.isShowingAddressSheet = false
                }
            )
        }
        .onAppear {
            viewModel.refreshLocation()
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 0) {
            // Top Row: Avatar, Greeting, Bell
            HStack(spacing: 12) {
                // User Avatar
                Image("avatar_william")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.8), lineWidth: 1.5))
                
                // Greeting
                HStack(spacing: 6) {
                    Text("Hello,")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(viewModel.userName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Notification Bell
                Button(action: {
                    viewModel.handleNotificationsTap()
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                        
                        if viewModel.hasUnreadNotifications {
                            Circle()
                                .fill(Color(hex: "FF3B30"))
                                .frame(width: 9, height: 9)
                                .offset(x: 2, y: -2)
                        }
                    }
                    .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 12)
            
            // Sub-Row: Location Address Bar
            Button(action: {
                viewModel.isShowingAddressSheet = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                    
                    if viewModel.isLocating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.65)
                    }
                    
                    Text(viewModel.address)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .frame(height: 38)
                .background(Color.black.opacity(0.16))
            }
            .buttonStyle(.plain)
        }
        .background(
            Color(hex: "6B238E")
                .ignoresSafeArea(edges: .top)
        )
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18))
                .foregroundColor(Color(hex: "8E8E93"))
            
            TextField(viewModel.searchPlaceholder, text: $viewModel.searchText)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "1C1C1E"))
            
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "8E8E93"))
                }
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "E5E7EB"), lineWidth: 1.2)
        )
    }
    
    // MARK: - Live API Categories Grid Section
    
    private var liveCategoriesGridSection: some View {
        Group {
            if viewModel.isLoading && viewModel.apiCategories.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.1)
                            .tint(Color(hex: "6B238E"))
                        Text("Loading categories...")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color.gray)
                    }
                    .padding(.vertical, 40)
                    Spacer()
                }
            } else if let error = viewModel.errorMessage, viewModel.apiCategories.isEmpty {
                VStack(spacing: 10) {
                    Text("Could not load categories")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.red)
                    
                    Text(error)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Button("Retry") {
                        Task {
                            await viewModel.loadShopHomeData()
                        }
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "6B238E"))
                    .padding(.top, 4)
                }
                .padding()
                .frame(maxWidth: .infinity)
            } else if viewModel.filteredApiCategories.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 32))
                        .foregroundColor(Color.gray.opacity(0.4))
                        .padding(.top, 30)
                    
                    Text("No categories found")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: "1A1A1A"))
                    
                    Text("Try searching with different keywords")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            } else {
                let rows = buildCategoryRows(from: viewModel.filteredApiCategories)
                
                LazyVStack(spacing: 12) {
                    ForEach(rows) { row in
                        switch row {
                        case .pair(let first, let second):
                            HStack(spacing: 12) {
                                ShopCategoryCardView(
                                    category: first.1,
                                    pastelHex: pastelPalette[first.0 % pastelPalette.count],
                                    isFullWidth: false,
                                    onSelect: {
                                        viewModel.selectCard(title: first.1.name)
                                    }
                                )
                                .frame(maxWidth: .infinity)
                                
                                ShopCategoryCardView(
                                    category: second.1,
                                    pastelHex: pastelPalette[second.0 % pastelPalette.count],
                                    isFullWidth: false,
                                    onSelect: {
                                        viewModel.selectCard(title: second.1.name)
                                    }
                                )
                                .frame(maxWidth: .infinity)
                            }
                            
                        case .single(let item, let isFullWidth):
                            if isFullWidth {
                                ShopCategoryCardView(
                                    category: item.1,
                                    pastelHex: pastelPalette[item.0 % pastelPalette.count],
                                    isFullWidth: true,
                                    onSelect: {
                                        viewModel.selectCard(title: item.1.name)
                                    }
                                )
                                .frame(maxWidth: .infinity)
                            } else {
                                HStack(spacing: 12) {
                                    ShopCategoryCardView(
                                        category: item.1,
                                        pastelHex: pastelPalette[item.0 % pastelPalette.count],
                                        isFullWidth: false,
                                        onSelect: {
                                            viewModel.selectCard(title: item.1.name)
                                        }
                                    )
                                    .frame(maxWidth: .infinity)
                                    
                                    Color.clear
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Category Row Helpers (6 two-column cards + 1 full-width card pattern)
    
    private enum CategoryRowItem: Identifiable {
        case pair(first: (Int, ShopCategory), second: (Int, ShopCategory))
        case single(item: (Int, ShopCategory), isFullWidth: Bool)
        
        var id: String {
            switch self {
            case .pair(let first, let second):
                return "\(first.1.id)_\(second.1.id)"
            case .single(let item, _):
                return item.1.id
            }
        }
    }
    
    private func buildCategoryRows(from categories: [ShopCategory]) -> [CategoryRowItem] {
        var rows: [CategoryRowItem] = []
        var i = 0
        let count = categories.count
        
        // Full width positions: index 6 (7th item), index 13 (14th item), index 16 (17th item)
        // Grouping: 6 items in 2 columns (indices 0..5)
        // -> 1 full width item (index 6)
        // -> 6 items in 2 columns (indices 7..12)
        // -> 1 full width item (index 13)
        // -> 2 items in 2 columns (indices 14..15)
        // -> 1 full width item (index 16)
        let fullWidthIndices: Set<Int> = [6, 13, 16]
        
        while i < count {
            if fullWidthIndices.contains(i) {
                rows.append(.single(item: (i, categories[i]), isFullWidth: true))
                i += 1
            } else if i + 1 < count && !fullWidthIndices.contains(i + 1) {
                rows.append(.pair(first: (i, categories[i]), second: (i + 1, categories[i + 1])))
                i += 2
            } else {
                rows.append(.single(item: (i, categories[i]), isFullWidth: false))
                i += 1
            }
        }
        return rows
    }
    
    // MARK: - Bottom Dock Tab Bar (Matching Screenshot)
    
    private var bottomDockTabBar: some View {
        HStack {
            // 1. Home Active Pill
            HStack(spacing: 8) {
                Image(systemName: "house")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                
                Text("Home")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color(hex: "2C2C2E"))
            )
            
            Spacer()
            
            // 2. Orders Tab
            Button(action: {
                viewModel.alertTitle = "Orders"
                viewModel.alertMessage = "You have no current active orders."
                viewModel.showAlert = true
            }) {
                Image(systemName: "list.clipboard")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "999999"))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // 3. Wallet Tab
            Button(action: {
                viewModel.alertTitle = "Wallet"
                viewModel.alertMessage = "Wallet balance: $0.00"
                viewModel.showAlert = true
            }) {
                Image(systemName: "creditcard")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "999999"))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // 4. Profile Tab
            Button(action: {
                viewModel.isProfileDialogPresented = true
            }) {
                Image(systemName: "person")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "999999"))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .padding(.bottom, 24)
        .background(
            Color.black
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

#Preview {
    HomeView()
}
