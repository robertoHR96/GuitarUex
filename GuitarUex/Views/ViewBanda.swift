//
//  ViewBanda.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//

import SwiftUI

struct ViewBanda: View {
    @StateObject private var bandaLogic = BandaLogic() // Se usa @StateObject para manejar el estado
    
    var body: some View {
        VStack {
            if bandaLogic.bandas.isEmpty {
                Text("Cargando bandas...")
                    .padding()
            } else {
                List(bandaLogic.bandas) { banda in
                    VStack(alignment: .leading) {
                        Text(banda.name)
                            .font(.headline)
                    }
                }
            }
        }
        // Cargar bandas cuando la vista aparece
        .task {
            await bandaLogic.loadBandas() // Llamamos a loadBandas(), no loadGuitarras()
        }
    }
}

#Preview {
    ViewBanda()
}
