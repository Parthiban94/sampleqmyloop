//
//  ShopAPIService.swift
//  IOSMyloqlogin
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse(Int)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The API endpoint URL is invalid."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse(let statusCode):
            return "Server responded with status code: \(statusCode)"
        case .decodingError(let error):
            return "Failed to parse server response: \(error.localizedDescription)"
        }
    }
}

final class ShopAPIService {
    static let shared = ShopAPIService()
    
    private let endpointURL = "http://168.144.190.133/api/shop/home"
    
    private init() {}
    
    /// Fetches shop home data including search placeholder, categories, and banners
    func fetchShopHome() async throws -> ShopHomeData {
        guard let url = URL(string: endpointURL) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 15.0
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse(-1)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse(httpResponse.statusCode)
        }
        
        do {
            let decoded = try JSONDecoder().decode(ShopHomeResponse.self, from: data)
            if let shopData = decoded.data {
                return shopData
            } else {
                throw APIError.decodingError(
                    NSError(domain: "ShopAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: decoded.message ?? "No data returned"])
                )
            }
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
