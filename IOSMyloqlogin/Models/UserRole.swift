//
//  UserRole.swift
//  IOSMyloqlogin
//

import Foundation

enum UserRole: String, CaseIterable, Identifiable {
    case user = "User"
    case provider = "Provider"
    
    var id: String { rawValue }
}
