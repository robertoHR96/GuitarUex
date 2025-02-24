//
//  Fabricante.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 24/2/25.
//

// location
//
//  Banda 2.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 24/2/25.
//

import Foundation

struct Fabricante: Codable, Identifiable, Hashable {
    let id: UUID
    let createdAt: Date
    let name: String
    let location: String
    let imagen: ImagenFabricante
    struct ImagenFabricante: Codable, Hashable {
        let access: String
        let path: String
        let name: String
        let type: String
        let size: Int
        let mime: String
        let meta: [String: String]
        let url: String
    }

    enum CodingKeys: String, CodingKey {
        case id, name, imagen, location
        case createdAt = "created_at"
    }
}
