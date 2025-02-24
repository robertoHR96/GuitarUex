//
//  BandaLogic.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//


import SwiftUI

@MainActor
final class BandaLogic: ObservableObject {
    let persistenceBanda: PersistenceIteratorBanda
    @Published var bandas: [Banda] = []
    @Published var isLoading: Bool = false
    private var isBandasLoaded = false
    
    // Inicialización síncrona (sin async en el init)
    init(persistenceBanda: PersistenceIteratorBanda = APIClientBanda(baseURL: URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/bandas")!)) {
        guard let validURL = URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/bandas") else {
            fatalError("URL no válida")
        }
        
        self.persistenceBanda = APIClientBanda(baseURL: validURL)
    }
    
    // Método para cargar bandas de manera asíncrona
    func loadBandasForce() async {
        self.isBandasLoaded=false
        self.isLoading=true;
        do {
            print("cargando bandasmin logic con force")
            let bandasLoad = try await persistenceBanda.loadBandas()
            self.bandas = bandasLoad
            self.isBandasLoaded=true
            self.isLoading=false;
            
        } catch {
            print("Error al cargar bandas: \(error)")
            self.bandas = []
            self.isBandasLoaded=true
            self.isLoading=false;
        }
    }
    func loadBandas() async {
        guard !isBandasLoaded else { return }
        self.isLoading=true;
        do {
            print("cargando bandas in logic")
            let bandasLoad = try await persistenceBanda.loadBandas()
            self.bandas = bandasLoad
            self.isBandasLoaded=true
            self.isLoading=false;
            
        } catch {
            print("Error al cargar bandas: \(error)")
            self.bandas = []
            self.isBandasLoaded=true
            self.isLoading=false;
        }
    }
}
