import Foundation

struct ImagenGuitarra: Codable, Hashable {
    let access: String
    let path: String
    let name: String
    let type: String
    let size: Int
    let mime: String
    let meta: [String: String]
    let url: String
    
    init(path: String="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.mfRnGToIkiO0uazWap713wHaCo%26pid%3DApi&f=1&ipt=6a575ad0eff261430886e5f5fd5f3eb0f5ffe4621a40b8f2b893e6a77357e835&ipo=images", name:String="") {
            self.access = "public"
            self.path = path
            self.name = "string"
            self.type = "string"
            self.size = 0
            self.mime = "string"
            self.meta = [:]
            self.url = ""
        }
}
struct Guitarra: Codable, Identifiable, Hashable {
    let id: UUID
    let createdAt: Date
    let modelo: String
    let colores: [String]
    let descripcion: String
    let fabricanteId: UUID
    let guitarristaId: [UUID]
    let imagen: ImagenGuitarra

    
    // Decodificación personalizada para manejar "created_at" como timestamp (Int)
    enum CodingKeys: String, CodingKey {
        case id, modelo, colores, descripcion, imagen
        case createdAt = "created_at"
        case fabricanteId = "fabricante_id"
        case guitarristaId = "guitarrista_id"
    }
    
}
