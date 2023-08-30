//
//  SKLightBeam.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 29/08/23.
//

import SpriteKit

class SKLightBeam: SKShapeNode {
    var startPoint: CGPoint
    var endPoint:   CGPoint
    var isReflecting: Bool?
    
    let id = UUID()
    
    init(startPoint: CGPoint, endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint   = endPoint
        super.init()
        
        updatePath()
    }
    
    init(startPoint: CGPoint, direction: CGVector) {
        self.startPoint = startPoint
        let scalar: CGFloat = 100.0
        self.endPoint = CGPoint(x: startPoint.x + direction.dx * scalar, y: startPoint.y + direction.dy * scalar)
        super.init()
        updatePath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePath() {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        self.path = path.cgPath
    }
    
    func updateDirectionAndStartPoint(newStartPoint: CGPoint, newDirection: CGVector) {
        self.startPoint = newStartPoint
        self.endPoint = CGPoint(x: startPoint.x + newDirection.dx * 100.0, y: startPoint.y + newDirection.dy * 100.0)
        
        updatePath()
    }

    
    func updateWithMirror(mirror: SKMirror) {
        let mirrorEndpoints = mirror.getMirrorEndpoints()
        let mirrorStart     = mirrorEndpoints.start
        let mirrorEnd       = mirrorEndpoints.end

        var ip: CGPoint?
        if let intersectionPoint = findIntersection(
            A1: mirrorStart,
            B1: mirrorEnd,
            A2: startPoint,
            B2: endPoint) {
                ip = intersectionPoint
                isReflecting = true
                endPoint = intersectionPoint
                mirror.didDetectLight(
                    incidentPoint: intersectionPoint,
                    incidentVector: CGVector(dx: endPoint.x - startPoint.x,
                                             dy: endPoint.y - startPoint.y))
            
                updatePath()
        } else {
            isReflecting = false
            resetPath()
        }
        
        print("\(id) Reflecting: \(isReflecting)")
    }
    
    func findIntersection(A1: CGPoint, B1: CGPoint, A2: CGPoint, B2: CGPoint) -> CGPoint? {
        let dA = CGVector(dx: B1.x - A1.x, dy: B1.y - A1.y)
        let dB = CGVector(dx: B2.x - A2.x, dy: B2.y - A2.y)
        
        let determinant = dA.dx * dB.dy - dA.dy * dB.dx
        
        if abs(determinant) < 1e-6 {
            // Linhas são paralelas
            return nil
        }
        
        let t = ((A2.x - A1.x) * dB.dy - (A2.y - A1.y) * dB.dx) / determinant
        let u = -((A1.x - A2.x) * dA.dy - (A1.y - A2.y) * dA.dx) / determinant
        
        if t >= 0 && t <= 1 && u >= 0 && u <= 1.3 {
            let intersectionPoint = CGPoint(
                x: A1.x + t * dA.dx,
                y: A1.y + t * dA.dy
            )
            return intersectionPoint
        }
        
        // O ponto de interseção está fora dos segmentos de linha
        return nil
    }
    
    func resetPath() {
        guard let parent else {
            return
        }
        endPoint = CGPoint(x: parent.frame.maxX, y: frame.midY)
        updatePath()
    }
}
