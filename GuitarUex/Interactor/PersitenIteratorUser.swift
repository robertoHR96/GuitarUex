//
//  PersitenIteratorUser.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 24/2/25.
//

import Foundation

protocol PersitenIteratorUser{
    var baseURL: URL { get }
    func loadUser() async throws -> User
    func saveUser(_ user : User) async throws
}

extension PersitenIteratorUser {
    func loadUser() async throws -> User {
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
        
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func saveUser(_ user: User) async throws {
        guard let bearerToken = KeychainManager.shared.retrieveToken() else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se encontró token de autenticación"])
        }
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(user)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}

struct APIClientUser: PersitenIteratorUser {
    var baseURL: URL
     
    // Inicializador seguro
    init(baseURL: URL? = nil) {
        if let validURL = baseURL {
            self.baseURL = validURL
        } else {
            self.baseURL = URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/userLog")!
        }
    }
}
