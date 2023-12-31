//
//  SKPipe.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 01/09/23.
//

import SpriteKit

protocol Rotatable {
    func rotate()
    func getPossibleDirections() -> [PipeDirection]
}

enum PipeDirection {
    case up, down, left, right
}

class StraightPipe: SKSpriteNode, Rotatable {
    var isRotatable: Bool = true
    var isStart: Bool = false
    var isEnd: Bool = false
    var isFull: Bool = false
    
    class var defaultTexture: SKTexture {
        return SKTexture(imageNamed: "S_pipe")
    }
    
    required init(isRotatable: Bool, isStart: Bool, isEnd: Bool) {
        self.isRotatable = isRotatable
        self.isStart = isStart
        self.isEnd = isEnd
        super.init(texture: Self.defaultTexture, color: .clear, size: Self.defaultTexture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotate() {
        if isRotatable {
            self.zRotation += .pi / 2
            self.zRotation = self.zRotation.truncatingRemainder(dividingBy: 2 * .pi)
            
        }
    }
    
    func getPossibleDirections() -> [PipeDirection] {
        if self.zRotation < (.pi / 2) {
            return [.left, .right]
            
        } else if self.zRotation < .pi {
            return [.down, .up]
            
        } else if self.zRotation < (3 * .pi / 2) {
            return [.right, .left]
            
        } else {
            return [.up, .down]
        }
    }
}

class LPipe: SKSpriteNode, Rotatable {
    var isRotatable: Bool = true
    var isStart: Bool = false
    var isEnd: Bool = false
    var isFull: Bool = false
    
    class var defaultTexture: SKTexture {
        return SKTexture(imageNamed: "L_pipe")
    }
    
    required init(isRotatable: Bool, isStart: Bool, isEnd: Bool) {
        self.isRotatable = isRotatable
        self.isStart = isStart
        self.isEnd = isEnd
        super.init(texture: Self.defaultTexture, color: .clear, size: Self.defaultTexture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotate() {
        if isRotatable {
            self.zRotation += .pi / 2
            self.zRotation = self.zRotation.truncatingRemainder(dividingBy: 2 * .pi)
        }
    }
    
    func getPossibleDirections() -> [PipeDirection] {
        if self.zRotation < (.pi / 2) {
            return [.left, .up]
            
        } else if self.zRotation < .pi {
            return [.right, .up]
            
        } else if self.zRotation < (3 * .pi / 2) {
            return [.right, .down]
            
        } else {
            return [.left, .down]
        }
    }
}

class PointPipe: SKSpriteNode, Rotatable {
    var isRotatable: Bool = false
    var isStart: Bool = false
    var isEnd: Bool = false
    var isFull: Bool = false
    
    class var defaultTexture: SKTexture {
        return SKTexture(imageNamed: "Point_pipe")
    }
    
    required init(isRotatable: Bool, isStart: Bool, isEnd: Bool) {
        self.isRotatable = isRotatable
        self.isStart = isStart
        self.isEnd = isEnd
        super.init(texture: Self.defaultTexture, color: .clear, size: Self.defaultTexture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotate() {
        if isRotatable {
            self.zRotation += .pi / 2
        }
    }
    
    func getPossibleDirections() -> [PipeDirection] {
        return [.down, .left, .right, .up]
    }
}
