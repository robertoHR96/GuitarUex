import SwiftUI

struct ContentView: View {
    @State private var token: String? = KeychainManager.shared.retrieveToken()
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
            
            if let token = token, !token.isEmpty {
                // Si existe el token, mostramos la vista principal
                ViewUser()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Usuario")
                    }
            } else {
                // Si no existe el token, mostramos la vista de login
                ContentViewLogin()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Usuario")
                    }
            }
            // Vista de Usuario
        }
        .accentColor(.blue) // Cambia el color de la barra
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
