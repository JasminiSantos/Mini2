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
    
    func startBreathingHaptic() {
        do {
            // Iniciar o mecanismo háptico, se necessário
            try hapticEngine?.start()
            
            // Criar o padrão háptico
            var events = [CHHapticEvent]()
            
            // Primeiros 1.5 segundos: diminuir a intensidade
            for i in stride(from: 0, through: 1.5, by: 0.05) {
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i / 1.5))
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity], relativeTime: i)
                events.append(event)
            }
            
            // Seguintes 1.5 segundos: aumentar a intensidade
            for i in stride(from: 1.5, through: 3.0, by: 0.05) {
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float((i - 1.5) / 1.5))
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity], relativeTime: i)
                events.append(event)
            }
            
            let pauseTime = 0.5
            let pauseEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 1.5 + pauseTime)
            events.append(pauseEvent)
            
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            
            // Começar a tocar o padrão háptico
            try player?.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Falha ao criar feedback háptico: \(error)")
        }
    }
    
    func stopBreathingHaptic() {
        hapticEngine?.stop()
    }
}

