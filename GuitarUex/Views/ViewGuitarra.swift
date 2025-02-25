import SwiftUI

struct ViewGuitarra: View {
    @StateObject private var guitarraLogic = GuitarraLogic()
    @EnvironmentObject var authViewModel: AuthViewModel
    // Estas son las variables de estado que controlarán si la hoja debe mostrarse
    @State private var isShowingAddGuitarra = false
    @State private var isShowingAddFabricante = false
    @State private var isShowingAddGuitarrista = false
    var body: some View {
        NavigationView {
            VStack {
                if guitarraLogic.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, alignment: .center) // Asegura que el círculo de carga esté centrado
                } else {
                    List(guitarraLogic.guitarras) { guitarra in
                        NavigationLink(destination: GuitarraDetailView(guitarra: guitarra)) {
                            VStack(alignment: .leading) {
                                Text(guitarra.modelo)
                                    .font(.headline)
                                Text(guitarra.descripcion)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .refreshable {
                        // Llama al método de carga al hacer pull-to-refresh
                        await guitarraLogic.loadGuitarrasForce()
                    }
                }
            }
            // Llamada async de manera controlada cuando la vista aparece
            .task {
                await guitarraLogic.loadGuitarras() // Ejecutamos la tarea asíncrona correctamente
                print(authViewModel.$isAdmin)
            }
            .navigationTitle("Lista de Guitarras") // Título de la vista
            
            .navigationBarItems(trailing: authViewModel.isAdmin ? Menu {
                Button(action: {
                    // Acción para mostrar la hoja de añadir guitarra
                    isShowingAddGuitarra.toggle()
                }) {
                    Label("Añadir guitarra", systemImage: "guitars")
                }
                Button(action: {
                    // Acción para mostrar la hoja de añadir fabricante
                    isShowingAddFabricante.toggle()
                }) {
                    Label("Añadir fabricante", systemImage: "house")
                }
                Button(action: {
                    // Acción para mostrar la hoja de añadir guitarrista
                    isShowingAddGuitarrista.toggle()
                }) {
                    Label("Añadir guitarrista", systemImage: "person")
                }
            } label: {
                Image(systemName: "plus") // Icono del botón
                    .font(.title) // Tamaño del icono
            } : nil)
            
            
            .sheet(isPresented: $isShowingAddGuitarra) {
                // Vista para añadir guitarra
                AddGuitarraView()
            }
            .sheet(isPresented: $isShowingAddFabricante) {
                // Vista para añadir fabricante
                AddFabricanteView()
            }
            .sheet(isPresented: $isShowingAddGuitarrista) {
                // Vista para añadir guitarrista
                AddGuitarristaView()
            }
        }
    }
}

#Preview {
    ViewGuitarra().environmentObject(AuthViewModel())
}
