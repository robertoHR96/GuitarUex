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
    func saveGuitarra(modelo: String, descripcion: String, ulr: String, fabricante_id: UUID, guitarristas_id: [String]) async throws
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
    
    
    func saveGuitarra(modelo: String, descripcion: String, ulr: String, fabricante_id: UUID, guitarristas_id: [String]) async throws {
        guard let bearerToken = KeychainManager.shared.retrieveToken() else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se encontró token de autenticación"])
        }
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let payload: [String: Any] = [
            "modelo": modelo,
            "colores": [], // Puedes modificar esto si necesitas enviar colores
            "descripcion": descripcion,
            "fabricante_id": fabricante_id.uuidString.lowercased(),
            "guitarrista_id": guitarristas_id,
            "imagen": [
                "access": "public",
                "path": ulr,
                "name": "imagen_guitarra",
                "type": "image",
                "size": 0,
                "mime": "image/jpeg",
                "meta": [:]
            ]
        ]
        
        print(payload)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData
        } catch {
            throw NSError(domain: "EncodingError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Error al codificar el objeto Guitarra"])
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            if httpResponse.statusCode != 200 {
                if let errorMessage = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = errorMessage["error"] as? String {
                    throw NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                } else {
                    throw NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Error desconocido del servidor. Código: \(httpResponse.statusCode)"])
                }
            }
        } catch {
            throw NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error en la solicitud: \(error.localizedDescription)"])
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

