import SwiftUI

struct ViewGuitarra: View {
    @StateObject private var guitarraLogic = GuitarraLogic()

    var body: some View {
        VStack {
            if guitarraLogic.guitarras.isEmpty {
                Text("Cargando guitarras...")
                    .padding()
            } else {
                List(guitarraLogic.guitarras) { guitarra in
                    VStack(alignment: .leading) {
                        Text(guitarra.modelo)
                            .font(.headline)
                        Text(guitarra.descripcion)
                            .font(.subheadline)
                    }
                }
            }
        }
        // Llamada async de manera controlada cuando la vista aparece
        .task {
            await guitarraLogic.loadGuitarras() // Ejecutamos la tarea asíncrona correctamente
        }
    }
}

#Preview {
    ViewGuitarra()
}
