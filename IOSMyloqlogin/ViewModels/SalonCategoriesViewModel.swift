//
//  SalonCategoriesViewModel.swift
//  IOSMyloqlogin
//

import Foundation
import SwiftUI
import Combine

enum CategoryTab: String, CaseIterable, Identifiable {
    case salon = "Salon Services"
    case all = "All Categories (API)"
    
    var id: String { rawValue }
}

@MainActor
final class SalonCategoriesViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// Categories loaded directly from API http://168.144.190.133/api/v1/categories
    @Published var categories: [Category] = Category.defaultCategories
    
    /// Backward-compatibility alias
    var salonServices: [SalonCategoryItem] {
        categories.map {
            SalonCategoryItem(id: $0.id, name: $0.name, iconType: .remoteImage, remoteImageUrl: $0.image)
        }
    }
    
    /// Backward-compatibility alias
    var apiCategories: [Category] {
        categories
    }
    
    /// Selected category IDs
    @Published var selectedCategoryIds: Set<String> = []
    
    /// Current selected address - Showing only current location
    @Published var selectedLocation: String = "Current Location"
    
    /// Location sheet display state
    @Published var isLocationSheetPresented: Bool = false
    
    /// Network loading state
    @Published var isLoading: Bool = false
    
    /// Network error message if any
    @Published var errorMessage: String? = nil
    
    /// Active view tab
    @Published var selectedTab: CategoryTab = .salon
    
    /// Flag for navigating to next step
    @Published var isNextPresented: Bool = false
    
    // MARK: - Dependencies
    
    private let categoryService: CategoryServiceProtocol
    let locationService: LocationService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(categoryService: CategoryServiceProtocol = CategoryService.shared,
         locationService: LocationService = LocationService.shared) {
        self.categoryService = categoryService
        self.locationService = locationService
        self.selectedLocation = locationService.displayLocationTitle
        
        // Bind location updates from LocationService
        locationService.$displayLocationTitle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLocation in
                guard let self = self else { return }
                if !newLocation.isEmpty {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        self.selectedLocation = newLocation
                    }
                }
            }
            .store(in: &cancellables)
        
        // Trigger location detection
        locationService.requestPermissionAndFetchLocation()
        
        // Fetch categories from the user's API endpoint on init
        Task {
            await fetchCategoriesFromAPI()
        }
    }
    
    // MARK: - Computed Properties
    
    /// Returns true if at least one category is selected
    var canProceed: Bool {
        !selectedCategoryIds.isEmpty
    }
    
    /// Formatted count of selected items
    var selectedCountText: String {
        "\(selectedCategoryIds.count) selected"
    }
    
    /// Check if a specific category ID is selected
    func isSelected(id: String) -> Bool {
        selectedCategoryIds.contains(id)
    }
    
    // MARK: - Actions
    
    /// Toggle selection state of a category
    func toggleSelection(id: String) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if selectedCategoryIds.contains(id) {
                selectedCategoryIds.remove(id)
            } else {
                selectedCategoryIds.insert(id)
            }
        }
    }
    
    /// Fetch categories from the given API endpoint
    func fetchCategoriesFromAPI() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetched = try await categoryService.fetchCategories()
            if !fetched.isEmpty {
                self.categories = fetched
            }
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            print("API Fetch error: \(error)")
        }
    }
    
    // MARK: - Selected Categories Computed Properties
    
    /// Categories from API http://168.144.190.133/api/v1/categories that are selected
    var selectedCategories: [Category] {
        categories.filter { selectedCategoryIds.contains($0.id) }
    }
    
    var selectedAPICategories: [Category] {
        selectedCategories
    }
    
    var selectedSalonServices: [SalonCategoryItem] {
        salonServices.filter { selectedCategoryIds.contains($0.id) }
    }
    
    /// All selected items as (id, name) tuples
    var allSelectedItems: [(id: String, name: String)] {
        selectedCategories.map { (id: $0.id, name: $0.name) }
    }
    
    /// Print only name of selected categories (no id)
    func printSelectedCategoryNames() {
        for category in selectedCategories {
            print(category.name)
        }
    }
    
    /// Backward-compatible alias that prints only name
    func printSelectedCategoryIdsAndNames() {
        printSelectedCategoryNames()
    }
    
    /// Action called after selecting is done
    func proceedDone() {
        guard canProceed else { return }
        printSelectedCategoryNames()
        isNextPresented = true
    }
    
    /// Proceed to next screen (calls proceedDone)
    func proceedNext() {
        proceedDone()
    }
    
    /// Present current location details sheet
    func presentLocationSheet() {
        isLocationSheetPresented = true
    }
    
    /// Trigger refresh of device's current location
    func refreshLocation() {
        locationService.fetchLocation()
    }
    
    /// Trigger detection and apply current location to top bar
    func useCurrentLocation() {
        if !locationService.displayLocationTitle.isEmpty && locationService.displayLocationTitle != "Current Location" {
            self.selectedLocation = locationService.displayLocationTitle
        } else {
            self.selectedLocation = "Detecting Location..."
        }
        locationService.requestPermissionAndFetchLocation()
    }
}
