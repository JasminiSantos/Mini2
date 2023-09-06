//
//  Room.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 24/08/23.
//

import UIKit

class Room {
    let x: Int
    let y: Int
    var monster: Bool
    var visited: Bool
    var blocked: Bool
    var puzzle: Puzzles = .none
    var item: Bool
    var level: Int
    
    private(set) var backgroundImageName: String = ""

    init(x: Int, y: Int, level: Int = 1) {
        self.x = x
        self.y = y
        self.level = level
        self.monster = false
        self.visited = false
        self.blocked = false
        self.puzzle = .none
        self.item = false
    }
    
    init(x: Int, y: Int, level: Int = 1, puzzle: Puzzles) {
        self.x = x
        self.y = y
        self.level = level
        self.puzzle = puzzle
        self.monster = false
        self.visited = false
        self.blocked = false
        self.item = false
        self.backgroundImageName = puzzle.puzzleImageName
    }

    func hasMonstro() -> Bool {
        return monster
    }

    func setMonstro() {
        self.monster = true
    }

    func setPuzzle(_ puzzle: Puzzles) {
        self.puzzle = puzzle
    }

    func setItem(_ item: Bool) {
        self.item = item
    }
    
    func setContaminationLevel(_ level: Int) {
        self.level = level
    }

    func getContaminationLevel() -> Int {
        return self.level
    }
}
