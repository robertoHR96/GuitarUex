import SwiftUI


struct ViewFabricante: View {
    @StateObject private var fabricanteLogic = FabricanteLogic()
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationView {
            VStack {
                if !authViewModel.isAuthenticated{
                    Text("No estás autenticado. Por favor, inicia sesión.")
                                       .font(.headline)
                                       .foregroundColor(.red)
                                       .padding()
                }else{
                    if fabricanteLogic.isLoading{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(maxWidth: .infinity, alignment: .center) // Asegura que el círculo de carga esté centrado
                    } else {
                        List(fabricanteLogic.fabricantes) { fabricante in
                            NavigationLink(destination: FabricanteDetailView(fabricante: fabricante)) {
                                VStack(alignment: .leading) {
                                    Text(fabricante.name)
                                        .font(.headline)
                                }
                            }
                        }
                        .refreshable {
                            // Llama al método de carga al hacer pull-to-refresh
                            await fabricanteLogic.loadFabricantesForce()
                        }
                    }
                }
            }
            // Llamada async de manera controlada cuando la vista aparece
            .task {
                await fabricanteLogic.loadFabricantes() // Ejecutamos la tarea asíncrona correctamente
            }
            .navigationTitle("Lista de Fabricantes") // Título de la vista
            .navigationBarItems(trailing: Button(action: {
                // Aquí puedes poner la acción que quieres que ocurra al presionar el botón
                print("Botón Añadir presionado")
            }) {
                Image(systemName: "plus") // Icono del botón
                    .font(.title) // Tamaño del icono
            })
        }
    }
}
#Preview {
    ViewFabricante().environmentObject(AuthViewModel())
}
