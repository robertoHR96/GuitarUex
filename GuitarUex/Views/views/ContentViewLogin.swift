import SwiftUI

struct LoginData: Codable {
    var email: String
    var password: String
}

struct ContentViewLogin: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userLogic: UserLogic
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var showAlertNoLogin = false

    var body: some View {
        VStack {
            Text("Inicio de sesión").font(.title).fontWeight(.bold)
            Spacer()
            TextField("Username", text: $email)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .autocapitalization(.none)
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
            .disabled(isLoading)
            Spacer()
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
    

    func sendLoginRequest() {
        guard let url = URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/auth/login") else {
            print("URL no válida")
            isLoading = false
            return
        }

        let loginData = LoginData(email: email, password: password)

        guard let jsonData = try? JSONEncoder().encode(loginData) else {
            print("Error al codificar JSON")
            showAlertNoLogin = true
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            if let error = error {
                print("Error en la solicitud: \(error.localizedDescription)")
                showAlertNoLogin = true
                return
            }

            guard let data = data else {
                print("No se recibieron datos")
                showAlertNoLogin = true
                return
            }

            do {
                let jsonResponse = try JSONDecoder().decode([String: String].self, from: data)
                if let authToken = jsonResponse["authToken"] {
                    DispatchQueue.main.async {
                        authViewModel.login(token: authToken, email: loginData.email)
                    }
                    Task {
                        await userLogic.loadUser() // Cargar datos del usuario tras login exitoso
                    }
                } else {
                    print("No se encontró authToken en la respuesta")
                    showAlertNoLogin = true
                }
            } catch {
                print("Error al decodificar JSON: \(error.localizedDescription)")
                showAlertNoLogin = true
            }
            
        }.resume()
    }
}

#Preview {
    ContentViewLogin()
        .environmentObject(AuthViewModel())
        .environmentObject(UserLogic())
}
