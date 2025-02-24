import Foundation

struct Guitarra: Codable, Identifiable, Hashable {
    let id: UUID
    let createdAt: Date
    let modelo: String
    let colores: [String]
    let descripcion: String
    let fabricanteId: UUID
    let guitarristaId: [UUID]
    let imagen: Imagen
    struct Imagen: Codable, Hashable {
        let access: String
        let path: String
        let name: String
        let type: String
        let size: Int
        let mime: String
        let meta: [String: String]
        let url: String
    }
    
    // Decodificación personalizada para manejar "created_at" como timestamp (Int)
    enum CodingKeys: String, CodingKey {
        case id, modelo, colores, descripcion, imagen
        case createdAt = "created_at"
        case fabricanteId = "fabricante_id"
        case guitarristaId = "guitarrista_id"
    }
    
    // Decodificación personalizada para convertir el timestamp (Int) en un Date
    /*
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        
        let createdAtTimestamp = try container.decode(Int.self, forKey: .createdAt)
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtTimestamp / 1000)) // Dividir entre 1000 si el timestamp está en milisegundos
        
        self.modelo = try container.decode(String.self, forKey: .modelo)
        self.colores = try container.decode([String].self, forKey: .colores)
        self.descripcion = try container.decode(String.self, forKey: .descripcion)
        self.fabricanteId = try container.decode(UUID.self, forKey: .fabricanteId)
        self.guitarristaId = try container.decode([UUID].self, forKey: .guitarristaId)
        self.imagen = try container.decode(Imagen.self, forKey: .imagen)
    }
     */
}
