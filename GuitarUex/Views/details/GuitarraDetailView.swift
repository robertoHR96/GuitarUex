import SwiftUI

struct GuitarraDetailView: View {
    var guitarra: Guitarra
    @StateObject private var fabricanteLogic = FabricanteLogic()
    @StateObject private var guitarristaLogic = GuitarristaLogic()
    @ObservedObject var imagenGuitarra = ImageLoad()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                imagenGuitarra.imagen
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(12)

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
        .onAppear{
            imagenGuitarra.getImage(url:URL(string: guitarra.imagen.path)!)
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
        imagen: ImagenGuitarra()
    )
    
    GuitarraDetailView(guitarra: guitarraEjemplo )
        .previewLayout(.sizeThatFits) // Ajustar al tamaño adecuado para la vista
}
