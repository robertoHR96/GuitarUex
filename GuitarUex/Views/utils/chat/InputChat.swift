//
//  InputChat.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 27/2/25.
//


import SwiftUI

struct InputChat: View {
    @ObservedObject var viewModel: ChatViewModel
    var scrollProxy: ScrollViewProxy?

    var body: some View {
        VStack {
            HStack {
                TextField("Mensaje a enviar", text: $viewModel.mensajeSend)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.bottom, 5)
                
                Button(action: {
                    viewModel.sendMessage(scrollProxy: scrollProxy)
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .clipShape(Circle())
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
        }
    }
}
