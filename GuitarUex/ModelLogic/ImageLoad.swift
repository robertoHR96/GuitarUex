//
//  ImageLoad.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 26/2/25.
//

import Combine
import SwiftUI

@MainActor
final class ImageLoad: ObservableObject{
    
    @Published var imagen = Image(systemName: "guitars")
    var suscribe = Set<AnyCancellable>()
    
    func getImage(url:URL){
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .compactMap{UIImage(data: $0)}
            .map {Image(uiImage: $0)}
            .replaceEmpty(with: Image(systemName:"guitars"))
            .replaceError(with: Image(systemName:"guitars"))
            .assign(to: \.imagen , on: self)
            .store(in: &suscribe)
    }
}
