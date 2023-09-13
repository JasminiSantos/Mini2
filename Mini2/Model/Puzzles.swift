//
//  Puzzles.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 06/09/23.
//

import UIKit

enum Puzzles {
    case pipes
    case light
    case buttons
    case none
    
    var puzzleImageName: String {
        switch self {
            case .pipes:
                return "asset_puzzletubos_fechado"
            case .light:
                return "asset_puzzleluzes"
            case .buttons:
                return "asset_puzzlebotoes"
            case .none:
                return getRandomBackgroundImageName()
        }
    }
    private func getRandomBackgroundImageName() -> String {
        let backgroundImages = ["asset_cadeira", "asset_mesacompiuter", "asset_tubulacao"]
        return backgroundImages.randomElement() ?? "asset_tubulacao"
    }
    var puzzleUIImage: UIImage? {
        return UIImage(named: puzzleImageName)
    }
}
