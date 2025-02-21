//
//  BandaLogic.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//


import SwiftUI

final class BandaLogic: ObservableObject {
    let persistenceBanda: PersistenceIteratorBanda
    @Published var bandas: [Banda] = []
    
    // Inicialización síncrona (sin async en el init)
    init(persistenceBanda: PersistenceIteratorBanda = APIClientBanda(baseURL: URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/bandas")!)) {
        guard let validURL = URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/bandas") else {
            fatalError("URL no válida")
        }
        
        self.persistenceBanda = APIClientBanda(baseURL: validURL)
    }

    // Método para cargar bandas de manera asíncrona
    func loadBandas() async {
        do {
            self.bandas = try await persistenceBanda.loadBandas()
        } catch {
            print("Error al cargar bandas: \(error)")
            self.bandas = []
        }
    }
}
