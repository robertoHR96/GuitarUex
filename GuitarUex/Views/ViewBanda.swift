import SwiftUI


struct ViewBanda: View {
    @StateObject private var bandaLogic = BandaLogic()
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
                    if bandaLogic.isLoading{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(maxWidth: .infinity, alignment: .center) // Asegura que el círculo de carga esté centrado
                    } else {
                        List(bandaLogic.bandas) { banda in
                            NavigationLink(destination: BandaDetailView(banda: banda)) {
                                VStack(alignment: .leading) {
                                    Text(banda.name)
                                        .font(.headline)
                                }
                            }
                        }
                        .refreshable {
                            // Llama al método de carga al hacer pull-to-refresh
                            await bandaLogic.loadBandasForce()
                        }
                    }
                }
            }
            // Llamada async de manera controlada cuando la vista aparece
            .task {
                await bandaLogic.loadBandas() // Ejecutamos la tarea asíncrona correctamente
            }
            .navigationTitle("Lista de Bandas") // Título de la vista
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
    ViewBanda().environmentObject(AuthViewModel())  
}
