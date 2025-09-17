import AVFoundation
import Accelerate

class FFTAnalyzer {
    private let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    private let a4Frequency: Double = 440.0
    private let midiA4Note: Int = 69
    
    func processAudioBuffer(_ buffer: AVAudioPCMBuffer, completion: @escaping (Double) -> Void) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameCount = Int(buffer.frameLength)
        let sampleRate = buffer.format.sampleRate
        
        let log2n = vDSP_Length(log2(Double(frameCount)))
        guard let fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2)) else { return }
        
        var window = [Float](repeating: 0, count: frameCount)
        vDSP_hann_window(&window, vDSP_Length(frameCount), Int32(vDSP_HANN_NORM))
        
        var windowedData = [Float](repeating: 0, count: frameCount)
        vDSP_vmul(channelData, 1, window, 1, &windowedData, 1, vDSP_Length(frameCount))
        
        var real = [Float](repeating: 0, count: frameCount/2)
        var imag = [Float](repeating: 0, count: frameCount/2)
        var complexBuffer = DSPSplitComplex(realp: &real, imagp: &imag)
        
        windowedData.withUnsafeBytes {
            let ptr = $0.bindMemory(to: DSPComplex.self)
            vDSP_ctoz(ptr.baseAddress!, 2, &complexBuffer, 1, vDSP_Length(frameCount/2))
        }
        
        vDSP_fft_zrip(fftSetup, &complexBuffer, 1, log2n, FFTDirection(FFT_FORWARD))
        
        var magnitudes = [Float](repeating: 0, count: frameCount/2)
        vDSP_zvmags(&complexBuffer, 1, &magnitudes, 1, vDSP_Length(frameCount/2))
        
        vDSP_destroy_fftsetup(fftSetup)
        
        let maxMagnitude = magnitudes.max() ?? 1.0
        let normalizedMagnitudes = magnitudes.map { $0 / maxMagnitude }
        
        if let peakIndex = findFundamentalFrequency(normalizedMagnitudes, sampleRate: sampleRate) {
                   let frequency = calculateFrequency(peakIndex: peakIndex,
                                                      magnitudes: magnitudes,
                                                      sampleRate: sampleRate,
                                                      frameCount: frameCount)
                   
                   completion(frequency)
               }
           }
    
    private func findFundamentalFrequency(_ magnitudes: [Float], sampleRate: Double) -> Int? {
        let minFrequency = 65.0
        let maxFrequency = 440.0
        let minIndex = Int(minFrequency * Double(magnitudes.count) / (sampleRate / 2))
        let maxIndex = Int(maxFrequency * Double(magnitudes.count) / (sampleRate / 2))
        
        guard maxIndex < magnitudes.count else { return nil }
        
        var maxValue: Float = 0.0
        var peakIndex = 0
        
        (minIndex..<maxIndex).forEach { index in
            if magnitudes[index] > maxValue {
                maxValue = magnitudes[index]
                peakIndex = index
            }
        }
        
        return peakIndex
    }
    
    private func calculateFrequency(peakIndex: Int, magnitudes: [Float], sampleRate: Double, frameCount: Int) -> Double {
        let baseFrequency = Double(peakIndex) * sampleRate / Double(frameCount)
        guard peakIndex > 0, peakIndex < magnitudes.count - 1 else { return baseFrequency }
        
        let left = magnitudes[peakIndex - 1]
        let center = magnitudes[peakIndex]
        let right = magnitudes[peakIndex + 1]
        
        // Simplificar la expresión para evitar el error de tiempo de compilación
        let numerator = right - left
        let denominator = 2 * center - left - right
        let correction = 0.5 * (numerator / denominator)
        
        return (Double(peakIndex) + Double(correction)) * sampleRate / Double(frameCount)
    }
    
    // Función para convertir frecuencia a nota
    private func frequencyToNote(frequency: Double) -> (String, Double) {
        let midiNote = Double(midiA4Note) + 12 * log2(frequency / a4Frequency)
        let roundedMidi = Int(round(midiNote))
        let noteIndex = (roundedMidi % 12 + 12) % 12
        let octave = (roundedMidi / 12) - 1
        
        let noteName = noteNames[noteIndex]
        let calculatedFrequency = a4Frequency * pow(2, Double(roundedMidi - midiA4Note) / 12.0)
        
        return ("\(noteName)\(octave)", calculatedFrequency)
    }
}
