//
//  BandaLogic.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//


import SwiftUI

@MainActor
final class FabricanteLogic: ObservableObject {
    let persistenceFabricante: PersistenceIteratorFabricante
    @Published var fabricantes: [Fabricante] = []
    @Published var isLoading: Bool = false
    private var isFabricantesLoaded = false
    
    // Inicialización síncrona (sin async en el init)
    init(persistenceFabricante: PersistenceIteratorFabricante = APIClientFabricante(baseURL: URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/fabricante")!)) {
        guard let validURL = URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/fabricante") else {
            fatalError("URL no válida")
        }
        
        self.persistenceFabricante = APIClientFabricante(baseURL: validURL)
    }
    
    // Método para cargar bandas de manera asíncrona
    func loadFabricantesForce() async {
        self.isFabricantesLoaded=false
        self.isLoading=true;
        do {
            print("cargando bandasmin logic con force")
            let fabricantesLoad = try await persistenceFabricante.loadFabricante()
            self.fabricantes = fabricantesLoad
            self.isFabricantesLoaded=true
            self.isLoading=false;
            
        } catch {
            print("Error al cargar bandas: \(error)")
            self.fabricantes = []
            self.isFabricantesLoaded=true
            self.isLoading=false;
        }
    }
    func loadFabricantes() async {
        guard !isFabricantesLoaded else { return }
        self.isLoading=true;
        do {
            print("cargando bandas in logic")
            let fabricantesLoad = try await persistenceFabricante.loadFabricante()
            self.fabricantes = fabricantesLoad
            self.isFabricantesLoaded=true
            self.isLoading=false;
            
        } catch {
            print("Error al cargar bandas: \(error)")
            self.fabricantes = []
            self.isFabricantesLoaded=true
            self.isLoading=false;
        }
    }
}
