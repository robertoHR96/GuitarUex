//
//  AudioAnalyzer.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 28/2/25.
//
//
//  AudioAnalyzer.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 28/2/25.
//
import Foundation
import AVFoundation

class AudioAnalyzer: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var fftAnalyzer = FFTAnalyzer()
    
    @Published var detectedFrequency: Double = 0.0
    @Published var isCapturing = false
    
    func startAudioCapture() {
        guard !isCapturing else { return }
        isCapturing = true
        
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 16384, format: format) { [weak self] buffer, _ in
            self?.fftAnalyzer.processAudioBuffer(buffer) { frequency in
                DispatchQueue.main.async {
                    self?.detectedFrequency = frequency
                }
            }
        }
        
        do {
            try audioEngine.start()
        } catch {
            print("Error al iniciar audio: \(error.localizedDescription)")
            isCapturing = false
        }
    }

    
    func stopAudioCapture() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        isCapturing = false
    }
    
    func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            print("Permiso de micrófono: \(granted ? "Concedido" : "Denegado")")
        }
    }
}
