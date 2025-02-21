//
//  ViewUser.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//


import SwiftUI

struct ViewUser: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        VStack{
            Text("Cuenta").font(.title).fontWeight(.bold)
            Spacer()
            Button(action: {
                logout()
            }) {
                Text("Cerrar sesión")
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(6)
            .padding(.horizontal, 60)
            .padding(.top, 20)
            Spacer()
        }
    }
    func logout () {
        KeychainManager.shared.save(token: "")
    }
}
#Preview{
    ViewUser().environmentObject(AuthViewModel()) 
}
