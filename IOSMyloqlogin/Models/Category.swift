//
//  Category.swift
//  IOSMyloqlogin
//

import Foundation

// MARK: - API Response

struct CategoryResponse: Codable {
    let success: Bool
    let message: String
    let data: [Category]
}

// MARK: - Category Model (from API)

struct Category: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let image: String?
    let parentId: String?
    let hasChildren: Bool?
    let discount: CategoryDiscount?
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, discount
        case parentId = "parent_id"
        case hasChildren = "has_children"
    }
}

struct CategoryDiscount: Codable, Hashable {
    let text: String?
    let percentage: Double?
}

// MARK: - Default API Categories

extension Category {
    /// Default categories directly matching the API response from http://168.144.190.133/api/v1/categories
    static let defaultCategories: [Category] = [
        Category(id: "SCAT1001", name: "Hair", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/hair.png", parentId: nil, hasChildren: true, discount: nil)
//        Category(id: "SCAT1026", name: "Face & Skincare", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/face-skincare.jpg", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1047", name: "Makeup", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/makeup.png", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1068", name: "Nails", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/nails.png", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1087", name: "Body Care", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/body-care.jpg", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1104", name: "Fragrance", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/fragrance.jpg", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1113", name: "Men's Grooming", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/mens-grooming.jpg", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1126", name: "Beauty Tools & Accessories", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/beauty-tools-accessories.jpg", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1141", name: "Wigs & Hair Extensions", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/wigs-hair-extensions.png", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1158", name: "Barber Products", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/barber-products.png", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1171", name: "Spa & Wellness", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/spa-wellness.png", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1184", name: "Fashion & Accessories", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/fashion-accessories.jpg", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1216", name: "Professional Beauty Supplies", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/professional-beauty-supplies.jpg", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1227", name: "Natural & Organic Products", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/natural-organic-products.jpg", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1238", name: "Beauty Devices", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/beauty-devices.jpg", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1248", name: "Supplements", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/supplements.png", parentId: nil, hasChildren: true, discount: nil),
//        Category(id: "SCAT1257", name: "Gift Sets", image: "https://mylooq-assets.sfo3.cdn.digitaloceanspaces.com/shop/categories/gift-sets.jpg", parentId: nil, hasChildren: true, discount: nil)
    ]
}

// MARK: - Salon Service Item (Backward Compatibility)

enum SalonIconType: String, Codable {
    case remoteImage
    case bridalFacial
    case classicFacial
    case mask
    case premiumFacial
    case waxing
    case threading
}

struct SalonCategoryItem: Identifiable, Hashable {
    let id: String
    let name: String
    let iconType: SalonIconType
    let remoteImageUrl: String?
    
    init(id: String, name: String, iconType: SalonIconType = .remoteImage, remoteImageUrl: String? = nil) {
        self.id = id
        self.name = name
        self.iconType = iconType
        self.remoteImageUrl = remoteImageUrl
    }
    
    /// Default categories backed by live API default images
    static var defaultSalonServices: [SalonCategoryItem] {
        Category.defaultCategories.map {
            SalonCategoryItem(id: $0.id, name: $0.name, iconType: .remoteImage, remoteImageUrl: $0.image)
        }
    }
}
