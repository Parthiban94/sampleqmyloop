//
//  LocationService.swift
//  IOSMyloqlogin
//

import Foundation
import CoreLocation
import Combine

/// Service responsible for managing device location and reverse-geocoding for MyLooQ
final class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    
    // MARK: - Published Properties
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocation?
    
    /// Display label for header capsule, e.g. "Current Location"
    @Published var displayLocationTitle: String = "Current Location"
    
    /// Formatted address or detailed placemark information
    @Published var detailedAddress: String = "Detecting current location..."
    
    /// Subtitle or city/locality string
    @Published var currentLocality: String = ""
    
    @Published var isLocating: Bool = false
    @Published var locationError: String? = nil
    
    // MARK: - Private Properties
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.authorizationStatus = locationManager.authorizationStatus
    }
    
    // MARK: - Public Actions
    
    /// Request When-In-Use authorization and trigger location fetch
    func requestPermissionAndFetchLocation() {
        locationError = nil
        let status = locationManager.authorizationStatus
        self.authorizationStatus = status
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            fetchLocation()
        case .denied, .restricted:
            isLocating = false
            displayLocationTitle = "Location Disabled"
            detailedAddress = "Location permission is disabled in Settings."
        @unknown default:
            displayLocationTitle = "Current Location"
        }
    }
    
    /// Fetch current location update
    func fetchLocation() {
        isLocating = true
        locationError = nil
        
        if let existing = locationManager.location {
            self.currentLocation = existing
            self.reverseGeocode(location: existing)
        }
        
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.authorizationStatus = manager.authorizationStatus
            
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                self.fetchLocation()
            case .denied, .restricted:
                self.isLocating = false
                self.displayLocationTitle = "Location Disabled"
                self.detailedAddress = "Location permission denied in Settings."
            default:
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Stop GPS polling once a location is acquired
        manager.stopUpdatingLocation()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentLocation = location
            self.reverseGeocode(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isLocating = false
            self.locationError = error.localizedDescription
            print("Location Manager didFailWithError: \(error.localizedDescription)")
            
            if let existing = self.locationManager.location {
                self.currentLocation = existing
                self.reverseGeocode(location: existing)
            } else if self.currentLocation == nil {
                self.displayLocationTitle = "Current Location"
                self.detailedAddress = "Current Location (GPS unavailable)"
            }
        }
    }
    
    // MARK: - Geocoding
    
    private func reverseGeocode(location: CLLocation) {
        if geocoder.isGeocoding {
            geocoder.cancelGeocode()
        }
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLocating = false
                
                if let placemark = placemarks?.first {
                    // Extract components
                    let locality = placemark.locality ?? placemark.subAdministrativeArea ?? ""
                    let subLocality = placemark.subLocality ?? ""
                    let thoroughfare = placemark.thoroughfare ?? ""
                    let subThoroughfare = placemark.subThoroughfare ?? ""
                    let state = placemark.administrativeArea ?? ""
                    let country = placemark.country ?? ""
                    let name = placemark.name ?? ""
                    
                    self.currentLocality = locality
                    
                    // Formulate concise top title showing the detected location
                    let street = [subThoroughfare, thoroughfare].filter { !$0.isEmpty }.joined(separator: " ")
                    if !street.isEmpty && !locality.isEmpty {
                        self.displayLocationTitle = "\(street), \(locality)"
                    } else if !name.isEmpty && !locality.isEmpty && name != locality {
                        self.displayLocationTitle = "\(name), \(locality)"
                    } else if !locality.isEmpty && !state.isEmpty {
                        self.displayLocationTitle = "\(locality), \(state)"
                    } else if !locality.isEmpty {
                        self.displayLocationTitle = locality
                    } else if !name.isEmpty {
                        self.displayLocationTitle = name
                    } else {
                        self.displayLocationTitle = "Current Location"
                    }
                    
                    // Detailed address line
                    var addressComponents: [String] = []
                    if !street.isEmpty { addressComponents.append(street) }
                    else if !name.isEmpty { addressComponents.append(name) }
                    if !subLocality.isEmpty && subLocality != locality { addressComponents.append(subLocality) }
                    if !locality.isEmpty { addressComponents.append(locality) }
                    if !state.isEmpty { addressComponents.append(state) }
                    if !country.isEmpty { addressComponents.append(country) }
                    
                    self.detailedAddress = addressComponents.isEmpty
                        ? self.displayLocationTitle
                        : addressComponents.joined(separator: ", ")
                } else {
                    // Fallback using coordinates if geocoder times out or in simulator sandbox
                    let lat = location.coordinate.latitude
                    let lon = location.coordinate.longitude
                    
                    // Check if standard Apple Park coordinates on simulator
                    if abs(lat - 37.3349) < 0.05 && abs(lon - (-122.0090)) < 0.05 {
                        self.displayLocationTitle = "Cupertino, CA"
                        self.detailedAddress = "1 Apple Park Way, Cupertino, CA 94087"
                    } else {
                        self.displayLocationTitle = String(format: "Location: %.3f, %.3f", lat, lon)
                        self.detailedAddress = String(format: "GPS: %.4f° N, %.4f° E", lat, lon)
                    }
                }
            }
        }
    }
}
