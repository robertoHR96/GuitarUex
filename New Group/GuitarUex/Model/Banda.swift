//
//  Banda.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//


import Foundation
struct Banda: Codable, Identifiable, Hashable {
    let id: UUID
    let createdAt: Date
    let name: String
    let guitarristaID: [UUID]
    let imagen: ImagenBanda
    struct ImagenBanda: Codable, Hashable {
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
        case id, name, imagen
        case createdAt = "created_at"
        case guitarristaID = "guitarrista_id"
    }
}
