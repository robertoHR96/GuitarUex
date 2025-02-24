import SwiftUI


struct ViewGuitarra: View {
    @StateObject private var guitarraLogic = GuitarraLogic()
    
    var body: some View {
        NavigationView {
            VStack {
                if guitarraLogic.isLoading{
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
            }
            .navigationTitle("Lista de Guitarras") // Título de la vista
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
    ViewGuitarra()
}
