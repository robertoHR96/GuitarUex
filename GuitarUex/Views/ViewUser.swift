import SwiftUI
struct ViewUser: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var userLogic = UserLogic()
    @State var email: String = ""
    @State var name: String = ""
    var body: some View {
        VStack {
            Text("Cuenta").font(.title).fontWeight(.bold)
            Spacer()
            
            if userLogic.isLoading{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, alignment: .center) // Asegura que el círculo de carga esté centrado
            } else {
                // Mostrar los datos del usuario una vez que se haya cargado
                Text("Username")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 60)
                Text(name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 60)
                
                Text("Email")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 60)
                    .padding(.top, 20)
                Text(email)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 60)
                
                Button(action: {
                    authViewModel.logout()  // Llama a la función logout del AuthViewModel
                    email=""
                    name=""
                }) {
                    Text("Cerrar sesión")
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(6)
                .padding(.horizontal, 60)
                .padding(.top, 20)
            }
            
            Spacer()
        }
        .task {
            if userLogic.user.email.isEmpty && userLogic.user.name.isEmpty {
                await userLogic.loadUser()  // Cargamos el usuario solo si no tiene datos
                email = userLogic.user.email
                name = userLogic.user.name
            }
        }
    }
}



#Preview {
    ViewUser()
        .environmentObject(AuthViewModel())  // Inyectar AuthViewModel en el preview
}
