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
    var lightBeam:          SKLightBeam!
    var mirror:             SKMirror!
    var rotatingMirror:     SKMirror?
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    var lastMirrorRotation: CGFloat?
    
    var completionPoint: CompletionPoint!
    var puzzleCompleted = false
    
    var collisionFound = false
    
    var lights = [SKLightBeam]()
    var mirror2: SKMirror!
    var mirror3: SKMirror!
    var mirror4: SKMirror!
    
    class CompletionPoint: SKSpriteNode {
        init(position: CGPoint, size: CGSize) {
            super.init(texture: nil, color: .green, size: size)
            self.position = position
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented.")
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        
        addLightBeam()
        addMirror()
        addCompletionPoint()
        addPanRecognizer()
        handleMirrorAndLightContact(mirror: mirror, lightBeam: lightBeam)
        lights.append(lightBeam)
    }
    
    func handleMirrorAndLightContact(mirror: SKMirror, lightBeam: SKLightBeam) {
        lightBeam.updateWithMirror(mirror: mirror)
    }

    func didGenerateNewLightBeam(_ lightBeam: SKLightBeam) {
        addChild(lightBeam)
        lights.append(lightBeam)
        collisionFound = true
    }
    
    private func addLightBeam() {
        let startPoint = CGPoint(x: frame.minX + 20, y: frame.midY)
        let endPoint   = CGPoint(x: frame.maxX - 20, y: frame.midY)
        
        lightBeam = SKLightBeam(startPoint: startPoint, endPoint: endPoint)
        addChild(lightBeam)
    }
    
    private func addMirror() {
        mirror = SKMirror(position: CGPoint(x: frame.midX, y: frame.midY + 10), size: CGSize(width: 10, height: 100), rotation: 0)
        mirror.zPosition = 64
        mirror.delegate = self
        
        mirror2 = SKMirror(position: CGPoint(x: frame.midX - 300, y: frame.midY - 150), size: CGSize(width: 10, height: 100), rotation: .pi / 4)
        mirror2.zPosition = 64
        mirror2.delegate = self
        
        mirror3 = SKMirror(position: CGPoint(x: frame.midX - 150, y: frame.midY + 150), size: CGSize(width: 10, height: 100), rotation: .pi / 4)
        mirror3.zPosition = 64
        mirror3.delegate = self
        
        mirror4 = SKMirror(position: CGPoint(x: frame.midX + 300, y: frame.midY - 110), size: CGSize(width: 10, height: 100), rotation: -.pi / 4)
        mirror4.zPosition = 64
        mirror4.delegate = self
        
        addChild(mirror)
        addChild(mirror2)
        addChild(mirror3)
        addChild(mirror4)
    }
    
    func addCompletionPoint() {
        completionPoint = CompletionPoint(position: CGPoint(x: frame.midX + 350, y: frame.midY + 100), size: CGSize(width: 50, height: 50))
        addChild(completionPoint)
    }
    
    private func addPanRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view?.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        lights.forEach { light in
            if light != lightBeam {
                light.removeFromParent()
            }
        }
        
        lights.removeAll(where: {$0 != lightBeam})
        
        let mirrors: [SKMirror]  = [mirror, mirror2, mirror3, mirror4]
        mirror.id = "m1"
        mirror2.id = "m2"
        mirror3.id = "m3"
        mirror4.id = "m4"
        
        var checkedPairs = Array<String>()
        var iterationCount = 0
        let maxIterations = 10
        
        
        repeat {
            collisionFound = false
            for mirror in mirrors {
                var id = 1
                for light in lights {
                    let pairKey = "\(mirror.id) - \(id)"
                    id += 1
                    if !Set(checkedPairs).contains(pairKey) {
                        handleMirrorAndLightContact(mirror: mirror, lightBeam: light)
                        if collisionFound {
                            checkedPairs.append(pairKey)
                        }
                    }
                }
            }
            iterationCount += 1
        } while collisionFound && iterationCount < maxIterations
        
        if lights.count == 1 {
            resetPath(lightBeam: lightBeam)
        }
        
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
        
        for light in lights {
            if handleCompletionPointAndLightContact(completionPoint: completionPoint, lightBeam: light) {
                puzzleCompleted = true
                break
            }
        }
        
        if puzzleCompleted {
            self.view?.removeGestureRecognizer(panGestureRecognizer)
            for light in lights {
                light.strokeColor = .green
            }
        }
    }
    
    func resetPath(lightBeam: SKLightBeam) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.minX + 20, y: frame.midY))
        path.addLine(to: CGPoint(x: frame.maxX - 20, y: frame.midY))
        lightBeam.path = path.cgPath
    }
    
    func handleCompletionPointAndLightContact(completionPoint: CompletionPoint, lightBeam: SKLightBeam) -> Bool {
        return lineIntersectsCircle(
            start: lightBeam.startPoint,
            end: lightBeam.endPoint,
            center: completionPoint.position,
            radius: completionPoint.size.width / 2
        )
    }
    
    func lineIntersectsCircle(start: CGPoint, end: CGPoint, center: CGPoint, radius: CGFloat) -> Bool {
        let d = end - start
        let f = start - center

        let a = dot(d, d)
        let b = 2.0 * dot(f, d)
        let c = dot(f, f) - radius * radius

        let discriminant = b * b - 4 * a * c

        if discriminant < 0 {
            return false
        }

        let discriminantSqrt = sqrt(discriminant)
        let t1 = (-b + discriminantSqrt) / (2 * a)
        let t2 = (-b - discriminantSqrt) / (2 * a)

        if (t1 >= 0 && t1 <= 1) || (t2 >= 0 && t2 <= 1) {
            return true
        }

        return false
    }


    func dot(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        return a.x * b.x + a.y * b.y
    }
}

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}
