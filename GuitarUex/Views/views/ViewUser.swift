import SwiftUI

struct ViewUser: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userLogic: UserLogic
    var body: some View {
        VStack {
            Text("Cuenta").font(.title).fontWeight(.bold)
            Spacer()
            
            // Mostrar los datos del usuario una vez que se haya cargado
            Text("Username")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 60)
            Text(userLogic.user.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 60)
            
            Text("Email")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 60)
                .padding(.top, 20)
            Text(userLogic.user.email)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 60)
            
            Button(action: {
                authViewModel.logout()  // Llama a la función logout del AuthViewModel
                userLogic.logoutUser()
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
            Spacer()
        }
    }
}



#Preview {
    ViewUser()
        .environmentObject(AuthViewModel())
        .environmentObject(UserLogic())
}
