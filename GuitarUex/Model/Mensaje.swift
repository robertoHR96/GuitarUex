//
//  Mensaje.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 27/2/25.
//


import Foundation

struct Mensaje: Identifiable, Hashable, Codable {
    let id = UUID() // Necesario para ForEach en la vista
    let role: String
    let content: String
}
