//
//  CurrentLocationSheet.swift
//  IOSMyloqlogin
//

import SwiftUI
import CoreLocation

struct CurrentLocationSheet: View {
    @ObservedObject var locationService: LocationService
    var onUseCurrentLocation: (() -> Void)? = nil
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Top Visual Indicator
                ZStack {
                    Circle()
                        .fill(MyLooQTheme.pastelPurpleGlow)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(MyLooQTheme.primaryPurple)
                }
                .padding(.top, 16)
                
                VStack(spacing: 6) {
                    Text("Current Location")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(MyLooQTheme.darkText)
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(locationService.currentLocation != nil ? Color.green : Color.orange)
                            .frame(width: 8, height: 8)
                        
                        Text(locationService.currentLocation != nil ? "GPS Location Active" : (locationService.isLocating ? "Detecting GPS..." : "Ready to Detect GPS"))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(MyLooQTheme.secondaryText)
                    }
                }
                
                // Location Details Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 20))
                            .foregroundColor(MyLooQTheme.primaryPurple)
                            .padding(.top, 2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Selected Location")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(MyLooQTheme.secondaryText)
                                .textCase(.uppercase)
                            
                            Text(locationService.displayLocationTitle)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(MyLooQTheme.darkText)
                            
                            Text(locationService.detailedAddress)
                                .font(.system(size: 13))
                                .foregroundColor(MyLooQTheme.secondaryText)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 2)
                            
                            if let loc = locationService.currentLocation {
                                Text(String(format: "GPS: %.4f° N, %.4f° E", loc.coordinate.latitude, loc.coordinate.longitude))
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundColor(MyLooQTheme.secondaryText.opacity(0.8))
                                    .padding(.top, 2)
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.secondarySystemBackground))
                )
                .padding(.horizontal, 20)
                
                // Refresh Location Button
                Button(action: {
                    locationService.fetchLocation()
                }) {
                    HStack(spacing: 8) {
                        if locationService.isLocating {
                            ProgressView()
                                .tint(MyLooQTheme.primaryPurple)
                        } else {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        
                        Text(locationService.isLocating ? "Locating..." : "Refresh Current Location")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(MyLooQTheme.primaryPurple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(MyLooQTheme.primaryPurple.opacity(0.3), lineWidth: 1.5)
                    )
                }
                .disabled(locationService.isLocating)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Use Current Location Button (Triggers GPS detection & applies location)
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    locationService.requestPermissionAndFetchLocation()
                    onUseCurrentLocation?()
                    onDismiss()
                }) {
                    HStack(spacing: 8) {
                        if locationService.isLocating {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "location.fill")
                                .font(.system(size: 15, weight: .bold))
                        }
                        
                        Text("Use Current Location")
                            .font(.system(size: 16, weight: .bold))
                    }
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
                .padding(.bottom, 24)
            }
            .navigationTitle("Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done", action: onDismiss)
                        .foregroundColor(MyLooQTheme.primaryPurple)
                }
            }
            .onAppear {
                if locationService.currentLocation == nil {
                    locationService.requestPermissionAndFetchLocation()
                }
            }
        }
    }
}

#Preview {
    CurrentLocationSheet(
        locationService: LocationService.shared,
        onDismiss: {}
    )
}
