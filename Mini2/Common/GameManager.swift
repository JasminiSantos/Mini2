//
//  GameManager.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 06/09/23.
//

import UIKit

public class GameManager {
    static let shared = GameManager()
    
    var isPuzzleLightCompleted: Bool = false
    var isPuzzlePipesCompleted: Bool = false
    var isPuzzleButtonsCompleted: Bool = false
    var isRadarEquipped: Bool = false
    
    func areAllPuzzlesCompleted() -> Bool {
        return isPuzzleLightCompleted && isPuzzlePipesCompleted && isPuzzleButtonsCompleted
    }
    
    func markPuzzleLightAsCompleted() {
        isPuzzleLightCompleted = true
    }
    
    func markPuzzlePipesAsCompleted() {
        isPuzzlePipesCompleted = true
    }
    
    func markPuzzleButtonsAsCompleted() {
        isPuzzleButtonsCompleted = true
    }
    func markRadarCompleted() {
        isRadarEquipped = true
    }
}
