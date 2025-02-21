import SwiftUI

final class GuitarraLogic: ObservableObject {
    let persistenGuitar: PersistenceIteratorGuitar
    @Published var guitarras: [Guitarra] = []
    
    // Inicialización síncrona (sin async en el init)
    init(persistenGuitar: PersistenceIteratorGuitar = APIClient(baseURL: URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/guitarra")!)) {
        guard let validURL = URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/guitarra") else {
            fatalError("URL no válida")
        }
        
        self.persistenGuitar = APIClient(baseURL: validURL)
    }

    
    // Método para cargar guitarras de manera asíncrona
    func loadGuitarras() async {
        do {
            self.guitarras = try await persistenGuitar.loadGuitarras()
        } catch {
            print("Error al cargar guitarras: \(error)")
            self.guitarras = []
        }
    }
}
