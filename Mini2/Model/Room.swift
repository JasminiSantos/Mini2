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
    var items: [Item] = [.none]
    var level: Int
    
    var puzzleImageName: String = ""
    var itemImageName: [String] = []

    init(x: Int, y: Int, level: Int = 1) {
        self.x = x
        self.y = y
        self.level = level
        self.monster = false
        self.visited = false
        self.blocked = false
        self.puzzle = .none
        self.items = [.none]
    }
    
    init(x: Int, y: Int, level: Int = 1, puzzle: Puzzles, items: [Item]) {
        self.x = x
        self.y = y
        self.level = level
        self.puzzle = puzzle
        self.monster = false
        self.visited = false
        self.blocked = false
        self.items = items
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

    func setItem(_ item: Item) {
        self.items.append(item)
    }
    
    func setContaminationLevel(_ level: Int) {
        self.level = level
    }

    func getContaminationLevel() -> Int {
        return self.level
    }
}
