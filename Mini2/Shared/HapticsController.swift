//
//  HapticsController.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 05/09/23.
//

import CoreHaptics

class HapticsController {
    static let shared = HapticsController()
    
    private var hapticEngine: CHHapticEngine?
    private var continuousPlayer: CHHapticAdvancedPatternPlayer?
    private var radarTimer: Timer?
    
    private init() {
        do {
            hapticEngine = try CHHapticEngine()
        } catch let error {
            print("Haptic engine Creation Error: \(error)")
        }
    }
    
    var supportsHaptics: Bool {
        return CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
    
    func playHaptics(for contaminationLevel: Int) {
        guard supportsHaptics else { return }
        
        let hapticIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(contaminationLevel) / 100.0)
        
        let hapticEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [hapticIntensity], relativeTime: 0)
        
        do {
            let pattern = try CHHapticPattern(events: [hapticEvent], parameters: [])
            
            let player = try hapticEngine?.makePlayer(with: pattern)
            
            try hapticEngine?.start()
            
            try player?.start(atTime: 0)
        } catch let error {
            print("Haptic playback error: \(error)")
        }
    }
    
    func startContinuousHaptics(for contaminationLevel: Int) {
        guard supportsHaptics else { return }
        
        // Intensidade e frequência do haptic baseado no nível de contaminação
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(contaminationLevel) / 3.0)
        
        let hapticEvent = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity], relativeTime: 0, duration: 0.05)
        
        do {
            let pattern = try CHHapticPattern(events: [hapticEvent], parameters: [])
            continuousPlayer = try hapticEngine?.makeAdvancedPlayer(with: pattern)
            
            try hapticEngine?.start()
            
            continuousPlayer?.loopEnabled = true
            continuousPlayer?.loopEnd = 1
            
            try continuousPlayer?.start(atTime: 0)
        } catch let error {
            print("Haptic playback error: \(error)")
        }
    }
    
    func stopContinuousHaptics() {
        hapticEngine?.stop()
    }
    
    func playPulse() {
        do {
            // Certifique-se de que o motor está iniciado
            try hapticEngine?.start()

            // Criar um evento háptico intenso e curto
            let intenseSharpEvent = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                ],
                relativeTime: 0,
                duration: 0.05
            )

            // Criar um padrão com esse único evento
            let pattern = try CHHapticPattern(events: [intenseSharpEvent], parameters: [])

            // Criar um jogador com o padrão
            let player = try hapticEngine?.makePlayer(with: pattern)

            // Tocar o padrão
            try player?.start(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Erro ao tocar o padrão háptico: \(error)")
        }
    }
}

