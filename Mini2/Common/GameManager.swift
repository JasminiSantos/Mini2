//
//  GameManager.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 06/09/23.
//

import UIKit
import Combine

public class GameManager {
    static let shared = GameManager()
    
    var isRadarEquipped = false
    var hasGameStarted = false
    var isSwitchOn = false

    private(set) var isPuzzleLightCompleted: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    private(set) var isPuzzlePipesCompleted: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    private(set) var isPuzzleButtonsCompleted: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    private(set) var hasPickedFlower: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    private(set) var shouldAddFlowerToComputer: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    private(set) var hasAddedFlowerToComputer: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    private(set) var isGameOver: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    func areAllPuzzlesCompleted() -> Bool {
        return isPuzzleLightCompleted.value && isPuzzlePipesCompleted.value && isPuzzleButtonsCompleted.value
    }
    
    func resetGame() {
        isRadarEquipped = false
        hasGameStarted = false
        isSwitchOn = false
        
        isPuzzleLightCompleted.value = false
        isPuzzlePipesCompleted.value = false
        isPuzzleButtonsCompleted.value = false
        hasPickedFlower.value = false
        shouldAddFlowerToComputer.value = false
        hasAddedFlowerToComputer.value = false
        isGameOver.value = false
    }
    
    func markPuzzleLightAsCompleted() {
        isPuzzleLightCompleted.value = true
    }
    
    func markPuzzlePipesAsCompleted() {
        isPuzzlePipesCompleted.value = true
    }
    
    func markPuzzleButtonsAsCompleted() {
        isPuzzleButtonsCompleted.value = true
    }
    
    func markFlowerAsPicked() {
        hasPickedFlower.value = true
    }
    
    func markFlowerAsAddable() {
        shouldAddFlowerToComputer.value = true
    }
    
    func markFlowerAsAdded() {
        shouldAddFlowerToComputer.value = false
        hasAddedFlowerToComputer.value = true
    }
    
    func markGameAsFinished() {
        isGameOver.value = true
    }
    func markRadarCompleted() {
        isRadarEquipped = true
    }
}
