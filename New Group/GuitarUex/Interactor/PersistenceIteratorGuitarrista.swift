//
//  PersistenceIteratorGuitarrista.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 25/2/25.
//


// PersistenceIteratorGuitarrista.swift
// GuitarUex
//
// Created by Roberto Hermoso Rivero on 25/2/25.
//

import Foundation

protocol PersistenceIteratorGuitarrista {
    var baseURL: URL { get }
    func loadGuitarrista() async throws -> [Guitarrista]
    func saveGuitarrista(_ guitarristas: [Guitarrista]) async throws
    func getGuitarristaById(id: UUID) async throws -> Guitarrista
}

extension PersistenceIteratorGuitarrista {
    func loadGuitarrista() async throws -> [Guitarrista] {
        guard let bearerToken = KeychainManager.shared.retrieveToken() else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se encontró token de autenticación"])
        }
        
        var request = URLRequest(url: baseURL)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([Guitarrista].self, from: data)
    }
    
    func getGuitarristaById(id: UUID) async throws -> Guitarrista {
        guard let bearerToken = KeychainManager.shared.retrieveToken() else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se encontró token de autenticación"])
        }

        let guitarristaURL = baseURL.appendingPathComponent(id.uuidString)
        var request = URLRequest(url: guitarristaURL)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("error hhtp response guitarrista\(response)")
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(Guitarrista.self, from: data)
    }
    
    func saveGuitarrista(_ guitarristas: [Guitarrista]) async throws {
        guard let bearerToken = KeychainManager.shared.retrieveToken() else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se encontró token de autenticación"])
        }
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(guitarristas)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}

struct APIClientGuitarrista: PersistenceIteratorGuitarrista {
    var baseURL: URL
    
    init(baseURL: URL? = nil) {
        self.baseURL = baseURL ?? URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/guitarrista")!
    }
}
