//
//  ShopHomeResponse.swift
//  IOSMyloqlogin
//

import Foundation

// MARK: - Root Response
struct ShopHomeResponse: Codable {
    let status: Bool?
    let statusCode: Int?
    let errorCode: String?
    let message: String?
    let data: ShopHomeData?
    
    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case errorCode = "error_code"
        case message
        case data
    }
}

// MARK: - Data Container
struct ShopHomeData: Codable {
    let search: ShopSearchInfo?
    let categories: [ShopCategory]?
    let banners: [ShopBanner]?
}

// MARK: - Search Info
struct ShopSearchInfo: Codable {
    let placeholder: String?
}

// MARK: - Category
struct ShopCategory: Codable, Identifiable {
    let id: String
    let name: String
    let image: String?
    let parentId: String?
    let hasChildren: Bool?
    let discount: ShopDiscount?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case parentId = "parent_id"
        case hasChildren = "has_children"
        case discount
    }
}

// MARK: - Discount
struct ShopDiscount: Codable {
    let text: String?
    let percentage: Double?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try? container.decode(String.self, forKey: .text)
        if let doubleVal = try? container.decode(Double.self, forKey: .percentage) {
            percentage = doubleVal
        } else if let intVal = try? container.decode(Int.self, forKey: .percentage) {
            percentage = Double(intVal)
        } else {
            percentage = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case text
        case percentage
    }
}

// MARK: - Banner
struct ShopBanner: Codable, Identifiable {
    var id: String { UUID().uuidString }
    let image: String?
    let title: String?
    let link: String?
}
