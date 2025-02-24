import SwiftUI

@MainActor
final class GuitarraLogic: ObservableObject {
    let persistenGuitar: PersistenceIteratorGuitar
    @Published var guitarras: [Guitarra] = []
    @Published var isLoading: Bool = false
    private var isGuitarLoaded = false
    // Inicialización síncrona (sin async en el init)
    init(persistenGuitar: PersistenceIteratorGuitar = APIClient(baseURL: URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/guitarra")!)) {
        guard let validURL = URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/guitarra") else {
            fatalError("URL no válida")
        }
        
        self.persistenGuitar = APIClient(baseURL: validURL)
    }
    
    
    // Método para cargar guitarras de manera asíncrona
    func loadGuitarrasForce() async {
        guard !isGuitarLoaded else { return }
        self.isLoading=true;
        do {
            let guitarrasLoad = try await persistenGuitar.loadGuitarras()
            self.guitarras = guitarrasLoad
            self.isGuitarLoaded=true
            self.isLoading=false;
            
        } catch {
            print("Error al cargar guitarras: \(error)")
            self.guitarras = []
            self.isGuitarLoaded=true
            self.isLoading=false;
        }
    }
    func loadGuitarras() async {
        guard !isGuitarLoaded else { return }
        self.isLoading=true;
        do {
            let guitarrasLoad = try await persistenGuitar.loadGuitarras()
            self.guitarras = guitarrasLoad
            self.isGuitarLoaded=true
            self.isLoading=false;
            
        } catch {
            print("Error al cargar guitarras: \(error)")
            self.guitarras = []
            self.isGuitarLoaded=true
            self.isLoading=false;
        }
    }
}
