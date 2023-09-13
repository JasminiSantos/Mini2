//
//  RoomViewController.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/08/23.
//

import UIKit

class RoomViewController: UIViewController, PuzzleViewControllerDelegate {
    public var gameManager: GameManager!
    
    var backgroundImageView: UIImageView!
    var radarImage: UIImageView!
    
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
    var itemButton: UIButton!
    
    var isInspecting = false
    var inspectionImageView: UIImageView?
    var currentPage = 0
    var itemImages: [UIImage] = []
    
    let completedPuzzles: Set<Puzzles> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showView()
    }
    
    func showView(){
        radar = Radar(map: map)
        radarImage = UIImageView()
        
        let doorsFrame = CGRect(x: view.center.x - 50, y: view.center.y - 50, width: 100, height: 100)
        setBackgroundImage(named: "fundo_todasportas")
        setupDirectionButtons(frame: doorsFrame)
        
        navigationItem.hidesBackButton = true
    }
    
    func setupRadar(){
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
        
        puzzleButton = createButton(frame: CGRect(x: centerX/2 - padding, y: centerY/2, width: buttonSize*1.5, height: buttonSize*2), title: "downDoor", action: #selector(puzzleTapped))

        itemButton = createButton(frame: CGRect(x: centerX - buttonSize/2, y: centerY*1.35, width: buttonSize, height: buttonSize), title: "downDoor", action: #selector(inspectItem))
        
        updateButtonVisibility()
    }
    
    func updateButtonVisibility() {
        downDoor.isHidden = !map.canMove(direction: .up)
        upDoor.isHidden = !map.canMove(direction: .down)
        rightDoor.isHidden = !map.canMove(direction: .left)
        leftDoor.isHidden = !map.canMove(direction: .right)
        puzzleButton.isHidden = map.currentRoom?.puzzle == Puzzles.none || map.currentRoom == nil
        itemButton.isHidden = map.currentRoom?.items.count == 0
        updateBackgroundBasedOnVisibleButtons()
    }
    
    func removeBackground(){
        radarImage = UIImageView()
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

    @objc func inspectItem() {
        isInspecting = true
        
        itemImages = map.currentRoom?.items.first?.itemInspectImageName.compactMap {
            UIImage(named: $0)
        } ?? []
        
        inspectionImageView = addBackgroundImage(named: map.currentRoom?.items.first?.itemInspectImageName.first ?? "")
        inspectionImageView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height) // Ou onde você quiser que ela apareça
        inspectionImageView?.isUserInteractionEnabled = true
        view.addSubview(inspectionImageView!)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(turnPage))
        inspectionImageView?.addGestureRecognizer(tapGesture)
    }
    @objc func turnPage() {
        currentPage += 1

        if currentPage >= itemImages.count {
            endInspection()
        } else {
            inspectionImageView?.image = itemImages[currentPage]
        }
    }
    func endInspection() {
        isInspecting = false
        currentPage = 0
        inspectionImageView?.removeFromSuperview()
        inspectionImageView = nil
        
        if let currentRoom = map.currentRoom,
           currentRoom.x == 0 && currentRoom.y == 0,
           currentRoom.items.contains(where: { $0 == .radar }) {
            GameManager.shared.isRadarEquipped = true
            setupRadar()
        }
    }

    
    func setBackgroundImage(named imageName: String){
        backgroundImageView = addBackgroundImage(named: imageName)

        if let room = map.currentRoom, !room.hasMonstro() {
            if let puzzle = map.currentRoom?.puzzle, let image = map.currentRoom?.puzzleImageName {
                backgroundImageView.addSubview(addBackgroundImage(named: image))
            }
            
            if let items = map.currentRoom?.items {
                for item in items {
                    backgroundImageView.addSubview(addBackgroundImage(named: item.itemImageName))
                }
            }

            if let door = downDoor, !door.isHidden {
                let downImage = addBackgroundImage(named: "asset_botaosalasul")
                backgroundImageView.addSubview(downImage)
            }
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
        HapticsController.shared.stopRadarPulse()
        
        if let contaminationLevel = radar.getMaxNearbyLevel() {
            HapticsController.shared.startRadarPulse(for: contaminationLevel)
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0
        }) { _ in
            UIView.animate(withDuration: 0.5) {
                if let room = self.map.currentRoom, room.hasMonstro() {
                    self.setMonsterScene()
                }
                else {
                    self.updateButtonVisibility()
                    if GameManager.shared.isRadarEquipped {
                        self.updateRadarButtons()
                    }
                    self.view.alpha = 1
                }
                
            }
        }
    }
    
    func setMonsterScene() {
        backgroundImageView.subviews.forEach({ $0.removeFromSuperview() })
        removeBackground()
        
        UIView.animate(withDuration: 5, animations: {
            self.view.alpha = 1
        }) { _ in
            self.setBackgroundImage(named: "Asset_teladoPlantalhao")
            if GameManager.shared.isRadarEquipped {
                self.setupRadar()
            }
            UIView.animate(withDuration: 5) {
                self.view.alpha = 0
            }
        }
    }

    
    func goToPuzzle() {
        var nextViewController: UIViewController
        if let puzzle = map.currentRoom?.puzzle {
            switch puzzle {
            case .light:
                let lightPuzzleVC = LightPuzzleViewController()
                lightPuzzleVC.delegate = self
                nextViewController = lightPuzzleVC
            case .pipes:
                let pipePuzzleVC = PipePuzzleViewController()
                pipePuzzleVC.delegate = self
                nextViewController = pipePuzzleVC
            case .buttons:
                let buttonPuzzleVC = ButtonPuzzleViewController(isAvailable: GameManager.shared.isPuzzlePipesCompleted)
                buttonPuzzleVC.delegate = self
                nextViewController = buttonPuzzleVC
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
            let image = addBackgroundImage(named: imageName)
            radarImage.addSubview(image)
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
        backgroundImageView.addSubview(addBackgroundImage(named: "asset_radar"))
        
        displayContaminationLevels(radar.topLeftQuadrantContamination(), for: .topLeft)
        displayContaminationLevels(radar.topRightQuadrantContamination(), for: .topRight)
        displayContaminationLevels(radar.bottomLeftQuadrantContamination(), for: .bottomLeft)
        displayContaminationLevels(radar.bottomRightQuadrantContamination(), for: .bottomRight)
        
        backgroundImageView.addSubview(radarImage)
        
        if let contaminationLevel = radar.getMaxNearbyLevel() {
            startBlinkingRadar(duration: getInterval(contaminationLevel: contaminationLevel))
        }
    }
    
    func getInterval(contaminationLevel: Int) -> Double{
        var interval: Double
        if contaminationLevel == 5 {
            interval = 0.25
        }
        else if contaminationLevel == 4 || contaminationLevel == 3 {
            interval = 0.8
        } else {
            interval = 2
        }
        
        return interval
    }
    func startBlinkingRadar(duration: Double) {
        UIView.animate(withDuration: duration, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.radarImage.alpha = 0.5
        }, completion: nil)
    }
    func stopBlinkingRadar() {
        self.radarImage.layer.removeAllAnimations()
        self.radarImage.alpha = 1.0
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
    
    func puzzleViewControllerDidRequestExit(_ viewController: UIViewController) {
        navigationController?.popViewController(animated: true)
    }
}
