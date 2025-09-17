//
//  GuitarTunerView.swift
//  GuitarUex
//
//  Created by Roberto Hermoso Rivero on 28/2/25.
//


import SwiftUI
import AVFoundation

struct GuitarTunerView: View {
    @StateObject private var audioAnalyzer = AudioAnalyzer()
    private let targetFrequencies: [String: Double] = [
        "E2": 82.41, "A2": 110.00, "D3": 146.83,
        "G3": 196.00, "B3": 246.94, "E4": 329.63
    ]
    
    @State private var closestNote: String = ""
    @State private var deviationCents: Double = 0.0
    @State private var targetFrequency: Double = 0.0
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Nota objetivo:")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text(closestNote)
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(isTuned ? .green : .red)
                
                Text("\(String(format: "%.2f", audioAnalyzer.detectedFrequency)) Hz")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text(deviationString)
                    .font(.title3)
                    .foregroundColor(deviationColor)
                
                barraIndicacion
            }
            .padding(.vertical, 30)
            
            Button(action: toggleCapture) {
                Text(audioAnalyzer.isCapturing ? "Detener" : "Comenzar")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(audioAnalyzer.isCapturing ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding(.horizontal)
            }
        }
        .padding()
        .onChange(of: audioAnalyzer.detectedFrequency) { _ in
            updateTuningData()
        }
        .onAppear {
            audioAnalyzer.requestMicrophonePermission()
        }
    }
    
    private var barraIndicacion: some View {
        ZStack {
            // Línea central
            Rectangle()
                .frame(width: 3, height: 50)
                .foregroundColor(.gray)
            
            // Escala
            HStack(spacing: 15) {
                ForEach(-4...4, id: \.self) { tick in
                    VStack {
                        Rectangle()
                            .frame(width: 1, height: 15)
                            .foregroundColor(.gray)
                        Text(tick != 0 ? "\(abs(tick * 25))" : "")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(width: 300)
            
            // Aguja
            Rectangle()
                .frame(width: 3, height: 40)
                .foregroundColor(.blue)
                .offset(x: CGFloat(deviationCents) * 3)
        }
        .frame(height: 80)
    }
    
    private var deviationString: String {
        guard abs(deviationCents) > 1 else { return "Afinado ✓" }
        return String(format: "%+.0f cents", deviationCents)
    }
    
    private var deviationColor: Color {
        let absCents = abs(deviationCents)
        switch absCents {
        case 0...1: return .green
        case 1...5: return .yellow
        default: return .red
        }
    }
    
    private var isTuned: Bool {
        abs(deviationCents) < 5
    }
    
    private func updateTuningData() {
        let frequency = audioAnalyzer.detectedFrequency
        guard let closest = targetFrequencies.min(by: {
            abs($0.value - frequency) < abs($1.value - frequency)
        }) else { return }
        
        closestNote = closest.key
        targetFrequency = closest.value
        deviationCents = calculateCents(currentFrequency: frequency,
                                       targetFrequency: targetFrequency)
    }
    
    private func calculateCents(currentFrequency: Double, targetFrequency: Double) -> Double {
        guard targetFrequency > 0 else { return 0 }
        return 1200 * log2(currentFrequency / targetFrequency)
    }
    
    private func toggleCapture() {
        audioAnalyzer.isCapturing ? audioAnalyzer.stopAudioCapture() : audioAnalyzer.startAudioCapture()
    }
}

#Preview {
    GuitarTunerView()
}
