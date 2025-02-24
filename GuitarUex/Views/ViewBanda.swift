//
//  ViewBanda.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//
import SwiftUI

struct ViewBanda: View {
    @StateObject private var bandaLogic = BandaLogic() // Se usa @StateObject para manejar el estado
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            // Verifica si el usuario está autenticado
            if !authViewModel.isAuthenticated {
                Text("No estás autenticado. Por favor, inicia sesión.")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
            } else {
                // Si el usuario está autenticado, carga las bandas
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
        }
        .refreshable {
            // Llama al método de carga al hacer pull-to-refresh
            await bandaLogic.loadBandas() // Llamamos a loadBandas(), no loadGuitarras()
        }
        // Cargar bandas cuando la vista aparece, solo si está autenticado
        .task {
            if authViewModel.isAuthenticated {
                await bandaLogic.loadBandas() // Llamamos a loadBandas() solo si el usuario está autenticado
            }
        }
    }
}

#Preview {
    ViewBanda()
        .environmentObject(AuthViewModel())  // Inyectar AuthViewModel en el preview
}
