//
//  AddGuitarraView.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 25/2/25.
//
import SwiftUI

struct AddGuitarraView: View {
    @State var modelo = ""
    @State var colores = [""]
    @State var descripcion = ""
    @State var fabricante_id = UUID()
    @State var guitarrista_id = [String]()
    @State var path = ""
    
    @StateObject private var guitarraLogic = GuitarraLogic()
    @StateObject private var fabricanteLogic = FabricanteLogic()
    @StateObject private var guitarristaLogic = GuitarristaLogic()
    
    var body: some View {
        NavigationView { // Envolver en NavigationView
            VStack {
                TextField("Modelo", text: $modelo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Descripción", text: $descripcion)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("URL de la imagen", text: $path)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Picker para Fabricante
                HStack {
                    Text("Selecciona un Fabricante").tag("") // Opción inicial
                    if !fabricanteLogic.fabricantes.isEmpty {
                        Picker("Selecciona un Fabricante", selection: $fabricante_id) {
                            ForEach(fabricanteLogic.fabricantes, id: \.id) { fabricante in
                                Text(fabricante.name).tag(fabricante.id.uuidString)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                    }
                }

                Button(action: {
                    sendGuitarra()
                }) {
                    Text("Enviar Guitarra")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(6)
                        .padding(.horizontal, 60)
                }
            }
            .padding()
            .navigationTitle("Añadir Guitarra") // Aquí se agrega el título
            .task {
                await fabricanteLogic.loadFabricantesForce()
                await guitarristaLogic.loadGuitarristasForce()
            }
        }
    }
    private func guitarristaSelectionBinding(guitarrista: Guitarrista) -> Binding<Bool> {
        Binding(
            get: { guitarrista_id.contains(guitarrista.id.uuidString.lowercased()) },
            set: { isSelected in
                if isSelected {
                    guitarrista_id.append(guitarrista.id.uuidString.lowercased())
                } else {
                    guitarrista_id.removeAll { $0 == guitarrista.id.uuidString.lowercased() }
                }
            }
        )
    }

    private func sendGuitarra() {
        Task {
            do {
                try await guitarraLogic.saveGuitarra(modelo: modelo, descripcion: descripcion, ulr: path, fabricante_id: fabricante_id, guitarristas_id: guitarrista_id)
            } catch {
                print("Error al enviar la guitarra: \(error)")
            }
        }
    }
}

#Preview {
    AddGuitarraView()
}
