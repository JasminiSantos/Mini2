//
//  LightPuzzleScene.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 27/08/23.
//

import SpriteKit

protocol SKMirrorDelegate: AnyObject {
    func didGenerateNewLightBeam(_ lightBeam: SKLightBeam)
}

class LightPuzzleScene: SKScene, SKPhysicsContactDelegate, SKMirrorDelegate {
//    var lightBeam:          SKLightBeam!
    var mirror:             SKMirror!
    var rotatingMirror:     SKMirror?
    var lastMirrorRotation: CGFloat?
    var firstUUID: UUID?
    
    var lightBeams: [UUID: SKLightBeam] = [:]
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero

        addFirstLightBeam()
        addMirror()
        addPanRecognizer()
        handleMirrorAndLightContact(mirror: mirror)
    }
    
    func handleMirrorAndLightContact(mirror: SKMirror) {
        for (_, beam) in lightBeams {
            beam.updateWithMirror(mirror: mirror)
        }
    }

    func didGenerateNewLightBeam(_ lightBeam: SKLightBeam) {
        addChild(lightBeam)
    }
    
    private func addFirstLightBeam() {
        let startPoint = CGPoint(x: frame.minX + 20, y: frame.midY)
        let endPoint   = CGPoint(x: frame.maxX - 20, y: frame.midY)
        
        let lightBeam = SKLightBeam(startPoint: startPoint, endPoint: endPoint)
        lightBeam.strokeColor = .yellow
        lightBeam.lineWidth   = 5
        
        firstUUID = lightBeam.id
        
        lightBeams[lightBeam.id] = lightBeam
        
        addChild(lightBeam)
    }
    
    func addLightBeam(_ beam: SKLightBeam) {
        lightBeams[beam.id] = beam
    }
    
    func removeInactiveBeams() {
        // Verificar raios que não estão refletindo
        for (id, lightBeam) in lightBeams {
            if !(lightBeam.isReflecting ?? false) && id != firstUUID {
                // Remover da cena
//                lightBeam.removeFromParent()
                
                // Remover da lista/array
//                lightBeams.removeValue(forKey: id)
                print("Remove light \(id)")
            }
        }
//        resetReflectionStatus()
    }

//    func resetReflectionStatus() {
//        for (_, lightBeam) in lightBeams {
//            lightBeam.isReflecting = false
//        }
//    }
    
    func findLightBeam(byID id: UUID) -> SKLightBeam? {
        return lightBeams[id]
    }

    private func addMirror() {
        mirror = SKMirror(position: CGPoint(x: frame.midX, y: frame.midY + 25), size: CGSize(width: 10, height: 100))
        mirror.delegate = self
        addChild(mirror)
    }
    
    private func addPanRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view?.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        handleMirrorAndLightContact(mirror: mirror)
        
        let touchLocation = gestureRecognizer.location(in: self.view)
        let touchPoint    = convertPoint(fromView: touchLocation)
        let touchedNodes  = nodes(at: touchPoint)

        for node in touchedNodes {
            if let rotatingMirror = node as? SKMirror {
                let dx = touchPoint.x - rotatingMirror.position.x
                let dy = touchPoint.y - rotatingMirror.position.y

                let angle = atan2(dy, dx)
                rotatingMirror.zRotation = angle - .pi / 2
            }
        }
        
        // removeInactiveBeams()
    }
}
