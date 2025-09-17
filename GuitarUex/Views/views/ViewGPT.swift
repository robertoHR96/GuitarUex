//  ViewGPT.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 27/2/25.
//

import SwiftUI

struct ViewGPT: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var scrollProxy: ScrollViewProxy? = nil

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) { // 🔹 ZStack para superponer el título
                VStack {
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack {
                                ForEach(viewModel.listaMensajes) { mensaje in
                                    HStack {
                                        if mensaje.role == "assistant" {
                                            Text(mensaje.content)
                                                .foregroundColor(.white)
                                                .padding(20)
                                                .background(.gray)
                                                .cornerRadius(20)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding()
                                                .padding(.top, 0)
                                                .padding(.trailing, 40)
                                        } else {
                                            Spacer()
                                            Text(mensaje.content)
                                                .foregroundColor(.white)
                                                .padding(20)
                                                .background(.green)
                                                .cornerRadius(20)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                                .padding()
                                                .padding(.top, 0)
                                                .padding(.leading, 40)
                                        }
                                    }
                                    .id(mensaje.id)
                                }
                            }
                            .padding(.top, 100) // 🔹 Espacio para el título flotante
                            //.padding(.bottom, 67)
                        }
                        .scrollDismissesKeyboard(.interactively)
                        .onAppear { self.scrollProxy = proxy }
                    }
                    InputChat(viewModel: viewModel, scrollProxy: scrollProxy)
                }
                
                // 🔹 Título flotante con fondo borroso
                VStack {
                    Text("Chat de Guitarras")
                        .font(.title2)
                        .bold()
                        .padding()
                        .padding(.top, 90)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial) // 🔹 Fondo difuminado
                        .shadow(radius: 5)
                    Spacer()
                }
                .frame(height: 60)
            }
            .edgesIgnoringSafeArea(.top) // 🔹 Para que el fondo llegue hasta arriba
        }
    }
}



#Preview {
    ViewGPT()
}
