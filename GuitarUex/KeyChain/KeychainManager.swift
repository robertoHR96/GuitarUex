//
//  KeychainManager.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//



import Foundation
import Security

class KeychainManager {
    
    static let shared = KeychainManager() // Singleton
    
    // Método para guardar el token
    func save(token: String) {
        guard let tokenData = token.data(using: .utf8) else {
            print("Error al convertir el token a datos")
            return
        }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "authToken",
            kSecValueData: tokenData
        ]
        
        // Borrar cualquier valor previo
        SecItemDelete(query as CFDictionary)
        
        // Guardar el nuevo valor en el llavero
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Token guardado exitosamente")
        } else {
            print("Error al guardar el token: \(status)")
        }
    }
    
    // Método para recuperar el token
    func retrieveToken() -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "authToken",
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess, let data = item as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        } else {
            print("Error al obtener el token: \(status)")
            return nil
        }
    }
}
