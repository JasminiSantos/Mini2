//
//  PipePuzzleScene.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 01/09/23.
//

import SpriteKit

class PipePuzzleScene: SKScene {
    
    var grid: [[SKSpriteNode?]] = []
    let rows = 5
    let cols = 5
    
    override func didMove(to view: SKView) {
        createGrid()
    }
    
    func createGrid() {
        let screenWidth = self.size.width
        let screenHeight = self.size.height
        
        let gridWidth = CGFloat(cols * 55)
        let gridHeight = CGFloat(rows * 55)
        
        let xOffset = (screenWidth - gridWidth) / 2.0 + 25
        let yOffset = (screenHeight - gridHeight) / 2.0 + 25
        
        for row in 0..<rows {
            var tempRow: [SKSpriteNode?] = []
            for col in 0..<cols {
                
                if row == 0 && col == 0 {
                    let startPipe = PointPipe(isRotatable: false, isStart: true, isEnd: false)
                    startPipe.position = CGPoint(
                        x: xOffset + CGFloat(col * 55),
                        y: yOffset + CGFloat(row * 55)
                    )
                    tempRow.append(startPipe)
                    self.addChild(startPipe)
                    continue
                }
                
                if row == rows - 1 && col == cols - 1 {
                    let endPipe = PointPipe(isRotatable: false, isStart: false, isEnd: true)
                    endPipe.position = CGPoint(
                        x: xOffset + CGFloat(col * 55),
                        y: yOffset + CGFloat(row * 55)
                    )
                    tempRow.append(endPipe)
                    self.addChild(endPipe)
                    continue
                }
                
                let pipe = createRandomPipe(isRotatable: true, isStart: false, isEnd: false) as! SKSpriteNode
                
                pipe.position = CGPoint(
                    x: xOffset + CGFloat(col * 55),
                    y: yOffset + CGFloat(row * 55)
                )
                tempRow.append(pipe)
                self.addChild(pipe)
            }
            grid.append(tempRow)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let touchedNode = self.atPoint(location)
            
            if let pipe = touchedNode as? StraightPipe {
                pipe.rotate()
                
            } else if let pipe = touchedNode as? LPipe {
                pipe.rotate()
            }
            
            if checkForCompletion(start: GridPosition(row: 0, col: 0)) {
                backgroundColor = .green
            }
        }
    }

    func createGuaranteedPath() -> [(row: Int, col: Int, pipe: PipeType)] {
        var path: [(row: Int, col: Int, pipe: PipeType)] = []
        var currentRow = 0
        var currentCol = 0

        while currentRow < rows - 1 || currentCol < cols - 1 {
            let moveVertical = Bool.random()
            
            if moveVertical && currentRow < rows - 1 {
                path.append((row: currentRow, col: currentCol, pipe: .straight))
                currentRow += 1
            } else if currentCol < cols - 1 {
                path.append((row: currentRow, col: currentCol, pipe: .straight))
                currentCol += 1
            }
        }
        
        // O último ponto deve ser o ponto final, você pode ajustar o último tipo de cano se necessário.
        path.append((row: rows - 1, col: cols - 1, pipe: .straight))
        
        return path
    }
    
    func checkForCompletion(start: GridPosition) -> Bool {
        var toVisit = [start]
        var visited = Set<GridPosition>()
        
        while !toVisit.isEmpty {
            let current = toVisit.removeLast()
            
            visited.insert(current)
            
            let row = current.row
            let col = current.col
            var pipe: Rotatable?
            
            var directions: [Direction] = []
            
            if let currentPipe = grid[row][col] as? Rotatable {
                directions = currentPipe.getPossibleDirections()
                pipe = currentPipe
            }
            
            for direction in directions {
                var nextCell: GridPosition?

                switch direction {
                case .up:
                    nextCell = GridPosition(row: row - 1, col: col)

                case .down:
                    nextCell = GridPosition(row: row + 1, col: col)
                    
                case .left:
                    nextCell = GridPosition(row: row, col: col - 1)
                    
                case .right:
                    nextCell = GridPosition(row: row, col: col + 1)
                    
                }

                if let next = nextCell,
                   next.row >= 0, next.row < grid.count, // Verifique os limites de 'row'
                   next.col >= 0, next.col < grid[next.row].count, // Verifique os limites de 'col'
                   !visited.contains(next),
                   let nextPipe = grid[next.row][next.col] as? Rotatable,
                   canConnect(from: pipe!, at: current, to: nextPipe, at: next) {
                        toVisit.append(next)
                }

            }
        }
        
        return visited.contains(GridPosition(row: rows - 1, col: cols - 1))
    }

    func canConnect(from pipe1: Rotatable, at pos1: GridPosition, to pipe2: Rotatable, at pos2: GridPosition) -> Bool {
        let directionFrom1To2 = direction(from: pos1, to: pos2)
        let directionFrom2To1 = opposite(of: directionFrom1To2)

        return pipe1.getPossibleDirections().contains(directionFrom1To2) && pipe2.getPossibleDirections().contains(directionFrom2To1)
    }

    func direction(from pos1: GridPosition, to pos2: GridPosition) -> Direction {
        if pos1.row == pos2.row {
            if pos1.col < pos2.col {
                return .right
            } else {
                return .left
            }
        } else if pos1.col == pos2.col {
            if pos1.row < pos2.row {
                return .down
            } else {
                return .up
            }
        }
        
        // Poderia lançar um erro aqui, uma vez que as posições não são adjacentes
        fatalError("Positions are not adjacent")
    }

    func opposite(of direction: Direction) -> Direction {
        switch direction {
        case .up:
            return .down
        case .down:
            return .up
        case .left:
            return .right
        case .right:
            return .left
        }
    }
    
    func createRandomPipe(isRotatable: Bool, isStart: Bool, isEnd: Bool) -> Rotatable {
        let randomIndex = Int.random(in: 0...1)
        
        switch randomIndex {
        case 0:
            return StraightPipe(isRotatable: isRotatable, isStart: isStart, isEnd: isEnd)
        case 1:
            return LPipe(isRotatable: isRotatable, isStart: isStart, isEnd: isEnd)
        default:
            fatalError("Invalid randomIndex")
        }
    }
}

struct GridPosition: Hashable {
    var row: Int
    var col: Int
}

enum PipeType {
    case straight
    case elbow
}
