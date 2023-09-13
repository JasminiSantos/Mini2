//
//  PipePuzzleScene.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 01/09/23.
//

import SpriteKit

class PipePuzzleScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "pipes-background")
    let backgroundFrame = SKSpriteNode(imageNamed: "Asset_versaoFinal_PzlCanos")
    let closedPanel = SKSpriteNode(imageNamed: "Asset_tampao_PzlTubos")
    
    private let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let rigidImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
    
    var grid: [[SKSpriteNode?]] = []
    let rows = 6
    let cols = 6
    
    override func didMove(to view: SKView) {
        if GameManager.shared.isPuzzlePipesCompleted.value {
            addBackground()
            addClosedPanel()
        } else {
            lightImpactFeedbackGenerator.prepare()
            rigidImpactFeedbackGenerator.prepare()
            addBackground()
            createGrid()
            shuffleGrid()
            addBackgroundFrame()
        }
    }
    
    private func addBackground() {
        background.size = frame.size
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
    }
    
    private func addBackgroundFrame() {
        backgroundFrame.size = frame.size
        backgroundFrame.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundFrame.zPosition = 26
        addChild(backgroundFrame)
    }
    
    private func addClosedPanel() {
        closedPanel.size = frame.size
        closedPanel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(closedPanel)
    }
    
    func addClosedPanelAnimated() {
        for i in 0..<rows {
            for j in 0..<cols {
                grid[i][j]?.zPosition = 10
            }
        }
        
        let initialPosition = CGPoint(x: -closedPanel.size.width / 2, y: frame.midY)
        let finalPosition = CGPoint(x: frame.midX, y: frame.midY)
        
        closedPanel.size = frame.size
        closedPanel.position = initialPosition
        closedPanel.zPosition = 25
        
        // Adicione o painel à cena
        addChild(closedPanel)
        
        // Calcula o número total de 'passos' que o painel tomará para se mover até sua posição final.
        let totalSteps = 50
        let dx = (finalPosition.x - initialPosition.x) / CGFloat(totalSteps)
        let dy = (finalPosition.y - initialPosition.y) / CGFloat(totalSteps)
        
        // Move o painel um pequeno incremento em cada iteração do loop
        var actions: [SKAction] = []
        for _ in 0..<totalSteps {
            let moveAction = SKAction.moveBy(x: dx, y: dy, duration: 0.05)
            actions.append(moveAction)
        }
        
        let sequence = SKAction.sequence(actions)
        
        closedPanel.run(sequence)
    }
    
    func createGrid() {
        let screenWidth = self.size.width
        let screenHeight = self.size.height
        
        let guaranteedPath = createGuaranteedPath()
        
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
                    startPipe.zPosition = 30
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
                    endPipe.zPosition = 30
                    self.addChild(endPipe)
                    continue
                }
                
                if let pipeInfo = guaranteedPath.first(where: { $0.row == row && $0.col == col }) {
                    // Este bloco cria um cano no caminho garantido
                    let pipeType = pipeInfo.pipe
                    var pipe: SKSpriteNode?
                    
                    if pipeType == .straight {
                        pipe = StraightPipe(isRotatable: true, isStart: false, isEnd: false)
                        
                    } else if pipeType == .elbow {
                        pipe = LPipe(isRotatable: true, isStart: false, isEnd: false)
                    }
                    
                    if let pipe = pipe {
                        pipe.position = CGPoint(x: xOffset + CGFloat(col * 55), y: yOffset + CGFloat(row * 55))
                        tempRow.append(pipe)
                        pipe.zPosition = 30
                        self.addChild(pipe)
                    }
                } else {
                    // Este bloco cria um cano aleatório que não está no caminho garantido
                    let pipe = createRandomPipe(isRotatable: true, isStart: false, isEnd: false) as! SKSpriteNode
                    pipe.position = CGPoint(x: xOffset + CGFloat(col * 55), y: yOffset + CGFloat(row * 55))
                    tempRow.append(pipe)
                    pipe.zPosition = 30
                    self.addChild(pipe)
                }
            }
            grid.append(tempRow)
        }
    }
    
    func shuffleGrid() {
        for row in 0..<rows {
            for col in 0..<cols {
                if let pipe = grid[row][col] as? StraightPipe {
                    for _ in 0...[0, 1, 2, 3].randomElement()! {
                        pipe.rotate()
                    }
                    
                } else if let pipe = grid[row][col] as? LPipe {
                    for _ in 0...[0, 1, 2, 3].randomElement()! {
                        pipe.rotate()
                    }
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !GameManager.shared.isPuzzlePipesCompleted.value {
            for t in touches {
                let location = t.location(in: self)
                let touchedNode = self.atPoint(location)
                
                if let pipe = touchedNode as? StraightPipe {
                    pipe.rotate()
                    
                } else if let pipe = touchedNode as? LPipe {
                    pipe.rotate()
                }
                
                lightImpactFeedbackGenerator.impactOccurred()
                
                if checkForCompletion(start: GridPosition(row: 0, col: 0)) {
                    simulateWaterFlow()
                    GameManager.shared.markPuzzlePipesAsCompleted()
                    self.isUserInteractionEnabled = false
                    addClosedPanelAnimated()
                }
            }
        }
    }

    func createGuaranteedPath() -> [(row: Int, col: Int, pipe: PipeType)] {
        var path: [(row: Int, col: Int, pipe: PipeType)] = []
        
        var prevRow = 0
        var prevCol = 0
        var currentRow = 0
        var currentCol = 0
        
        while currentRow < rows - 1 || currentCol < cols - 1 {
            let lastMoveVertical = currentRow != prevRow
            let lastMoveHorizontal = currentCol != prevCol
            
            // Salve os valores atuais para que possam ser comparados depois do próximo movimento
            prevRow = currentRow
            prevCol = currentCol
            
            let moveVertical = Bool.random()
            
            // Verifique se está na penúltima coluna e force um movimento horizontal
            if currentCol == cols - 2 && currentRow < rows - 1 {
                currentRow += 1
            }
            // Verifique se está na última coluna e na penúltima linha e force um movimento vertical
            else if currentCol == cols - 1 && currentRow == rows - 2 {
                currentRow += 1
            }
            // Caso contrário, mova-se normalmente
            else if moveVertical && currentRow < rows - 1 {
                currentRow += 1
            } else if currentCol < cols - 1 {
                currentCol += 1
            }
            
            let thisMoveVertical = currentRow != prevRow
            let thisMoveHorizontal = currentCol != prevCol
            
            var pipeType: PipeType = .straight
            
            if (lastMoveVertical && thisMoveHorizontal) || (lastMoveHorizontal && thisMoveVertical) {
                pipeType = .elbow
            }
            
            path.append((row: prevRow, col: prevCol, pipe: pipeType))
        }
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
            
            var directions: [PipeDirection] = []
            
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

    func direction(from pos1: GridPosition, to pos2: GridPosition) -> PipeDirection {
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

    func opposite(of direction: PipeDirection) -> PipeDirection {
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
    
    func simulateWaterFlow() {
        let steps = 51
        let timeIntervalBetweenSteps = 0.05
        
        for step in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(step) * timeIntervalBetweenSteps) {
                
                let intensity = Double(step) / Double(steps)
                
                self.rigidImpactFeedbackGenerator.impactOccurred(intensity: CGFloat(intensity))
                
                if step == steps {
                    self.rigidImpactFeedbackGenerator.impactOccurred(intensity: 1.0)
                }
            }
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
