//
//  Item.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 12/09/23.
//

import UIKit

enum Item: Int {
    case bluePrint = 0
    case document
    case radar
    case frame
    case specialDoor
    case plant
    case chair
    case none
    
    var itemImageName: String {
        switch self {
            case .bluePrint:
                return "Asset_BlueprintNoChao"
            case .document:
                return "Asset_DocumentoNoChao"
            case .radar:
                return "Asset_radarNoChao"
            case .frame:
                return "Asset_quadroNoLugar"
            case .specialDoor:
                return "Asset_portaFinal"
            case .plant:
                return "Asset_plantinhaNaMesa"
            case .chair:
                return "asset_cadeira"
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
                items = ["Asset_radarNoChao"]
            case .frame:
                items = ["Asset_quadroNoLugar", "Asset_PainelOculto_Desligado", "Asset_PainelOculto_Ligado"]
            case .specialDoor:
                return ["Asset_portaFinal"]
            case .plant:
                return ["Asset_plantinhaNaMesa"]
            case .chair:
                return ["asset_cadeira"]
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

