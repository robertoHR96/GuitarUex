//
//  GuitarUexApp.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 21/2/25.
//

import SwiftUI

@main
struct GuitarUexApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authViewModel)
        }
    }
}
