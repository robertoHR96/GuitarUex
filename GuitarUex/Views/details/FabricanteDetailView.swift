//
//  FabricanteDetailView.swift
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


//
//  BandaDetailView.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 24/2/25.
//

import SwiftUI

struct FabricanteDetailView: View {
    var fabricante: Fabricante// Asumiendo que 'Guitarra' es tu modelo
    @ObservedObject var imagenFabricante = ImageLoad()
    
    
    var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text(fabricante.name)
                    .font(.title)
                    .fontWeight(.bold)
                imagenFabricante.imagen
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(12)
                Text("Localización").font(.headline)
                Text(fabricante.location)
                Spacer()
            }
            .onAppear{
                imagenFabricante.getImage(url:URL(string: fabricante.imagen.path)!)
            }
            .padding()
    }
}
