//
//  RoomViewController.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/08/23.
//

import UIKit

class RoomViewController: UIViewController {
    var backgroundImageView: UIImageView!
    var radar: Radar!
    var map = Map(rows: 3, columns: 3, contaminationConfig: [
        ContaminationConfig(level: 1, count: 2),
        ContaminationConfig(level: 2, count: 4),
        ContaminationConfig(level: 3, count: 2),
        ContaminationConfig(level: 4, count: 1)
    ])
    
    var upDoor: UIButton!
    var downDoor: UIButton!
    var rightDoor: UIButton!
    var leftDoor: UIButton!
    
    var topLeftRadarButton: UIButton!
    var topRightRadarButton: UIButton!
    var bottomLeftRadarButton: UIButton!
    var bottomRightRadarButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        radar = Radar(map: map)
        let doorsFrame = CGRect(x: view.center.x - 50, y: view.center.y - 50, width: 100, height: 100)
        setBackgroundImage(named: "fundo_todasportas")
        setupDirectionButtons(frame: doorsFrame)
//        let doors = Doors(centerX: view.center.x, centerY: view.center.y)
//        view.addSubview(doors)
        setupRadarButtons()
    }
    
    func createButton(frame: CGRect, title: String, action: Selector) -> UIButton {
        let button = UIButton(frame: frame)
        button.addTarget(self, action: action, for: .touchUpInside)
        view.addSubview(button)
        return button
    }
    
    func setupDirectionButtons(frame: CGRect) {
        let buttonSize: CGFloat = frame.size.width
        let padding: CGFloat = 20
        
        let centerX = view.center.x
        let centerY = view.center.y
        
        upDoor = createButton(frame: CGRect(x: centerX - buttonSize/2, y: centerY - buttonSize/2 - padding, width: buttonSize, height: buttonSize), title: "upDoor", action: #selector(downButtonTapped))

        downDoor = createButton(frame: CGRect(x: centerX - buttonSize/2, y: centerY + padding, width: buttonSize, height: buttonSize), title: "downDoor", action: #selector(upButtonTapped))
        
        leftDoor = createButton(frame: CGRect(x: centerX/4 - padding, y: (centerY - buttonSize/2) + padding, width: buttonSize, height: buttonSize*2), title: "leftDoor", action: #selector(rightButtonTapped))
        rightDoor = createButton(frame: CGRect(x: centerX*1.5 + padding, y: (centerY - buttonSize/2) + padding, width: buttonSize, height: buttonSize*2), title: "rightDoor", action: #selector(leftButtonTapped))
        
        updateButtonVisibility()
    }

    func updateButtonVisibility() {
        downDoor.isHidden = !map.canMove(direction: .up)
        upDoor.isHidden = !map.canMove(direction: .down)
        rightDoor.isHidden = !map.canMove(direction: .left)
        leftDoor.isHidden = !map.canMove(direction: .right)
        updateBackgroundBasedOnVisibleButtons()
    }
    
    func updateBackgroundBasedOnVisibleButtons() {
        if !downDoor.isHidden && !upDoor.isHidden && !rightDoor.isHidden && !leftDoor.isHidden {
            self.changeBackgroundImage(named: "fundo_todasportas")
            
        } else if !downDoor.isHidden && !upDoor.isHidden && !rightDoor.isHidden {
            self.changeBackgroundImage(named: "fundo_meiodireita")
            
        } else if !downDoor.isHidden && !upDoor.isHidden && !leftDoor.isHidden {
            self.changeBackgroundImage(named: "fundo_meioesquerda")
            
        } else if !downDoor.isHidden && !rightDoor.isHidden && !leftDoor.isHidden {
            self.changeBackgroundImage(named: "fundo_direitaesquerda")
            
        } else if !upDoor.isHidden && !rightDoor.isHidden && !leftDoor.isHidden {
            self.changeBackgroundImage(named: "fundo_todasportas")
            
        } else if !downDoor.isHidden && !upDoor.isHidden {
            self.changeBackgroundImage(named: "fundo_meio")
            
        } else if !rightDoor.isHidden && !leftDoor.isHidden {
            self.changeBackgroundImage(named: "fundo_direitaesquerda")
            
        } else if !downDoor.isHidden && !rightDoor.isHidden {
            self.changeBackgroundImage(named: "fundo_direita")
            
        } else if !downDoor.isHidden && !leftDoor.isHidden {
            self.changeBackgroundImage(named: "fundo_esquerda")
            
        } else if !upDoor.isHidden && !rightDoor.isHidden {
            self.changeBackgroundImage(named: "fundo_meiodireita")
            
        } else if !upDoor.isHidden && !leftDoor.isHidden {
            self.changeBackgroundImage(named: "fundo_meioesquerda")
            
        } else {
            self.changeBackgroundImage(named: "fundo_nada")
        }
    }

    @objc func upButtonTapped() {
        map.move(direction: .up)
        goToAnotherRoomAnimation()
    }

    @objc func downButtonTapped() {
        map.move(direction: .down)
        goToAnotherRoomAnimation()
    }

    @objc func leftButtonTapped() {
        map.move(direction: .left)
        goToAnotherRoomAnimation()
    }

    @objc func rightButtonTapped() {
        map.move(direction: .right)
        goToAnotherRoomAnimation()
    }
    
    func setBackgroundImage(named imageName: String){
        backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
    }
    
    func changeBackgroundImage(named imageName: String){
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
//    func addPuzzleImage(named imageName: String) {
//        let view = UIImageView(image: UIImage(named: imageName))
//
//        self.view.addSubview(view)
//    }
    
    func goToAnotherRoomAnimation(){
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0
        }) { _ in
            UIView.animate(withDuration: 0.5) {
                self.updateButtonVisibility()
                self.updateRadarButtons()
                self.view.alpha = 1
            }
        }
    }
    
    func setupRadarButtons() {
        let buttonSize: CGSize = CGSize(width: 100, height: 50)
        let padding: CGFloat = 20

        topLeftRadarButton = createButton(frame: CGRect(x: padding, y: padding, width: buttonSize.width, height: buttonSize.height), title: "Top Left", action: #selector(topLeftRadarTapped))
        topRightRadarButton = createButton(frame: CGRect(x: padding, y: view.bounds.height - buttonSize.height - padding, width: buttonSize.width, height: buttonSize.height), title: "Top Right", action: #selector(topRightRadarTapped))
        bottomLeftRadarButton = createButton(frame: CGRect(x: view.bounds.width - buttonSize.width - padding, y: padding, width: buttonSize.width, height: buttonSize.height), title: "Bottom Left", action: #selector(bottomLeftRadarTapped))
        bottomRightRadarButton = createButton(frame: CGRect(x: view.bounds.width - buttonSize.width - padding, y: view.bounds.height - buttonSize.height - padding, width: buttonSize.width, height: buttonSize.height), title: "Bottom Right", action: #selector(bottomRightRadarTapped))
        
        topLeftRadarButton.backgroundColor = .blue
        topRightRadarButton.backgroundColor = .blue
        bottomLeftRadarButton.backgroundColor = .blue
        bottomRightRadarButton.backgroundColor = .blue
        
        self.updateRadarButtons()
    }
    
    func setColorsForButton(_ button: UIButton, contaminationLevel: Int) {
        
        let cleanColor = UIColor.gray
        let contaminatedColor = UIColor.green
        
        switch contaminationLevel {
        case 1:
            button.backgroundColor = cleanColor
            button.setBackgroundImage(nil, for: .normal)  // clear background image
            button.setTitleColor(UIColor.black, for: .normal)
        case 2, 3:
            button.setBackgroundImage(createHalfColoredImage(color1: contaminatedColor, color2: cleanColor), for: .normal)
            button.backgroundColor = nil  // clear solid color
            button.setTitleColor(UIColor.black, for: .normal)
        case 4:
            button.backgroundColor = contaminatedColor
            button.setBackgroundImage(nil, for: .normal)  // clear background image
            button.setTitleColor(UIColor.black, for: .normal)
        default:
            button.backgroundColor = cleanColor
            button.setBackgroundImage(nil, for: .normal)  // clear background image
            button.setTitleColor(UIColor.black, for: .normal)
        }
    }


    func createHalfColoredImage(color1: UIColor, color2: UIColor) -> UIImage? {
        let size = CGSize(width: 100, height: 50)
        UIGraphicsBeginImageContext(size)
        
        color1.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width / 2, height: size.height))
        
        color2.setFill()
        UIRectFill(CGRect(x: size.width / 2, y: 0, width: size.width / 2, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

    
    func displayContaminationLevels(_ levels: [Int?], for button: UIButton) {
        if let highestContamination = levels.compactMap({ $0 }).max() {
            setColorsForButton(button, contaminationLevel: highestContamination)
        } else {
            setColorsForButton(button, contaminationLevel: 0)
        }
    }

    func updateRadarButtons() {
        displayContaminationLevels(radar.topLeftQuadrantContamination(), for: topLeftRadarButton)
        displayContaminationLevels(radar.topRightQuadrantContamination(), for: topRightRadarButton)
        displayContaminationLevels(radar.bottomLeftQuadrantContamination(), for: bottomLeftRadarButton)
        displayContaminationLevels(radar.bottomRightQuadrantContamination(), for: bottomRightRadarButton)
    }

    @objc func topLeftRadarTapped() {
        let levels = radar.topLeftQuadrantContamination()
        displayContaminationLevels(levels, for: topLeftRadarButton)
    }

    @objc func topRightRadarTapped() {
        let levels = radar.topRightQuadrantContamination()
        displayContaminationLevels(levels, for: topRightRadarButton)
    }

    @objc func bottomLeftRadarTapped() {
        let levels = radar.bottomLeftQuadrantContamination()
        displayContaminationLevels(levels, for: bottomLeftRadarButton)
    }

    @objc func bottomRightRadarTapped() {
        let levels = radar.bottomRightQuadrantContamination()
        displayContaminationLevels(levels, for: bottomRightRadarButton)
    }


    func displayContaminationLevels(_ levels: [Int?]) {
        let message = levels.map { "\($0 ?? -1)" }.joined(separator: ", ")
        let alert = UIAlertController(title: "Contamination Levels", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
