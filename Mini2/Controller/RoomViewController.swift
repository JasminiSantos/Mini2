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
    var puzzleButton: UIButton!
    let completedPuzzles: Set<Puzzles> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radar = Radar(map: map)
        let doorsFrame = CGRect(x: view.center.x - 50, y: view.center.y - 50, width: 100, height: 100)
        setBackgroundImage(named: "fundo_todasportas")
        setupDirectionButtons(frame: doorsFrame)
        //        let doors = Doors(centerX: view.center.x, centerY: view.center.y)
        //        view.addSubview(doors)
        //        setupRadarButtons()
        
        if let contaminationLevel = radar.getMaxNearbyLevel() {
            HapticsController.shared.startRadarPulse(for: contaminationLevel)
        }
        updateRadarButtons()
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
        
        downDoor = createButton(frame: CGRect(x: centerX - buttonSize/2, y: centerY*1.75, width: buttonSize, height: buttonSize/2), title: "downDoor", action: #selector(upButtonTapped))
        
        leftDoor = createButton(frame: CGRect(x: centerX/4 - padding, y: (centerY - buttonSize/2) + padding, width: buttonSize, height: buttonSize*2), title: "leftDoor", action: #selector(rightButtonTapped))
        
        rightDoor = createButton(frame: CGRect(x: centerX*1.5 + padding, y: (centerY - buttonSize/2) + padding, width: buttonSize, height: buttonSize*2), title: "rightDoor", action: #selector(leftButtonTapped))
        
        puzzleButton = createButton(frame: CGRect(x: centerX - buttonSize/2, y: centerY*1.75, width: buttonSize, height: buttonSize/2), title: "downDoor", action: #selector(puzzleTapped))
        puzzleButton.backgroundColor = .blue
        
        updateButtonVisibility()
    }
    
    func updateButtonVisibility() {
        downDoor.isHidden = !map.canMove(direction: .up)
        upDoor.isHidden = !map.canMove(direction: .down)
        rightDoor.isHidden = !map.canMove(direction: .left)
        leftDoor.isHidden = !map.canMove(direction: .right)
        puzzleButton.isHidden = map.currentRoom?.puzzle == Puzzles.none || map.currentRoom == nil
        updateBackgroundBasedOnVisibleButtons()
    }
    
    func removeBackground(){
        backgroundImageView?.removeFromSuperview()
    }
    
    
    func updateBackgroundBasedOnVisibleButtons() {
        removeBackground()
        if !downDoor.isHidden && !upDoor.isHidden && !rightDoor.isHidden && !leftDoor.isHidden {
            self.setBackgroundImage(named: "fundo_todasportas")
            
        } else if !downDoor.isHidden && !upDoor.isHidden && !rightDoor.isHidden {
            self.setBackgroundImage(named: "fundo_meiodireita")
            
        } else if !downDoor.isHidden && !upDoor.isHidden && !leftDoor.isHidden {
            self.setBackgroundImage(named: "fundo_meioesquerda")
            
        } else if !downDoor.isHidden && !rightDoor.isHidden && !leftDoor.isHidden {
            self.setBackgroundImage(named: "fundo_direitaesquerda")
            
        } else if !upDoor.isHidden && !rightDoor.isHidden && !leftDoor.isHidden {
            self.setBackgroundImage(named: "fundo_todasportas")
            
        } else if !downDoor.isHidden && !upDoor.isHidden {
            self.setBackgroundImage(named: "fundo_meio")
            
        } else if !rightDoor.isHidden && !leftDoor.isHidden {
            self.setBackgroundImage(named: "fundo_direitaesquerda")
            
        } else if !downDoor.isHidden && !rightDoor.isHidden {
            self.setBackgroundImage(named: "fundo_direita")
            
        } else if !downDoor.isHidden && !leftDoor.isHidden {
            self.setBackgroundImage(named: "fundo_esquerda")
            
        } else if !upDoor.isHidden && !rightDoor.isHidden {
            self.setBackgroundImage(named: "fundo_meiodireita")
            
        } else if !upDoor.isHidden && !leftDoor.isHidden {
            self.setBackgroundImage(named: "fundo_meioesquerda")
            
        } else {
            self.setBackgroundImage(named: "fundo_nada")
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
        backgroundImageView = addBackgroundImage(named: imageName)
        
        let secondaryBackgroundImageView = addBackgroundImage(named: map.currentRoom?.puzzle.puzzleImageName ?? "")
        backgroundImageView.addSubview(secondaryBackgroundImageView)
        
        let radarImage = addBackgroundImage(named: "asset_radar")
        backgroundImageView.addSubview(radarImage)
        if let door = downDoor, !door.isHidden {
            let downImage = addBackgroundImage(named: "asset_botaosalasul")
            backgroundImageView.addSubview(downImage)
        }
        
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
    }
    
    
    func addBackgroundImage(named imageName: String)-> UIImageView{
        var imageBackground: UIImageView!
        imageBackground = UIImageView(frame: self.view.bounds)
        imageBackground.image = UIImage(named: imageName)
        imageBackground.contentMode = .scaleAspectFill
        imageBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return imageBackground
    }
    
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
    
    func goToPuzzle() {
        var nextViewController: UIViewController
        if let puzzle = map.currentRoom?.puzzle {
            switch puzzle {
            case .light:
                nextViewController = LightPuzzleViewController()
            case .pipes:
                nextViewController = PipePuzzleViewController()
            case .buttons:
                nextViewController = ButtonPuzzleViewController(isAvailable: completedPuzzles.contains(.pipes))
            case .none:
                nextViewController = RoomViewController()
            }
            
            if let navController = self.navigationController as? FadeNavigationController {
                navController.pushViewController(nextViewController, animated: true)
            }
        }
    }
    
    func setRadarImages(_ quadrant: RadarQuadrant, contaminationLevel: Int) {
        
        let commonImages = ["asset_interfaceSecundaria_vazia_1", "asset_interfaceSecundaria_vazia_2", "asset_interfaceSecundaria_vazia_3"]
        commonImages.forEach { backgroundImageView.addSubview(addBackgroundImage(named: $0)) }
        
        let imageMappings: [Int: [RadarQuadrant: String]] = [
            2: [
                .topLeft: "asset_interfaceprincipal_niveis2e3_1",
                .topRight: "asset_interfaceprincipal_niveis2e3_4",
                .bottomLeft: "asset_interfaceprincipal_niveis2e3_2",
                .bottomRight: "asset_interfaceprincipal_niveis2e3_3"
            ],
            3: [
                .topLeft: "asset_interfaceprincipal_niveis2e3_1",
                .topRight: "asset_interfaceprincipal_niveis2e3_4",
                .bottomLeft: "asset_interfaceprincipal_niveis2e3_2",
                .bottomRight: "asset_interfaceprincipal_niveis2e3_3"
            ],
            4: [
                .topLeft: "asset_interfaceprincipal_nivel4_1",
                .topRight: "asset_interfaceprincipal_nivel4_4",
                .bottomLeft: "asset_interfaceprincipal_nivel4_2",
                .bottomRight: "asset_interfaceprincipal_nivel4_3"
            ]
        ]
        
        if let imageName = imageMappings[contaminationLevel]?[quadrant] {
            backgroundImageView.addSubview(addBackgroundImage(named: imageName))
        }
    }
    
    
    func displayContaminationLevels(_ levels: [Int?], for quadrant: RadarQuadrant) {
        if let highestContamination = levels.compactMap({ $0 }).max() {
            setRadarImages(quadrant, contaminationLevel: highestContamination)
        } else {
            setRadarImages(quadrant, contaminationLevel: 0)
        }
    }
    
    func updateRadarButtons() {
        
        HapticsController.shared.stopRadarPulse()
        
        displayContaminationLevels(radar.topLeftQuadrantContamination(), for: .topLeft)
        displayContaminationLevels(radar.topRightQuadrantContamination(), for: .topRight)
        displayContaminationLevels(radar.bottomLeftQuadrantContamination(), for: .bottomLeft)
        displayContaminationLevels(radar.bottomRightQuadrantContamination(), for: .bottomRight)
        
        if let contaminationLevel = radar.getMaxNearbyLevel() {
            HapticsController.shared.startRadarPulse(for: contaminationLevel)
        }
    }
    
    @objc
    func puzzleTapped() {
        goToPuzzle()
    }
    
    func displayContaminationLevels(_ levels: [Int?]) {
        let message = levels.map { "\($0 ?? -1)" }.joined(separator: ", ")
        let alert = UIAlertController(title: "Contamination Levels", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
