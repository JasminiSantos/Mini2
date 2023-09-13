//
//  Map.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 24/08/23.
//

import UIKit

class Map {
    var currentX = 0
    var currentY = 0
    
    var rows: Int
    var columns: Int
    
    var rooms: [[Room]]
    var currentRoom: Room? = nil
    
    var contaminationConfig: [ContaminationConfig]
    
    init(rows: Int, columns: Int, contaminationConfig: [ContaminationConfig]) {
        self.rows = rows
        self.columns = columns
        self.contaminationConfig = contaminationConfig
        self.rooms = Map.generateRooms(rows: rows, columns: columns, contaminationConfig: self.contaminationConfig)
        self.currentRoom = getRoom(x: currentX, y: currentY)
    }

    func getRoom(x: Int, y: Int) -> Room {
        return rooms[x][y]
    }
    
    static func generateRooms(rows: Int, columns: Int, contaminationConfig: [ContaminationConfig]) -> [[Room]] {
        var rooms: [[Room]] = []
        var contaminationLevels: [Int] = []

        for config in contaminationConfig {
            contaminationLevels += Array(repeating: config.level, count: config.count)
        }

        while contaminationLevels.count < rows * columns {
            let randomLevel = Int.random(in: 2...4)
            contaminationLevels.append(randomLevel)
        }

        contaminationLevels.shuffle()

        for x in 0..<rows {
            var row: [Room] = []
            for y in 0..<columns {
                let room = Room(x: x, y: y)
//                print("x = \(x) y = \(y)")
                if x == 0 && y == 0 {
                    room.items = []
                    room.setItem(.bluePrint)
                    room.setItem(.radar)
                    room.puzzleImageName = Puzzles.none.puzzleImageName
                }
                else if x == 2 && y == 1 {
                    room.items = []
                    room.setItem(.frame)
                    room.setItem(.specialDoor)
                    room.setItem(.plant)
                    room.setItem(.chair)
                }
                else if x == 0 && y == 2 {
                    room.items = []
                    room.setItem(.document)
                    room.puzzleImageName = Puzzles.none.puzzleImageName
                }
                else if x == 0 && y == 1{
                    room.setPuzzle(.pipes)
                    room.puzzleImageName = Puzzles.pipes.puzzleImageName
                }
                else if x == 1 && y == 2 {
                    room.setPuzzle(.buttons)
                    room.puzzleImageName = Puzzles.buttons.puzzleImageName
                }
                else if x == 2 && y == 0 {
                    room.setPuzzle(.light)
                    room.puzzleImageName = Puzzles.light.puzzleImageName
                }
                else {
                    room.puzzleImageName = Puzzles.none.puzzleImageName
                    room.itemImageName.append(Item.none.itemImageName)
                }
                if x == 0 && (y == 0 || y == 1) {
                    room.setContaminationLevel(1)
                    if let index = contaminationLevels.firstIndex(of: 1) {
                        contaminationLevels.remove(at: index)
                    }
                } else {
                    room.setContaminationLevel(contaminationLevels.popLast() ?? 1)
                }
                
                row.append(room)
            }
            rooms.append(row)
        }

        return rooms
    }

    func move(direction: Direction) {
        switch direction {
            case .up:
                if currentX > 0 {
                    currentX -= 1
                }
            case .down:
                if currentX < rows - 1 {
                    currentX += 1
                }
            case .left:
                if currentY > 0 {
                    currentY -= 1
                }
            case .right:
                if currentY < columns - 1 {
                    currentY += 1
                }
        }
//        print("Moved to position: (\(currentX), \(currentY))")
        currentRoom = getRoom(x: currentX, y: currentY)
        let probability = monsterProbability(for: currentRoom?.getContaminationLevel() ?? 1)
        
        if !(currentRoom?.hasMonstro() ?? false) && Double.random(in: 0...1) < probability {
            currentRoom?.setMonstro()
            GameManager.shared.markGameAsFinished()
            print("There is a monster here!")
        }
    }

    func monsterProbability(for contaminationLevel: Int) -> Double {
        switch contaminationLevel {
            case 1:
                return 0.0
            case 2:
                return 0.01
            case 3:
                return 0.05
            case 4:
                return 0.15
            default:
                return 0.0
        }
    }

    func canMove(direction: Direction) -> Bool {
        switch direction {
            case .up:
                return currentX > 0
            case .down:
                return currentX < rows - 1
            case .left:
                return currentY > 0
            case .right:
                return currentY < columns - 1
        }
    }
}
