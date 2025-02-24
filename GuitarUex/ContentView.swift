import SwiftUI
struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            // Vista de Guitarras
            ViewGuitarra()
                .tabItem {
                    Image(systemName: "guitars")
                    Text("Guitarras")
                }

            // Vista de Guitarristas
            ViewGuitarrista()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Guitarristas")
                }

            // Vista de Fabricantes
            ViewFabricante()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Fabricantes")
                }

            // Vista de Bandas
            ViewBanda()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Bandas")
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
    }
}

#Preview {
    ContentView().environmentObject(AuthViewModel())
}
