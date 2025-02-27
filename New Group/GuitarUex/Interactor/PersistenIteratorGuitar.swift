//
//  PersistenIteratorGuitar.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//

import Foundation
protocol PersistenceIteratorGuitar{
    var baseURL: URL { get }
    func loadGuitarras() async throws -> [Guitarra]
    func saveGuitarra(_ guitarras: [Guitarra]) async throws
}

extension PersistenceIteratorGuitar {
    func loadGuitarras() async throws -> [Guitarra] {
        guard let bearerToken = KeychainManager.shared.retrieveToken() else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se encontró token de autenticación"])
        }
        var request = URLRequest(url: baseURL)
        
        // Asegúrate de usar el token en la autorización
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([Guitarra].self, from: data)
    }
    
    func saveGuitarra(_ guitarras: [Guitarra]) async throws {
        guard let bearerToken = KeychainManager.shared.retrieveToken() else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se encontró token de autenticación"])
        }
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(guitarras)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}

struct APIClient: PersistenceIteratorGuitar {
    var baseURL: URL
     
    // Inicializador seguro
    init(baseURL: URL? = nil) {
        if let validURL = baseURL {
            self.baseURL = validURL
        } else {
            self.baseURL = URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/guitarra")!
        }
    }
}
