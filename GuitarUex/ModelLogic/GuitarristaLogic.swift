//
//  GuitarristaLogic.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 25/2/25.
//


// GuitarristaLogic.swift
// GuitarUex
//
// Created by Roberto Hermoso Rivero on 25/2/25.
//

import SwiftUI

@MainActor
final class GuitarristaLogic: ObservableObject {
    let persistenceGuitarrista: PersistenceIteratorGuitarrista
    @Published var guitarristas: [Guitarrista] = []
    @Published var guitarrista: Guitarrista
    @Published var isLoading: Bool = false
    private var isGuitarristasLoaded = false
    
    // Inicialización síncrona (sin async en el init)
    init(persistenceGuitarrista: PersistenceIteratorGuitarrista = APIClientGuitarrista(baseURL: URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/guitarrista")!)) {
        guard let validURL = URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/guitarrista") else {
            fatalError("URL no válida")
        }
        
        self.persistenceGuitarrista = APIClientGuitarrista(baseURL: validURL)
        self.guitarrista = Guitarrista(
            id: UUID(),
            createdAt: Date(),
            nombre: "",
            guitarraId: [],
            bandasId: []
        )
    }
    
    func getGuitarristasByIds(uuids: [UUID]) async {
        self.isGuitarristasLoaded = false
        self.isLoading = true
        do {
            print("Cargando guitarristas por IDs en lógica")
            
            // Limpiar la lista de guitarristas antes de cargar nuevos
            self.guitarristas = []
            
            // Recorremos cada UUID en el array
            for uuid in uuids {
                do {
                    let guitarristaLoad = try await persistenceGuitarrista.getGuitarristaById(id: uuid)
                    self.guitarristas.append(guitarristaLoad)
                } catch {
                    print("Error al cargar guitarristas por IDs \(uuid): \(error)")
                    // En caso de error, añadir un guitarrista vacío como fallback
                    self.guitarristas.append(Guitarrista(id: uuid, createdAt: Date(), nombre: "", guitarraId: [], bandasId: []))
                }
            }
            
            self.isGuitarristasLoaded = true
            self.isLoading = false
        } catch {
            print("Error al cargar guitarristas por ids: \(error)")
            self.isLoading = false
        }
    }

    // Método para obtener un guitarrista por su ID
    func getGuitarristaById(uuid: UUID) async {
        self.isGuitarristasLoaded = false
        self.isLoading = true
        do {
            print("Cargando guitarrista por ID en lógica")
            let guitarristaLoad = try await persistenceGuitarrista.getGuitarristaById(id: uuid)
            self.guitarrista = guitarristaLoad
            self.isGuitarristasLoaded = true
            self.isLoading = false
        } catch {
            print("Error al cargar guitarrista por ID: \(error)")
            self.guitarrista = Guitarrista(id: UUID(), createdAt: Date(), nombre: "", guitarraId: [], bandasId: [])
            self.isGuitarristasLoaded = true
            self.isLoading = false
        }
    }

    // Método para cargar guitarristas de manera asíncrona usando force
    func loadGuitarristasForce() async {
        self.isGuitarristasLoaded = false
        self.isLoading = true
        do {
            print("Cargando guitarristas en lógica con force")
            let guitarristasLoad = try await persistenceGuitarrista.loadGuitarrista()
            self.guitarristas = guitarristasLoad
            self.isGuitarristasLoaded = true
            self.isLoading = false
        } catch {
            print("Error al cargar guitarristas con force: \(error)")
            self.guitarristas = []
            self.isGuitarristasLoaded = true
            self.isLoading = false
        }
    }
    
    // Método para cargar guitarristas de manera asíncrona
    func loadGuitarristas() async {
        guard !isGuitarristasLoaded else { return }
        self.isLoading = true
        do {
            print("Cargando guitarristas en lógica")
            let guitarristasLoad = try await persistenceGuitarrista.loadGuitarrista()
            self.guitarristas = guitarristasLoad
            self.isGuitarristasLoaded = true
            self.isLoading = false
        } catch {
            print("Error al cargar guitarristas: \(error)")
            self.guitarristas = []
            self.isGuitarristasLoaded = true
            self.isLoading = false
        }
    }
}
