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
    @Published var fabricante: Fabricante
    @Published var isLoading: Bool = false
    private var isFabricantesLoaded = false
    
    // Inicialización síncrona (sin async en el init)
    init(persistenceFabricante: PersistenceIteratorFabricante = APIClientFabricante(baseURL: URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/fabricante")!)) {
        guard let validURL = URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/fabricante") else {
            fatalError("URL no válida")
        }
        
        self.persistenceFabricante = APIClientFabricante(baseURL: validURL)
        self.fabricante = Fabricante(
            id: UUID(),
            createdAt: Date(),
            name: "",
            location: "",
            imagen: Fabricante.ImagenFabricante(
                access: "",
                path: "",
                name: "",
                type: "",
                size: 0,
                mime: "",
                meta: [:],
                url: ""
            )
        )
    }
    
    // Metodo para obtener un fabricante por su ID
    func getFabricanteById(uuid: UUID) async {
        self.isFabricantesLoaded=false
        self.isLoading=true;
        do {
            print("cargando fabricante for id in logic")
            let fabricantesLoad = try await persistenceFabricante.getFabricanteById(id: uuid )
            self.fabricante = fabricantesLoad
            self.isFabricantesLoaded=true
            self.isLoading=false;
            
        } catch {
            print("Error al cargar fabricatne for id: \(error)")
            self.fabricante = Fabricante(id: UUID(), createdAt: Date(), name: "", location: "", imagen: Fabricante.ImagenFabricante(
                access: "",
                path: "",
                name: "",
                type: "",
                size: 0,
                mime: "",
                meta: [:],
                url: ""
            ))
            self.isFabricantesLoaded=true
            self.isLoading=false;
        }
    }
    
    
    // Método para cargar fabricante de manera asíncrona usando force
    func loadFabricantesForce() async {
        self.isFabricantesLoaded=false
        self.isLoading=true;
        do {
            print("cargando fabricantes logic con force")
            let fabricantesLoad = try await persistenceFabricante.loadFabricante()
            self.fabricantes = fabricantesLoad
            self.isFabricantesLoaded=true
            self.isLoading=false;
            
        } catch {
            print("Error al cargar fabricantes with force: \(error)")
            self.fabricantes = []
            self.isFabricantesLoaded=true
            self.isLoading=false;
        }
    }
    
    // Método para cargar fabricante de manera asíncrona
    func loadFabricantes() async {
        guard !isFabricantesLoaded else { return }
        self.isLoading=true;
        do {
            print("cargando fabricantes in logic")
            let fabricantesLoad = try await persistenceFabricante.loadFabricante()
            self.fabricantes = fabricantesLoad
            self.isFabricantesLoaded=true
            self.isLoading=false;
            
        } catch {
            print("Error al cargar fabricantes: \(error)")
            self.fabricantes = []
            self.isFabricantesLoaded=true
            self.isLoading=false;
        }
    }
}
