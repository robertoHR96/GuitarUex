//
//  ContentViewD.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 27/2/25.
//


//
//  ContentView.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 27/2/25.
//

import SwiftUI
struct ContentViewD: View{
    var body: some View {
        VStack {
            Text("Este es solo texto normal")
            Text("Esto con estilo **nevita**")
            Text("Esto con estilo *Itálico*")
            Text("Este con estilo ~Tachado~")
            Text("Este con `Monopace`")
            Text("Este con [Ir a Google](www.google.com) Enlace")
        }
    }
}

#Preview{
    ContentViewD()
}
