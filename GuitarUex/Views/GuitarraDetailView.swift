import SwiftUI

struct GuitarraDetailView: View {
    var guitarra: Guitarra
    @StateObject private var fabricanteLogic = FabricanteLogic()
    @StateObject private var guitarristaLogic = GuitarristaLogic()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                if let imageUrl = URL(string: guitarra.imagen.path), !guitarra.imagen.path.isEmpty {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .frame(height: 250)
                                .cornerRadius(12)
                        case .failure:
                            Text("Error al cargar la imagen")
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.bottom)
                    .onAppear {
                        print("URL de imagen válida: \(imageUrl)")
                    }
                } else {
                    Text("URL de imagen no válida")
                        .foregroundColor(.red)
                }
                
                Text("Descripción:")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(guitarra.descripcion)
                    .padding(.bottom)
                
                Text("Colores:")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(guitarra.colores.joined(separator: ", "))
                    .padding(.bottom)
                
                Text("Fabricante")
                    .font(.headline)
                
                if !fabricanteLogic.isLoading {
                    NavigationLink(destination: FabricanteDetailView(fabricante: fabricanteLogic.fabricante)) {
                        Text(fabricanteLogic.fabricante.name)
                            .foregroundColor(.blue)
                            .underline()
                    }
                }
                // Sección de Guitarristas
                Text("Guitarristas:")
                    .font(.headline)
                    .fontWeight(.bold)
                if !guitarristaLogic.isLoading {
                    ForEach(guitarristaLogic.guitarristas, id: \.self) { guitarrista in
                        NavigationLink(destination: GuitarristaDetailView(guitarrista: guitarrista)){
                            Text(guitarrista.nombre)
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                }
                
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(guitarra.modelo)
        .task{
            await fabricanteLogic.getFabricanteById(uuid: guitarra.fabricanteId)
            await guitarristaLogic.getGuitarristasByIds(uuids: guitarra.guitarristaId)
        }
    }
}
#Preview {
    // Crear una guitarra de ejemplo para la vista de detalles
    let guitarraEjemplo = Guitarra(
        id: UUID(),
        createdAt: Date(),
        modelo: "Telecaster",
        colores: ["Butterscotch", "Black", "Sunburst"],
        descripcion: "La Fender Telecaster es famosa por su sonido brillante y su simplicidad. Su diseño de cuerpo sólido y su único par de pastillas de bobina simple le dan una tonalidad cortante y precisa. Ha sido un pilar en géneros como el country, rock y blues.",
        fabricanteId: UUID(),
        guitarristaId: [UUID(), UUID()],
        imagen: Guitarra.ImagenGuitarra(
            access: "public",
            path: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.mfRnGToIkiO0uazWap713wHaCo%26pid%3DApi&f=1&ipt=6a575ad0eff261430886e5f5fd5f3eb0f5ffe4621a40b8f2b893e6a77357e835&ipo=images",
            name: "Telecaster Image",
            type: "image/jpeg",
            size: 12345,
            mime: "image/jpeg",
            meta: [:],
            url: "https://x8ki-letl-twmt.n7.xano.iohttps://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.mfRnGToIkiO0uazWap713wHaCo%26pid%3DApi&f=1&ipt=6a575ad0eff261430886e5f5fd5f3eb0f5ffe4621a40b8f2b893e6a77357e835&ipo=images"
        )
    )
    
    GuitarraDetailView(guitarra: guitarraEjemplo )
        .previewLayout(.sizeThatFits) // Ajustar al tamaño adecuado para la vista
}
