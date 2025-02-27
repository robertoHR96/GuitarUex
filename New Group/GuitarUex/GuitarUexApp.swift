//
//  GuitarUexApp.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//
import SwiftUI

@main
struct GuitarUexApp: App {
    @StateObject private var authManager = AuthViewModel()
    @StateObject private var userLogic = UserLogic()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(userLogic)
        }
    }
}
