//
//  ButtonPuzzleMatrixView.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 05/09/23.
//

import UIKit

class ButtonPuzzleMatrixView: UIView {
    
    var cellViews: [[UIView]] = []
    let numRows = 3
    let numCols = 4
    var cellWidth: CGFloat = 50
    var cellHeight: CGFloat = 50
    var currentRow: Int = 0
    var currentCol: Int = 0
    
    
    var greenBall: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMatrix()
        setupGreenBall()
        resetBall()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMatrix() {
        for row in 0..<numRows {
            var cellRow: [UIView] = []
            for col in 0..<numCols {
                let cell = UIView()
                cell.backgroundColor = .red // ou qualquer outra cor
                cell.frame = CGRect(x: CGFloat(col) * cellWidth,
                                    y: CGFloat(row) * cellHeight,
                                    width: cellWidth,
                                    height: cellHeight)
                addSubview(cell)
                cellRow.append(cell)
            }
            cellViews.append(cellRow)
        }
    }
    
    private func setupGreenBall() {
        greenBall = UIImageView(image: UIImage(systemName: "circle")) // substitua "greenBall" pelo nome do seu asset
        greenBall.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight) // posição inicial
        addSubview(greenBall)
    }
    
    func moveGreenBallTo(row: Int, col: Int) {
        let newX = CGFloat(col) * cellWidth
        let newY = CGFloat(row) * cellHeight
        greenBall.frame.origin = CGPoint(x: newX, y: newY)
        
        currentRow = row
        currentCol = col
    }
    
    func moveBallDown() {
        var newRow = currentRow + 2
        if newRow >= numRows { newRow = numRows - 1 }
        moveGreenBallTo(row: newRow, col: currentCol)
    }
    
    func moveBallUpLeft() {
        var newRow = currentRow - 2
        if newRow < 0 { newRow = 0 }

        var newCol = currentCol - 1
        if newCol < 0 { newCol = 0 }

        moveGreenBallTo(row: newRow, col: newCol)
    }

    func moveBallUpRight() {
        var newRow = currentRow - 1
        if newRow < 0 { newRow = 0 }

        var newCol = currentCol + 1
        if newCol >= numCols { newCol = numCols - 1 }

        moveGreenBallTo(row: newRow, col: newCol)
    }
    
    func moveBallRightDown() {
        var newCol = currentCol + 1
        if newCol >= numCols { newCol = numCols - 1 }

        var newRow = currentRow + 1
        if newRow >= numRows { newRow = numRows - 1 }

        moveGreenBallTo(row: newRow, col: newCol)
    }
    
    func moveBallRightUp() {
        var newCol = currentCol + 1
        if newCol >= numCols { newCol = numCols - 1 }

        var newRow = currentRow - 1
        if newRow < 0 { newRow = 0 }

        moveGreenBallTo(row: newRow, col: newCol)
    }
    
    func resetBall() {
        moveGreenBallTo(row: 1, col: 0)
    }
}
