//
//  Guitarrista.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 25/2/25.
//

import Foundation

struct Guitarrista: Codable, Identifiable, Hashable{
    let id: UUID
    let createdAt: Date
    let nombre: String
    let guitarraId: [UUID]
    let bandasId: [UUID]
    
    enum CodingKeys: String, CodingKey {
        case id, nombre
        case createdAt = "created_at"
        case bandasId = "bandas_id"
        case guitarraId = "guitarra_id"
    }
}
