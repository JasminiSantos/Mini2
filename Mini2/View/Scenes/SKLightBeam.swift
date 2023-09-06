//
//  SKLightBeam.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 29/08/23.
//

import SpriteKit

class SKLightBeam: SKShapeNode {
    var id = ""
    var startPoint: CGPoint
    var endPoint:   CGPoint
    var direction:  CGVector
    
    var isReflecting = false
    
    init(startPoint: CGPoint, endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint   = endPoint
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let rawDirection = CGVector(dx: dx, dy: dy)
        let length = sqrt(rawDirection.dx * rawDirection.dx + rawDirection.dy * rawDirection.dy)
        self.direction = CGVector(dx: rawDirection.dx / length, dy: rawDirection.dy / length)

        
        super.init()
        self.strokeColor = .yellow
        self.lineWidth   = 5
        updatePath()
    }
    
    init(startPoint: CGPoint, direction: CGVector) {
        self.startPoint = startPoint
        self.endPoint = CGPoint(x: startPoint.x + direction.dx * 100.0, y: startPoint.y + direction.dy * 100.0)

        self.direction = direction
        
        super.init()
        self.strokeColor = .yellow
        self.lineWidth   = 5
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
    
    func updateWithMirror(mirror: SKMirror) {
        let mirrorEndpoints = mirror.getMirrorEndpoints()
        let mirrorStart     = mirrorEndpoints.start
        let mirrorEnd       = mirrorEndpoints.end

        if let intersectionPoint = findIntersection(
            A1: mirrorStart,
            B1: mirrorEnd,
            A2: startPoint,
            B2: endPoint) {
                endPoint = intersectionPoint
                mirror.didDetectLight(incidentPoint: intersectionPoint,
                                      incidentVector: CGVector(dx: endPoint.x - startPoint.x,
                                                               dy: endPoint.y - startPoint.y))
                updatePath()
        }
    }
    
    func findIntersection(A1: CGPoint, B1: CGPoint, A2: CGPoint, B2: CGPoint) -> CGPoint? {
        let dA = CGVector(dx: B1.x - A1.x, dy: B1.y - A1.y)
        let dB = CGVector(dx: B2.x - A2.x, dy: B2.y - A2.y)
        
        let determinant = dA.dx * dB.dy - dA.dy * dB.dx
        
        if abs(determinant) < 1e-6 {
            return nil
        }
        
        let t = ((A2.x - A1.x) * dB.dy - (A2.y - A1.y) * dB.dx) / determinant
        let u = -((A1.x - A2.x) * dA.dy - (A1.y - A2.y) * dA.dx) / determinant
        
        
        // mudei u de 0 para 0.001
        if t >= 0 && t <= 1 && u >= 0.001 && u <= 1.25 {
            let intersectionPoint = CGPoint(
                x: A1.x + t * dA.dx,
                y: A1.y + t * dA.dy
            )
            return intersectionPoint
        }
        
        return nil
    }
    
    func findIntersection(withMirror mirror: SKMirror) -> CGPoint? {
        let mirrorEndpoints = mirror.getMirrorEndpoints()
        let mirrorStart     = mirrorEndpoints.start
        let mirrorEnd       = mirrorEndpoints.end
        
        return findIntersection(A1: mirrorStart, B1: mirrorEnd, A2: startPoint, B2: endPoint)
    }
}
