//
//  ButtonPuzzleMatrixView.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 05/09/23.
//

import UIKit

class ButtonPuzzleMatrixView: UIView {
    
    var isAvailable: Bool = false
    var cellViews: [[UIView]] = []
    let numRows = 3
    let numCols = 4
    var cellWidth: CGFloat = 86
    var cellHeight: CGFloat = 64
    var currentRow: Int = 0
    var currentCol: Int = 0
    
    
    var greenBall: UIImageView!
    
    init(frame: CGRect, isAvailable: Bool) {
        self.isAvailable = isAvailable
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
                cell.alpha = 0.3
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
        greenBall = UIImageView(image: UIImage(named: "button-greenball"))
        greenBall.frame = CGRect(x: 0, y: 0, width: greenBall.frame.width / 4, height: greenBall.frame.height / 4)
        greenBall.alpha = isAvailable ? 1 : 0
        addSubview(greenBall)
    }
    
    func moveGreenBallTo(row: Int, col: Int) {
        var newX = CGFloat(col) * cellWidth + (cellWidth - greenBall.frame.width) / 2
        var newY = CGFloat(row) * cellHeight + (cellHeight - greenBall.frame.height) / 2
        
        if row == 0 && col == 2 {
            newX += 0.5
            newY += 6.5
        }
        
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
    
    func updateBall() {
        greenBall.alpha = isAvailable ? 1 : 0
    }
    
    func getCurrentPosition() -> (Int, Int) {
        return (currentRow, currentCol)
    }
}
