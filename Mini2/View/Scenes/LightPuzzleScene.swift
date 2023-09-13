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
    let background = SKSpriteNode(imageNamed: "light-background")
    let backgroundFrame = SKSpriteNode(imageNamed: "light-frame")
    let closedPanel = SKSpriteNode(imageNamed: "Asset_tampao_PzlLuzes")
    
    var lightBeam:          SKLightBeam!
    var mirror:             SKMirror!
    var rotatingMirror:     SKMirror?
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    private let softImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    private let rigidImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
    
    var lastMirrorRotation: CGFloat?
    
    var completionPoint: CompletionPoint!
    var puzzleCompleted = false
    var isPanelAdded = false
    
    var collisionFound = false
    
    var lights = [SKLightBeam]()
    var mirror2: SKMirror!
    var mirror3: SKMirror!
    var mirror4: SKMirror!
    
    class CompletionPoint: SKSpriteNode {
        var startPoint: CGPoint
        var endPoint:   CGPoint
        
        init(position: CGPoint, size: CGSize) {
            self.startPoint = position
            self.endPoint = CGPoint(x: position.x + size.width, y: position.y + size.height)
            super.init(texture: nil, color: .clear, size: size)
            self.position = position
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented.")
        }
    }
    
    override func didMove(to view: SKView) {
        if !GameManager.shared.isPuzzleLightCompleted.value {
            
            physicsWorld.contactDelegate = self
            physicsWorld.gravity = .zero
            
            softImpactFeedbackGenerator.prepare()
            rigidImpactFeedbackGenerator.prepare()
            
            addBackground()
            addLightBeam()
            addMirror()
            addCompletionPoint()
            addPanRecognizer()
            handleMirrorAndLightContact(mirror: mirror, lightBeam: lightBeam)
            lights.append(lightBeam)
            addBackgroundFrame()
        } else {
            addPanel()
            addBackgroundFrame()
        }
    }
    
    func handleMirrorAndLightContact(mirror: SKMirror, lightBeam: SKLightBeam) {
        lightBeam.updateWithMirror(mirror: mirror)
    }

    func addPanel() {
        closedPanel.size = frame.size
        closedPanel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(closedPanel)
    }
    
    func addPanelAnimated() {
        if isPanelAdded {
            return
        }
        
        for light in lights {
            light.zPosition = 10
        }
        
        mirror.zPosition = 10
        mirror2.zPosition = 10
        mirror4.zPosition = 10
        
        let initialPosition = CGPoint(x: -closedPanel.size.width / 2, y: frame.midY)
        let finalPosition = CGPoint(x: frame.midX, y: frame.midY)
        
        closedPanel.size = frame.size
        closedPanel.position = initialPosition
        closedPanel.zPosition = 25
        
        // Adicione o painel à cena
        addChild(closedPanel)
        
        // Calcula o número total de 'passos' que o painel tomará para se mover até sua posição final.
        let totalSteps = 50
        let dx = (finalPosition.x - initialPosition.x) / CGFloat(totalSteps)
        let dy = (finalPosition.y - initialPosition.y) / CGFloat(totalSteps)
        
        // Move o painel um pequeno incremento em cada iteração do loop
        var actions: [SKAction] = []
        for _ in 0..<totalSteps {
            let moveAction = SKAction.moveBy(x: dx, y: dy, duration: 0.05)
            actions.append(moveAction)
        }
        
        let sequence = SKAction.sequence(actions)
        
        closedPanel.run(sequence)
    }
    
    func didGenerateNewLightBeam(_ lightBeam: SKLightBeam) {
        addChild(lightBeam)
        lights.append(lightBeam)
        collisionFound = true
    }
    
    private func addBackground() {
        background.size = frame.size
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
    }
    
    private func addBackgroundFrame() {
        backgroundFrame.size = frame.size
        backgroundFrame.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundFrame.zPosition = 100
        addChild(backgroundFrame)
    }
    
    private func addLightBeam() {
        let startPoint = CGPoint(x: frame.minX + 20, y: frame.midY)
        let endPoint   = CGPoint(x: frame.maxX - 20, y: frame.midY)
        
        lightBeam = SKLightBeam(startPoint: startPoint, endPoint: endPoint)
        addChild(lightBeam)
    }
    
    private func addMirror() {
        mirror = SKMirror(position: CGPoint(x: frame.midX, y: frame.midY - 25), size: CGSize(width: 10, height: 100), rotation: 0)
        mirror.zPosition = 64
        mirror.delegate = self
        
        mirror2 = SKMirror(position: CGPoint(x: frame.midX - 300, y: frame.midY - 100), size: CGSize(width: 10, height: 100), rotation: .pi / 4)
        mirror2.zPosition = 64
        mirror2.delegate = self
        
        mirror4 = SKMirror(position: CGPoint(x: frame.midX + 140, y: frame.midY + 110), size: CGSize(width: 10, height: 100), rotation: -.pi / 4)
        mirror4.zPosition = 64
        mirror4.delegate = self
        
        addChild(mirror)
        addChild(mirror2)
        addChild(mirror4)
    }
    
    func addCompletionPoint() {
        completionPoint = CompletionPoint(position: CGPoint(x: frame.maxX * 0.86, y: frame.maxY * 0.72), size: CGSize(width: 5, height: 26))
        addChild(completionPoint)
    }
    
    private func addPanRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view?.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if !GameManager.shared.isPuzzleLightCompleted.value {
            let touchLocation = gestureRecognizer.location(in: self.view)
            let touchPoint    = convertPoint(fromView: touchLocation)
            let touchedNodes  = nodes(at: touchPoint)
            
            for node in touchedNodes {
                if let rotatingMirror = node as? SKMirror {
                    let dx = touchPoint.x - rotatingMirror.position.x
                    let dy = touchPoint.y - rotatingMirror.position.y
                    
                    let angle = atan2(dy, dx)
                    rotatingMirror.zRotation = angle - .pi / 2
                    softImpactFeedbackGenerator.impactOccurred(intensity: 0.5)
                }
            }
            
            lights.forEach { light in
                if light != lightBeam {
                    light.removeFromParent()
                }
            }
            
            lights.removeAll(where: {$0 != lightBeam})
            
            let mirrors: [SKMirror]  = [mirror, mirror2, mirror4]
            mirror.id = "m1"
            mirror2.id = "m2"
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
            
            for light in lights {
                let cp = handleCompletionPointAndLightContact(completionPoint: completionPoint, lightBeam: light)
                if cp != nil {
                    self.view?.removeGestureRecognizer(panGestureRecognizer)
                    lights.last!.endPoint = cp!
                    lights.last!.updatePath()
                    puzzleCompleted = true
                    GameManager.shared.markPuzzleLightAsCompleted()
                    break
                }
            }
            
            if puzzleCompleted {
                for light in lights {
                    light.strokeColor = .green
                }
                addPanelAnimated()
                performCompletionHaptics()
                isPanelAdded = true
            }
        }
    }
    
    func performCompletionHaptics() {
        let steps = 51
        let timeIntervalBetweenSteps = 0.05
        
        for step in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(step) * timeIntervalBetweenSteps) {
                
                let intensity = Double(step) / Double(steps)
                
                self.rigidImpactFeedbackGenerator.impactOccurred(intensity: CGFloat(intensity))
                
                if step == steps {
                    self.rigidImpactFeedbackGenerator.impactOccurred(intensity: 1.0)
                }
            }
        }
    }
    
    func resetPath(lightBeam: SKLightBeam) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.minX + 20, y: frame.midY))
        path.addLine(to: CGPoint(x: frame.maxX - 20, y: frame.midY))
        lightBeam.path = path.cgPath
    }
    
    func handleCompletionPointAndLightContact(completionPoint: CompletionPoint, lightBeam: SKLightBeam) -> CGPoint? {
        return lightBeam.findIntersection(A1: lightBeam.startPoint,
                                         B1: lightBeam.endPoint,
                                         A2: completionPoint.startPoint,
                                         B2: completionPoint.endPoint) ?? nil
    }
}

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}
