//
//  Direction.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 25/08/23.
//

import UIKit

enum Direction {
    case up
    case down
    case left
    case right
    
    var imageName: String {
        switch self {
        case .up:
            return "asset_portameio_plantalhao"
        case .left:
            return "asset_portaesquerda_plantalhao"
        case .right:
            return "asset_portadireita_plantalhao"
        case .down:
            return "asset_portameio_plantalhao"
        }
    }
    
    var image: UIImage? {
        return UIImage(named: imageName)
    }
}

enum RadarQuadrant {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}
