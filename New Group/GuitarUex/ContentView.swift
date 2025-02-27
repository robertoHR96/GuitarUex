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
                }

            // Vista de GPT
            ViewGPT()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right")
                }

            // Mostrar vista de usuario si está autenticado, de lo contrario mostrar login
            if userLogic.user.isAdmin{
                ViewUser()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                    }
            } else {
                ContentViewLogin()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                    }
            }
        }
        .accentColor(.blue)
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
