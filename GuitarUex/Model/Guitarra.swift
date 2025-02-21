//  Guitarra.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//

import Foundation

struct Guitarra: Codable, Identifiable, Hashable {
    let id: UUID
    let createdAt: Date
    let modelo: String
    let colores: [String]
    let descripcion: String
    let fabricanteId: UUID
    let guitarristaId: [UUID]
    let imagen: Imagen
    
    struct Imagen: Codable, Hashable {
        let access: String
        let path: String
        let name: String
        let type: String
        let size: Int
        let mime: String
        let meta: [String: String]
        let url: String
    }
    
    // Decodificación personalizada para manejar "created_at" como timestamp (Int)
    enum CodingKeys: String, CodingKey {
        case id, modelo, colores, descripcion, imagen
        case createdAt = "created_at"
        case fabricanteId = "fabricante_id"
        case guitarristaId = "guitarrista_id"
    }
    
    /*
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        modelo = try container.decode(String.self, forKey: .modelo)
        colores = try container.decode([String].self, forKey: .colores)
        descripcion = try container.decode(String.self, forKey: .descripcion)
        fabricanteId = try container.decode(UUID.self, forKey: .fabricanteId)
        guitarristaId = try container.decode([UUID].self, forKey: .guitarristaId)
        imagen = try container.decode(Imagen.self, forKey: .imagen)
        
        let timestamp = try container.decode(TimeInterval.self, forKey: .createdAt)
        createdAt = Date(timeIntervalSince1970: timestamp / 1000)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(modelo, forKey: .modelo)
        try container.encode(colores, forKey: .colores)
        try container.encode(descripcion, forKey: .descripcion)
        try container.encode(fabricanteId, forKey: .fabricanteId)
        try container.encode(guitarristaId, forKey: .guitarristaId)
        try container.encode(imagen, forKey: .imagen)
        
        let timestamp = createdAt.timeIntervalSince1970 * 1000
        try container.encode(timestamp, forKey: .createdAt)
    }
     */
}
