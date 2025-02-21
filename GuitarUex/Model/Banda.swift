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

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case name
        case guitarristaID = "guitarrista_id"
    }
}
