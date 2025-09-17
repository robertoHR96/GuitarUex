import SwiftUI
struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userLogic: UserLogic
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
                    Text("Chat GPT")
                }
            GuitarTunerView()
                .tabItem{
                    Image(systemName: "dial.medium")
                    Text("Afinador")
                }
            // Mostrar vista de usuario si está autenticado, de lo contrario mostrar login
            if userLogic.user.isAdmin{
                ViewUser()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("User")
                    }
            } else {
                ContentViewLogin()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("User")
                    }
            }
        }
        .accentColor(.green)
        .task{
            await userLogic.loadUser()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(UserLogic())
}
