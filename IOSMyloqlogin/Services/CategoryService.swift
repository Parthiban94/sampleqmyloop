//
//  CategoryService.swift
//  IOSMyloqlogin
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The API endpoint URL is invalid."
        case .invalidResponse:
            return "Invalid server response."
        case .httpError(let statusCode):
            return "Server returned HTTP status \(statusCode)."
        case .decodingError(let error):
            return "Failed to decode category data: \(error.localizedDescription)"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

protocol CategoryServiceProtocol {
    func fetchCategories() async throws -> [Category]
}

final class CategoryService: CategoryServiceProtocol {
    static let shared = CategoryService()
    
    /// The API endpoint specified by the user
    private let endpointURLString = "http://168.144.190.133/api/v1/categories"
    
    func fetchCategories() async throws -> [Category] {
        guard let url = URL(string: endpointURLString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 15
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.unknown(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoded = try JSONDecoder().decode(CategoryResponse.self, from: data)
            return decoded.data
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
