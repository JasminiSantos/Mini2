//
//  Doors.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 29/08/23.
//

import UIKit

class Doors: UIView {
    var upButton: UIButton!
    var downButton: UIButton!
    var leftButton: UIButton!
    var rightButton: UIButton!
    
    var doorSize: CGFloat = 50
    var padding: CGFloat = 20
    var centerX: CGFloat
    var centerY: CGFloat

    
    init(centerX: CGFloat, centerY: CGFloat) {
        self.centerX = centerX
        self.centerY = centerY
        super.init(frame: CGRect.zero) // Call super.init before using self
        self.setupDirectionButtons(frame: CGRect(x: 0, y: 0, width: doorSize, height: doorSize), centerX: centerX, centerY: centerY)
    }
    
    required init?(coder: NSCoder) {
        self.centerX = 0
        self.centerY = 0
        super.init(coder: coder)
    }
    
    private func createButton(title: String, frame: CGRect, action: Selector) -> UIButton {
        let button = UIButton(frame: frame)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .blue
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setupDirectionButtons(frame: CGRect, centerX: CGFloat, centerY: CGFloat) {
        let buttonSize: CGFloat = frame.size.width
        let padding: CGFloat = 20
            
        // Down Button (now at the top)
        downButton = createButton(title: "Up",
                                  frame: CGRect(x: centerX - buttonSize/2, y: centerY - buttonSize/2 - padding, width: buttonSize, height: buttonSize),
                                  action: #selector(doorTapped(_:)))
            
        // Up Button (now at the bottom)
        upButton = createButton(title: "Down",
                                frame: CGRect(x: centerX - buttonSize/2, y: centerY + padding, width: buttonSize, height: buttonSize),
                                action: #selector(doorTapped(_:)))
            
        // Right Button (now on the left side)
        rightButton = createButton(title: "Left",
                                   frame: CGRect(x: 0, y: centerY - buttonSize/2, width: buttonSize, height: buttonSize),
                                   action: #selector(doorTapped(_:)))
            
        // Left Button (now on the right side)
        leftButton = createButton(title: "Right",
                                  frame: CGRect(x: centerX + padding, y: centerY - buttonSize/2, width: buttonSize, height: buttonSize),
                                  action: #selector(doorTapped(_:)))
        
        self.addSubview(downButton)
        self.addSubview(upButton)
        self.addSubview(leftButton)
        self.addSubview(rightButton)

//        updateButtonVisibility()
    }
    
    
    private func createDoor(direction: Direction, x: CGFloat, y: CGFloat) -> UIButton {
        let door = createButtonWithImage(imageName: direction.imageName, fixedWidth: 150)
        door?.addTarget(self, action: #selector(doorTapped(_:)), for: .touchUpInside)
        return door ?? UIButton(frame: CGRect(x: x, y: y, width: doorSize, height: doorSize))
    }
    
    @objc private func doorTapped(_ sender: UIButton) {
        print("Button tapped: \(sender.currentTitle ?? "Unknown")")
    }
    
    private func createButtonWithImage(imageName: String, fixedWidth: CGFloat? = nil, fixedHeight: CGFloat? = nil) -> UIButton? {
        guard let image = UIImage(named: imageName) else {
            print("Error: Image not found!")
            return nil
        }
        
        let aspectRatio = image.size.width / image.size.height
        var buttonWidth: CGFloat
        var buttonHeight: CGFloat
        
        if let width = fixedWidth {
            buttonWidth = width
            buttonHeight = width / aspectRatio
        } else if let height = fixedHeight {
            buttonHeight = height
            buttonWidth = height * aspectRatio
        } else {
            print("Error: Either fixedWidth or fixedHeight must be provided!")
            return nil
        }
        

        let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        button.setImage(image, for: .normal)
        
        return button
    }
}

