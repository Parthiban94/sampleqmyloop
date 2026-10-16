//
//  HomeViewModel.swift
//  IOSMyloqlogin
//

import Foundation
import SwiftUI
import Combine

enum HomeCategorySection: String, CaseIterable, Identifiable {
    case services = "Services"
    case shop = "Shop Products"
    
    var id: String { rawValue }
}

struct CuratedServiceCard: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let isFullWidth: Bool
    let backgroundColorHex: String
}

@MainActor
final class HomeViewModel: ObservableObject {
    // User Profile & Header Info
    @Published var userName: String = "William"
    @Published var userAvatarName: String = "avatar_william"
    @Published var address: String = "Detecting current location..."
    @Published var hasUnreadNotifications: Bool = true
    @Published var isLocating: Bool = false
    
    // Services & Dependencies
    let locationService = LocationService.shared
    private var cancellables = Set<AnyCancellable>()
    
    // Search
    @Published var searchText: String = ""
    @Published var searchPlaceholder: String = "Search"
    
    // Live API Data
    @Published var apiCategories: [ShopCategory] = []
    @Published var apiBanners: [ShopBanner] = []
    
    // State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedCategoryName: String? = nil
    
    // Alerts / Sheets
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var isShowingAddressSheet: Bool = false
    @Published var isProfileDialogPresented: Bool = false
    
    // Navigation / Tab Bar
    @Published var activeTab: ProviderTab = .home
    
    private let apiService = ShopAPIService.shared
    
    // Filtered API Categories based on search
    var filteredApiCategories: [ShopCategory] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return apiCategories
        }
        return apiCategories.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    init() {
        setupLocationTracking()
        Task {
            await loadShopHomeData()
        }
    }
    
    private func setupLocationTracking() {
        // Initial value if available
        if !locationService.detailedAddress.isEmpty && locationService.detailedAddress != "Detecting current location..." {
            self.address = locationService.detailedAddress
        }
        
        // Listen to detailed address updates
        locationService.$detailedAddress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newAddress in
                guard let self = self else { return }
                if !newAddress.isEmpty && newAddress != "Detecting current location..." {
                    self.address = newAddress
                }
            }
            .store(in: &cancellables)
            
        // Listen to concise display title as fallback
        locationService.$displayLocationTitle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newTitle in
                guard let self = self else { return }
                if self.address == "Detecting current location..." && !newTitle.isEmpty && newTitle != "Current Location" {
                    self.address = newTitle
                }
            }
            .store(in: &cancellables)
            
        // Observe locating status
        locationService.$isLocating
            .receive(on: DispatchQueue.main)
            .sink { [weak self] locating in
                self?.isLocating = locating
            }
            .store(in: &cancellables)
            
        // Trigger GPS location detection
        locationService.requestPermissionAndFetchLocation()
    }
    
    func refreshLocation() {
        locationService.fetchLocation()
    }
    
    /// Loads live shop home data from http://168.144.190.133/api/shop/home
    func loadShopHomeData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let data = try await apiService.fetchShopHome()
            if let placeholder = data.search?.placeholder, !placeholder.isEmpty {
                self.searchPlaceholder = placeholder
            }
            if let cats = data.categories {
                self.apiCategories = cats
            }
            if let banners = data.banners {
                self.apiBanners = banners
            }
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            print("Shop API Error: \(error.localizedDescription)")
        }
    }
    
    func selectCard(title: String) {
        selectedCategoryName = title
        alertTitle = title
        alertMessage = "You selected \(title). Booking and service details will be displayed here."
        showAlert = true
    }
    
    func handleNotificationsTap() {
        hasUnreadNotifications = false
        alertTitle = "Notifications"
        alertMessage = "Welcome William! You have 1 new message regarding your appointment confirmation."
        showAlert = true
    }
}
