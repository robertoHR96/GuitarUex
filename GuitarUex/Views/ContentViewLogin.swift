//
//  ContentViewLogin.swift
//  cursoSwiftUI
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//
import SwiftUI

struct ContentViewLogin: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading = false  // Estado para mostrar carga
    @State private var showAlertNoLogin = false
    
    var body: some View {
        VStack {
            Text("Inicio de sesión").font(.title).fontWeight(.bold)
            TextField("Username", text: $email)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(6)
                .padding(.horizontal, 60)
                .padding(.top, 20)
            
            SecureField("Password", text: $password)
                .keyboardType(.default)
                .disableAutocorrection(true)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(6)
                .padding(.horizontal, 60)
                .padding(.top, 20)
            
            Button(action: {
                isLoading = true
                sendLoginRequest()
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                } else {
                    Text("Iniciar sesión")
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(6)
            .padding(.horizontal, 60)
            .padding(.top, 20)
            .disabled(isLoading)  // Deshabilitar mientras se carga
        }
        .padding(20)
        .alert(isPresented: $showAlertNoLogin) {
            Alert(
                title: Text("Error de inicio de sesión"),
                message: Text("El inicio de sesión no se completó correctamente. Verifica tus credenciales e intenta nuevamente."),
                dismissButton: .default(Text("Aceptar"))
            )
        }
    }
    
    // 1. Definir la estructura de los datos que se enviarán
    struct LoginRequest: Codable {
        let email: String
        let password: String
    }
    
    // 2. Función para hacer el POST request
    func sendLoginRequest() {
        guard let url = URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/auth/login") else {
            print("URL no válida")
            isLoading = false
            return
        }
        
        // Crear los datos a enviar
        let loginData = LoginRequest(email: email, password: password)
        
        // Convertir a JSON
        guard let jsonData = try? JSONEncoder().encode(loginData) else {
            print("Error al codificar JSON")
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Enviar la solicitud
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }
            
            if let error = error {
                print("Error en la solicitud: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No se recibieron datos")
                return
            }
            
            do {
                let jsonResponse = try JSONDecoder().decode([String: String].self, from: data)
                if let authToken = jsonResponse["authToken"] {
                    // Guardar en KeychainManager
                    KeychainManager.shared.save(token: authToken)
                    print("Token guardado: \(authToken)")
                } else {
                    print("No se encontró authToken en la respuesta")
                }
            } catch {
                print("Error al decodificar JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

#Preview {
    ContentViewLogin()
}
