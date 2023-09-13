//
//  Item.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 12/09/23.
//

import UIKit

enum Item {
    case bluePrint
    case document
    case radar
    case none
    
    var itemImageName: String {
        switch self {
            case .bluePrint:
                return "Asset_BlueprintNoChao"
            case .document:
                return "Asset_DocumentoNoChao"
            case .radar:
                return "Asset_radarNoChão"
            case .none:
                return ""
        }
    }
    var itemInspectImageName: [String] {
        var items: [String] = []
        switch self {
            case .bluePrint:
                items = ["Asset_Blueprint_Aberto"]
            case .document:
                items = ["Asset_Doc1_Aberto", "Asset_Doc2_Aberto"]
            case .radar:
                items = ["Asset_radarNoChão"]
            case .none:
                return []
        }
        return items
    }
    private func getRandomBackgroundImageName() -> [String] {
        let backgroundImages = ["asset_cadeira", "asset_mesacompiuter", "asset_tubulacao"]
        return backgroundImages
    }
    var itemUIImage: UIImage? {
        return UIImage(named: itemImageName)
    }
}

class ItemInspector {
    private(set) var item: Item
    private var currentInspectIndex: Int = 0
    
    init(item: Item) {
        self.item = item
    }
    
    func nextInspectImage() -> UIImage? {
        if currentInspectIndex < item.itemInspectImageName.count - 1 {
            currentInspectIndex += 1
        }
        return currentInspectUIImage
    }

    func previousInspectImage() -> UIImage? {
        if currentInspectIndex > 0 {
            currentInspectIndex -= 1
        }
        return currentInspectUIImage
    }

    var currentInspectUIImage: UIImage? {
        guard item.itemInspectImageName.indices.contains(currentInspectIndex) else {
            return nil
        }
        return UIImage(named: item.itemInspectImageName[currentInspectIndex])
    }
}

