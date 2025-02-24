//
//  BandaDetailView.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 24/2/25.
//


//
//  BandaDetailView.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 24/2/25.
//

import SwiftUI

struct BandaDetailView: View {
    var banda: Banda// Asumiendo que 'Guitarra' es tu modelo
    
    var body: some View {
        ScrollView { // Usamos ScrollView para permitir que la vista sea desplazable si el contenido es largo
            VStack(alignment: .leading, spacing: 16) {
                
                
                // Mostrar la imagen si está disponible
                if let imageUrl = URL(string: banda.imagen.path), !banda.imagen.path.isEmpty {
                    // Usamos .onAppear para imprimir la URL cuando la vista de imagen aparece
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // Muestra un cargador mientras la imagen se descarga
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        case .success(let image):
                            image.resizable()
                                 .scaledToFit()
                                 .frame(height: 250)
                                 .cornerRadius(12)
                        case .failure:
                            Text("Error al cargar la imagen ")
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.bottom)
                    .onAppear {
                        // Ahora imprimimos la URL en la consola cuando la vista aparece
                        print("URL de imagen válida: \(imageUrl)") // Imprimir la URL aquí
                    }
                } else {
                    Text("URL de imagen no válida")
                        .foregroundColor(.red)
                }
                // Aquí podrías agregar más detalles si lo deseas, como el fabricante o el guitarrista
                Spacer()
            }
            .padding()
        }
        .navigationTitle(banda.name) // Título específico para esta vista
    }
}
