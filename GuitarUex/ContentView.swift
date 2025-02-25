import SwiftUI
struct ContentView: View {
    @StateObject private var userLogic = UserLogic()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            // Vista de Guitarras
            ViewGuitarra()
                .tabItem {
                    Image(systemName: "guitars")
                    Text("Guitarras")
                }

            // Vista de GPT
            ViewGPT()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right")
                    Text("Chat AI")
                }

            // Mostrar vista de usuario si está autenticado, de lo contrario mostrar login
            if authViewModel.isAuthenticated {
                ViewUser()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Usuario")
                    }
            } else {
                ContentViewLogin()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Usuario")
                    }
            }
        }
        .accentColor(.blue)
        .task {
                await userLogic.loadUser()  // Cargamos el usuario solo si no tiene datos
        }
    }
}

#Preview {
    ContentView().environmentObject(AuthViewModel())
}
