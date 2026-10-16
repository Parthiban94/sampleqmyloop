//
//  CountryPickerSheet.swift
//  IOSMyloqlogin
//

import SwiftUI

struct CountryPickerSheet: View {
    @Binding var selectedCountry: Country
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText: String = ""
    
    var filteredCountries: [Country] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return Country.allCountries
        } else {
            let query = searchText.lowercased()
            return Country.allCountries.filter {
                $0.name.lowercased().contains(query) ||
                $0.dialCode.contains(query) ||
                $0.code.lowercased().contains(query)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredCountries) { country in
                    Button(action: {
                        selectedCountry = country
                        dismiss()
                    }) {
                        HStack(spacing: 14) {
                            CountryFlagView(country: country, size: 28)
                            
                            Text(country.name)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(MyLooQTheme.darkText)
                            
                            Spacer()
                            
                            Text(country.dialCode)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(MyLooQTheme.secondaryText)
                            
                            if country.id == selectedCountry.id {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(MyLooQTheme.primaryPurple)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchText, prompt: "Search country or code")
            .navigationTitle("Select Country")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(MyLooQTheme.primaryPurple)
                }
            }
        }
    }
}

#Preview {
    CountryPickerSheet(selectedCountry: .constant(.netherlands))
}
