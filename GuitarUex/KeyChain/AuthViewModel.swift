//
//  AuthViewModel.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//


import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool {
        didSet {
            UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
        }
    }
    
    @Published var userName: String = ""
    
    init() {
        self.isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        self.userName = UserDefaults.standard.string(forKey: "userName") ?? ""
    }
    
    func login(token: String, userName: String) {
        KeychainManager.shared.save(token: token)  // Guarda el token en Keychain
        self.userName = userName
        self.isAuthenticated = true
        
        // Guarda el nombre en UserDefaults
        UserDefaults.standard.set(userName, forKey: "userName")
    }
    
    func logout() {
        KeychainManager.shared.save(token: "")  // Borra el token
        self.isAuthenticated = false
        self.userName = ""
        
        // Borra el nombre del usuario en UserDefaults
        UserDefaults.standard.removeObject(forKey: "userName")
    }
}
