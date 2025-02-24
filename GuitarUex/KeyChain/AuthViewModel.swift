import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool {
        didSet {
            UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
        }
    }
    
    @Published var email: String = ""
    @Published var isAdmin: Bool {
        didSet {
            // Guardamos el valor de isAdmin como un String en UserDefaults
            UserDefaults.standard.set(isAdmin ? "true" : "false", forKey: "isAdmin")
        }
    }
    
    private var authToken: String? {
        didSet {
            // Si se actualiza el token, actualizamos la autenticación
            if let token = authToken, !token.isEmpty {
                self.isAuthenticated = true
            } else {
                self.isAuthenticated = false
            }
        }
    }
    
    init() {
        self.isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        self.authToken = KeychainManager.shared.retrieveToken() // Recuperar token del Keychain
        self.email = UserDefaults.standard.string(forKey: "email") ?? ""
        
        // Recuperamos el valor de isAdmin desde UserDefaults, lo convertimos a Bool
        let isAdminString = UserDefaults.standard.string(forKey: "isAdmin") ?? "false"
        self.isAdmin = isAdminString == "true"
    }
    
    func setIsAdmin(isAdmin: Bool) {
        self.isAdmin = isAdmin
    }
    
    func login(token: String, email: String) {
        KeychainManager.shared.save(token: token)  // Guarda el token en Keychain
        self.authToken = token
        self.email = email
        self.isAuthenticated = true
        self.isAdmin = false

        // Guarda el nombre en UserDefaults
        UserDefaults.standard.set(email, forKey: "email")
        
        // Guarda el valor de isAdmin como un String en UserDefaults
        UserDefaults.standard.set(isAdmin ? "true" : "false", forKey: "isAdmin")
        print(authToken)
        print(email)
        print(isAdmin)
        print(isAuthenticated)
    }
    
    func logout() {
        KeychainManager.shared.save(token: "")  // Borra el token
        self.authToken = nil
        self.isAuthenticated = false
        self.email = ""
        self.isAdmin = false
        print(authToken)
        print(email)
        print(isAdmin)
        print(isAuthenticated)

        // Borra el nombre del usuario en UserDefaults
        UserDefaults.standard.removeObject(forKey: "email")
        
        // Borra el valor de isAdmin en UserDefaults
        UserDefaults.standard.removeObject(forKey: "isAdmin")
    }
}
