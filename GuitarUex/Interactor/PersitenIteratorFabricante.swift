//
//  PersitenIteratorFabricante.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 24/2/25.
//

//
//  PersistenceIteratorBanda.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//


import Foundation

protocol PersistenceIteratorFabricante {
    var baseURL: URL { get }
    func loadFabricante() async throws -> [Fabricante]
    func saveFabricante(_ fabricantes: [Fabricante]) async throws
}

extension PersistenceIteratorFabricante {
    func loadFabricante() async throws -> [Fabricante] {
        guard let bearerToken = KeychainManager.shared.retrieveToken() else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se encontró token de autenticación"])
        }
        
        var request = URLRequest(url: baseURL)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([Fabricante].self, from: data)
    }
    
    func saveFabricante(_ fabricantes : [Fabricante]) async throws {
        guard let bearerToken = KeychainManager.shared.retrieveToken() else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se encontró token de autenticación"])
        }
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(fabricantes)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}

struct APIClientFabricante: PersistenceIteratorFabricante {
    var baseURL: URL
    
    init(baseURL: URL? = nil) {
        if let validURL = baseURL {
            self.baseURL = validURL
        } else {
            self.baseURL = URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/fabricante")!
        }
    }
}
