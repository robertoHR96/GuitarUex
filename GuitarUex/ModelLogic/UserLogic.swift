//
//  UserLogic.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 24/2/25.
//


import SwiftUI

@MainActor
final class UserLogic: ObservableObject {
    let persistenceUser: PersitenIteratorUser
    @Published var user: User
    
    @Published var isLoading = false
    // Inicialización
    init(persistenceBanda: PersitenIteratorUser = APIClientUser(baseURL: URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:XcbPCCrw/userLog")!)) {
        self.persistenceUser = persistenceBanda
        self.user = User(id: UUID(), createdAt: Date(), email: "", name: "", isAdmin: false)
    }
    func logoutUser() {
        self.user = User(id: UUID(), createdAt: Date(), email: "", name: "", isAdmin: false)
    }
    // Método para cargar los datos del usuario
    func loadUser() async {
        self.isLoading=true

        do {
            let loadedUser = try await persistenceUser.loadUser()
            self.user = loadedUser
            self.isLoading=false
        } catch {
            print("Error al cargar el usuario: \(error)")
            self.isLoading=false
            self.user = User(id: UUID(), createdAt: Date(), email: "", name: "", isAdmin: false)
        }
    }
}
