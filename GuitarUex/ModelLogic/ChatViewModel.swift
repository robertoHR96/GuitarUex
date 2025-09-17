//
//  ChatViewModel.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 27/2/25.
//


import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var listaMensajes: [Mensaje] = [
        Mensaje(role: "assistant", content: "Hola, soy tu asistente experto en guitarras.")
    ]
    @Published var mensajeSend = ""
    
    private let urlString = "http://192.168.1.76:1234/v1/chat/completions"
    
    // Envía el mensaje del usuario y obtiene la respuesta del asistente
    func sendMessage(scrollProxy: ScrollViewProxy?) {
        guard !mensajeSend.isEmpty else { return }
        
        let mensajeUsuario = Mensaje(role: "user", content: mensajeSend)
        appendMessage(mensajeUsuario)
        mensajeSend = ""  // Limpiar el campo de entrada

        scrollToBottom(scrollProxy)

        let requestBody = createRequestBody()
        
        performRequest(with: requestBody) { [weak self] response in
            guard let self = self else { return }
            
            if let content = self.extractResponseContent(from: response) {
                self.appendMessage(Mensaje(role: "assistant", content: content))
                self.scrollToBottom(scrollProxy)
            } else {
                print("Error al obtener el contenido de la respuesta.")
            }
        }
    }

    // Función para crear el cuerpo de la solicitud JSON
    private func createRequestBody() -> [String: Any] {
        return [
            "model": "llama-3.2-3b-instruct",
            "messages": listaMensajes.map { ["role": $0.role, "content": $0.content] },
            "max_tokens": 150
        ]
    }
    
    // Realiza la solicitud a la API
    private func performRequest(with body: [String: Any], completion: @escaping ([String: Any]?) -> Void) {
        guard let url = URL(string: urlString),
              let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Error al crear la URL o serializar JSON")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error en la petición: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Error: No se recibió datos.")
                completion(nil)
                return
            }
            
            let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            completion(response)
        }.resume()
    }
    
    // Extrae el contenido de la respuesta de la API
    private func extractResponseContent(from response: [String: Any]?) -> String? {
        guard let choices = response?["choices"] as? [[String: Any]],
              let firstChoice = choices.last,
              let message = firstChoice["message"] as? [String: String] else {
            return nil
        }
        return message["content"]
    }
    
    // Añade un mensaje a la lista de mensajes
    private func appendMessage(_ mensaje: Mensaje) {
        listaMensajes.append(mensaje)
    }

    // Función para hacer scroll al último mensaje
    private func scrollToBottom(_ scrollProxy: ScrollViewProxy?) {
        guard let lastMessage = listaMensajes.last else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            scrollProxy?.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}
