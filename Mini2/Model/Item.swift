//
//  Documents.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 12/09/23.
//

import UIKit

enum Documents {
    case bluePrint
    case document
    case none
    
    var puzzleImageName: String {
        switch self {
            case .bluePrint:
                return "Asset_BlueprintNoChao"
            case .document:
                return "Asset_Doc1_Aberto"
            case .none:
                return getRandomBackgroundImageName()
        }
    }
    private func getRandomBackgroundImageName() -> String {
        let backgroundImages = ["asset_cadeira", "asset_mesacompiuter", "asset_mesacompiuter", "asset_tubulacao"]
        return backgroundImages.randomElement() ?? "asset_tubulacao"
    }
    var puzzleUIImage: UIImage? {
        return UIImage(named: puzzleImageName)
    }
}
