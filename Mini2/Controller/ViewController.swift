//
//  ViewController.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 24/08/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDirectionButtons()
        let map = Map()
        map.populateMonstros()

        var currentRoom = map.getRoom(x: 0, y: 0)
        currentRoom = map.move(currentX: currentRoom.x, currentY: currentRoom.y, direction: "right")
        if currentRoom.hasMonstro() {
            print("Você encontrou um monstro!")
        }
    }
    
    func setupDirectionButtons() {
            let buttonSize: CGFloat = 50
            let padding: CGFloat = 20
            
            let centerX = view.center.x
            let centerY = view.center.y
            
            // Up Button
            let upButton = UIButton(frame: CGRect(x: centerX - buttonSize/2, y: centerY - buttonSize - padding, width: buttonSize, height: buttonSize))
            upButton.setTitle("Up", for: .normal)
            upButton.backgroundColor = .blue
            upButton.addTarget(self, action: #selector(upButtonTapped), for: .touchUpInside)
            view.addSubview(upButton)
            
            // Down Button
            let downButton = UIButton(frame: CGRect(x: centerX - buttonSize/2, y: centerY + padding, width: buttonSize, height: buttonSize))
            downButton.setTitle("Down", for: .normal)
            downButton.backgroundColor = .blue
            downButton.addTarget(self, action: #selector(downButtonTapped), for: .touchUpInside)
            view.addSubview(downButton)
            
            // Left Button
            let leftButton = UIButton(frame: CGRect(x: centerX - buttonSize - padding, y: centerY - buttonSize/2, width: buttonSize, height: buttonSize))
            leftButton.setTitle("Left", for: .normal)
            leftButton.backgroundColor = .blue
            leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
            view.addSubview(leftButton)
            
            // Right Button
            let rightButton = UIButton(frame: CGRect(x: centerX + padding, y: centerY - buttonSize/2, width: buttonSize, height: buttonSize))
            rightButton.setTitle("Right", for: .normal)
            rightButton.backgroundColor = .blue
            rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
            view.addSubview(rightButton)
        }
    
        @objc func upButtonTapped() {
            print("Up button tapped!")
        }
        
        @objc func downButtonTapped() {
            print("Down button tapped!")
        }
        
        @objc func leftButtonTapped() {
            print("Left button tapped!")
        }
        
        @objc func rightButtonTapped() {
            print("Right button tapped!")
        }


}

