//
//  User.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 24/2/25.
//

import Foundation
struct User: Codable, Identifiable, Hashable {
    let id: UUID
    let createdAt: Date
    let email: String
    let name: String
    let isAdmin: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, email, name, isAdmin
        case createdAt = "created_at"
    }
    init(id: UUID = UUID(), createdAt: Date = Date(), email: String = "", name: String = "", isAdmin: Bool = false) {
            self.id = id
            self.createdAt = createdAt
            self.email = email
            self.name = name
            self.isAdmin = isAdmin
        }
}
