//
//  GuitarristaDetailView.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 25/2/25.
//

import SwiftUI

struct GuitarristaDetailView: View {
    var guitarrista: Guitarrista
    @StateObject private var guitarraLogic = GuitarraLogic() // Lógica para obtener las guitarras
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Nombre del guitarrista
                Text("Nombre:")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(guitarrista.nombre)
                
                // Guitarras asociadas
                Text("Guitarras:")
                    .font(.headline)
                    .fontWeight(.bold)
                if guitarrista.guitarraId.isEmpty {
                    Text("No tiene guitarras asociadas.")
                } else {
                    ForEach(guitarrista.guitarraId, id: \.self) { guitarraId in
                        // Buscar la guitarra en la lista y mostrar su detalle
                        if let guitarra = guitarraLogic.guitarras.first(where: { $0.id == guitarraId }) {
                            NavigationLink(destination: GuitarraDetailView(guitarra: guitarra)) {
                                Text(guitarra.modelo)
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(guitarrista.nombre)
    }
}

#Preview {
    // Crear un guitarrista de ejemplo para la vista de detalles
    let guitarristaEjemplo = Guitarrista(
        id: UUID(),
        createdAt: Date(),
        nombre: "Jimi Hendrix",
        guitarraId: [UUID(), UUID()],
        bandasId: [] // Ignoramos las bandas
    )
    
    GuitarristaDetailView(guitarrista: guitarristaEjemplo)
        .previewLayout(.sizeThatFits)
}
