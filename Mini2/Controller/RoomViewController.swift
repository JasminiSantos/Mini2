//
//  RoomViewController.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/08/23.
//

import UIKit
import Combine

class RoomViewController: UIViewController, PuzzleViewControllerDelegate {
    var backgroundImageView: UIImageView!
    var radarImage: UIImageView!

    private let rigidImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
    private let heavyImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    var radar: Radar!
    var map = Map(rows: 3, columns: 3, contaminationConfig: [
        ContaminationConfig(level: 1, count: 2),
        ContaminationConfig(level: 2, count: 4),
        ContaminationConfig(level: 3, count: 2),
        ContaminationConfig(level: 4, count: 1)
    ])
    
    var upDoor:             UIButton!
    var downDoor:           UIButton!
    var rightDoor:          UIButton!
    var leftDoor:           UIButton!
    var puzzleButton:       UIButton!
    var pickFlowerButton:   UIButton!
    var itemButton:         UIButton!
    var frameButton: 	    UIButton!
    var endButton: 		    UIButton!
    
    var inspectionImageView: UIImageView?
    var currentPage = 0
    var itemImages: [UIImage] = []
    
    let completedPuzzles: Set<Puzzles> = []
    var pulseTimer: Timer?
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showView()
        setupSubscriptions()
    }
    
    func showView(){
        radar = Radar(map: map)
        radarImage = UIImageView()
        radarImage.layer.zPosition = 100
        
        let doorsFrame = CGRect(x: view.center.x - 50, y: view.center.y - 50, width: 100, height: 100)
        setBackgroundImage(named: "fundo_todasportas")
        setupDirectionButtons(frame: doorsFrame)
        
        navigationItem.hidesBackButton = true
        rigidImpactFeedbackGenerator.prepare()
        heavyImpactFeedbackGenerator.prepare()
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
        
        downDoor = createButton(frame: CGRect(x: centerX - buttonSize/2, y: centerY*1.65, width: buttonSize, height: buttonSize/1.5), title: "downDoor", action: #selector(upButtonTapped))
        
        leftDoor = createButton(frame: CGRect(x: centerX/4 - padding, y: (centerY - buttonSize/2) + padding, width: buttonSize, height: buttonSize*2), title: "leftDoor", action: #selector(rightButtonTapped))
        
        rightDoor = createButton(frame: CGRect(x: centerX*1.5 + padding, y: (centerY - buttonSize/2) + padding, width: buttonSize, height: buttonSize*2), title: "rightDoor", action: #selector(leftButtonTapped))
        
        puzzleButton = createButton(frame: CGRect(x: centerX/2 - padding, y: centerY/2, width: buttonSize*1.5, height: buttonSize*2), title: "puzzleButton", action: #selector(puzzleTapped))
        
        pickFlowerButton = createButton(frame: CGRect(x: centerX + 5 * padding, y: centerY/2 - padding, width: buttonSize*1.5, height: buttonSize*2), title: "flowerPod", action: #selector(flowerTapped))

        itemButton = createButton(frame: CGRect(x: centerX - buttonSize/2, y: centerY*1.25, width: buttonSize, height: buttonSize), title: "downDoor", action: #selector(inspectItem))
        
        frameButton = createButton(frame: CGRect(x: centerX + buttonSize + padding, y: centerY - buttonSize - padding, width: buttonSize, height: buttonSize), title: "frameButton", action: #selector(updateFinalItems))
        
        frameButton.isUserInteractionEnabled = GameManager.shared.isPuzzleLightCompleted.value
        
        endButton = createButton(frame: CGRect(x: centerX - buttonSize/2, y: centerY - buttonSize/2 - padding, width: buttonSize, height: buttonSize), title: "upDoor", action: #selector(completeGame))
        
        endButton.isUserInteractionEnabled = false
        
        updateButtonVisibility()
    }
    
    @objc
    func updateFinalItems() {
        if !GameManager.shared.didDropBoatFrame.value {
            if GameManager.shared.isPuzzleButtonsCompleted.value {
                GameManager.shared.markBoatFrameAsDropped()
                backgroundImageView.addSubview(addBackgroundImage(named: "Asset_quadroNoChao"))
                self.backgroundImageView.viewWithTag(999)?.removeFromSuperview()
                self.updateRadarButtons()
            }
            
        } else if !GameManager.shared.didTurnSwitchOn.value {
            if GameManager.shared.areAllPuzzlesCompleted() {
                GameManager.shared.markSwitchAsOn()
            }
        }
        
        let updatedRoom = map.updateFinalRoom()
        
        for (index, item) in updatedRoom.items.enumerated() {
            if let imageView = backgroundImageView.viewWithTag(index + 5) as? UIImageView {
                imageView.image = UIImage(named: item.itemImageName)
            }
        }
    }
    
    @objc
    func completeGame() {
        GameManager.shared.markGameAsFinished()
        goToAnotherRoomAnimation()
    }
    
    func updateButtonVisibility() {
        downDoor.isHidden = !map.canMove(direction: .up)
        upDoor.isHidden = !map.canMove(direction: .down)
        rightDoor.isHidden = !map.canMove(direction: .left)
        leftDoor.isHidden = !map.canMove(direction: .right)
        puzzleButton.isHidden = map.currentRoom?.puzzle == Puzzles.none || map.currentRoom == nil
        pickFlowerButton.isHidden = !GameManager.shared.isPuzzlePipesCompleted.value || GameManager.shared.hasPickedFlower.value
        itemButton.isHidden = map.currentRoom?.items.count == 0
        frameButton.isHidden = !(map.currentX == 2 && map.currentY == 1)
        endButton.isHidden = !(GameManager.shared.didTurnSwitchOn.value && map.currentX == 2 && map.currentY == 1)
        
        updateBackgroundBasedOnVisibleButtons()
    }
    
    func removeBackground() {
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
            GameManager.shared.isPuzzleLightCompleted.value ?
            self.setBackgroundImage(named: "fundo_direitaesquerda") :  self.setBackgroundImage(named: "Asset_SalaFinalEscura")
            
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
        GameManager.shared.markRadarAsPicked()
        
        itemImages = map.currentRoom?.items.first?.itemInspectImageName.compactMap {
            UIImage(named: $0)
        } ?? []
        
        inspectionImageView = addBackgroundImage(named: map.currentRoom?.items.first?.itemInspectImageName.first ?? "")
        inspectionImageView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        inspectionImageView?.isUserInteractionEnabled = true
        
        if let name = map.currentRoom?.items.first?.itemInspectImageName.first {
            if name != Item.radar.itemImageName {
                view.addSubview(inspectionImageView!)
            }
        }

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
        currentPage = 0
        inspectionImageView?.removeFromSuperview()
        inspectionImageView = nil
        
        if let currentRoom = map.currentRoom,
           currentRoom.x == 0 && currentRoom.y == 0,
           currentRoom.items.contains(where: { $0 == .radar }) {
            GameManager.shared.isRadarEquipped.value = true
            updateRadarButtons()
        }
        if let currentRoom = map.currentRoom,
           currentRoom.x == 0 && currentRoom.y == 0,
           currentRoom.items.contains(where: { $0 == .frame }) {
            GameManager.shared.didTurnSwitchOn.value = true
            updateRadarButtons()
        }
    }
    
    func setBackgroundImage(named imageName: String){
        backgroundImageView = addBackgroundImage(named: imageName)

        if let room = map.currentRoom, !room.hasMonstro() {
            if let _ = map.currentRoom?.puzzle, let image = map.currentRoom?.puzzleImageName {
                backgroundImageView.addSubview(addBackgroundImage(named: image))
            }
            
            if let items = map.currentRoom?.items {
                for (index, item) in items.enumerated() {
                    if map.currentX == 2 && map.currentY == 1 {
                        if GameManager.shared.isPuzzleLightCompleted.value && !GameManager.shared.isGameOver.value {
                            let subview = addBackgroundImage(named: item.itemImageName)
                            subview.tag = index + 5
                            backgroundImageView.addSubview(subview)
                            
                            if GameManager.shared.didDropBoatFrame.value {
                                backgroundImageView.addSubview(addBackgroundImage(named: "Asset_quadroNoChao"))
                                backgroundImageView.viewWithTag(999)?.removeFromSuperview()
                                updateRadarButtons()
                            }
                        }
                    } else if map.currentX == 0 && map.currentY == 0 {
                        backgroundImageView.addSubview(addBackgroundImage(named: Item.bluePrint.itemImageName))
                        if !GameManager.shared.isRadarEquipped.value {
                            let radarview = addBackgroundImage(named: Item.radar.itemImageName)
                            radarview.tag = 184
                            backgroundImageView.addSubview(radarview)
                        }
                    } else {
                        backgroundImageView.addSubview(addBackgroundImage(named: item.itemImageName))
                    }
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
    
    func addBackgroundImage(named imageName: String) -> UIImageView{
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
                if let room = self.map.currentRoom, room.hasMonstro() {
                    self.setMonsterScene()
                    
                } else if let room = self.map.currentRoom, room.x == 2, room.y == 1, GameManager.shared.isGameOver.value {
                    self.setVictoryScene()
                }
                else {
                    self.updateButtonVisibility()
                    self.view.alpha = 1
                }
            }
        }
        
        itemButton.isUserInteractionEnabled = !(map.currentX == 2 && map.currentY == 1)
        
        if !GameManager.shared.isGameOver.value {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if GameManager.shared.isRadarEquipped.value {
                    self.updateRadarButtons()
                }
            }
        }
    }
    
    func setMonsterScene() {
        GameManager.shared.markGameAsFinished()
//        backgroundImageView.subviews.forEach({ $0.removeFromSuperview() })
//        removeBackground()
        
        UIView.animate(withDuration: 1, animations: {
            self.view.alpha = 0
            self.backgroundImageView.subviews.forEach({ $0.removeFromSuperview() })
            self.removeBackground()
        }) { _ in
            UIView.animate(withDuration: 1, animations: {
                self.view.alpha = 1
            }) { _ in
                self.setBackgroundImage(named: "Asset_teladoPlantalhao")
                UIView.animate(withDuration: 5, animations: {
                    HapticsController.shared.playDeathHaptic()
                    self.view.alpha = 0
                }) { _ in
                    self.restart()
                }
            }
        }
    }
    
    func setVictoryScene() {
//        backgroundImageView.subviews.forEach({ $0.removeFromSuperview() })
//        removeBackground()
        
        UIView.animate(withDuration: 2, animations: {
            self.view.alpha = 0
            self.backgroundImageView.subviews.forEach({ $0.removeFromSuperview() })
            self.removeBackground()
        }) { _ in
            UIView.animate(withDuration: 5, animations: {
                self.view.alpha = 1
            }) { _ in
                self.setBackgroundImage(named: "Asset_CutsceneFinal")
                UIView.animate(withDuration: 5, animations: {
                    self.view.alpha = 0
                }) { _ in
                    self.restart()
                }
            }
        }
    }
    
    func restart() {
        GameManager.shared.resetGame()
        if let nc = self.navigationController as? FadeNavigationController {
            if let rootview = nc.viewControllers.first?.view as? StartView {
                rootview.setupAnimation()
            }
            nc.popToRootViewController(animated: true)
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
                if GameManager.shared.shouldAddFlowerToComputer.value && !GameManager.shared.hasAddedFlowerToComputer.value {
                    GameManager.shared.markFlowerAsAdded()
                    return
                }
                
                let buttonPuzzleVC = ButtonPuzzleViewController(isAvailable: GameManager.shared.hasAddedFlowerToComputer.value)
                buttonPuzzleVC.delegate = self
                nextViewController = buttonPuzzleVC
            case .none:
                nextViewController = RoomViewController()
            }
            
            if let navController = self.navigationController as? FadeNavigationController {
                pulseTimer?.invalidate()
                navController.pushViewController(nextViewController, animated: true)
            }
        }
    }
    
    func pickFlower() {
        GameManager.shared.markFlowerAsPicked()
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
        if let contaminationLevel = radar.getMaxNearbyLevel() {
            let radarview = addBackgroundImage(named: "asset_radar")
            radarview.tag = 999
            backgroundImageView.addSubview(radarview)
            if contaminationLevel == 5 {
                displayContaminationLevels([Optional(4)], for: .topLeft)
                displayContaminationLevels([Optional(4)], for: .topRight)
                displayContaminationLevels([Optional(4)], for: .bottomLeft)
                displayContaminationLevels([Optional(4)], for: .bottomRight)
                
            } else {
                displayContaminationLevels(radar.topLeftQuadrantContamination(), for: .topLeft)
                displayContaminationLevels(radar.topRightQuadrantContamination(), for: .topRight)
                displayContaminationLevels(radar.bottomLeftQuadrantContamination(), for: .bottomLeft)
                displayContaminationLevels(radar.bottomRightQuadrantContamination(), for: .bottomRight)
            }
            
            GameManager.shared.isPuzzlePipesCompleted.sink { completed in
                if completed {
                    if GameManager.shared.isRadarEquipped.value {
                        self.radarImage.addSubview(self.addBackgroundImage(named: "asset_interfaceSecundaria_preenchida_1"))
                    }
                }
            }.store(in: &cancellables)
            
            GameManager.shared.isPuzzleButtonsCompleted.sink { completed in
                if completed {
                    if GameManager.shared.isRadarEquipped.value {
                        self.radarImage.addSubview(self.addBackgroundImage(named: "asset_interfaceSecundaria_preenchida_2"))
                    }
                }
            }.store(in: &cancellables)
            
            GameManager.shared.isPuzzleLightCompleted.sink { completed in
                if completed {
                    if GameManager.shared.isRadarEquipped.value {
                        self.radarImage.addSubview(self.addBackgroundImage(named: "asset_interfaceSecundaria_preenchida_3"))
                    }
                }
            }.store(in: &cancellables)
            
            backgroundImageView.addSubview(radarImage)
            
            stopBlinkingRadar()
            startBlinkingRadar(duration: getInterval(contaminationLevel: contaminationLevel))
        }
    }
    
    func getInterval(contaminationLevel: Int) -> Double {
        switch contaminationLevel {
        case 5:
            return 0.125
        case 4:
            return 0.25
        case 3:
            return 0.5
        default:
            return 1.5
        }
    }
    
    func startBlinkingRadar(duration: Double) {
        HapticsController.shared.playPulse()
        
        pulseTimer = Timer.scheduledTimer(withTimeInterval: 2 * duration, repeats: true, block: { _ in
            HapticsController.shared.playPulse()
        })
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.radarImage.alpha = 0.25
        }, completion: nil)
    }
    
    func stopBlinkingRadar() {
        self.radarImage.layer.removeAllAnimations()
        self.radarImage.alpha = 1.0
        pulseTimer?.invalidate()
    }
    
    @objc
    func puzzleTapped() {
        goToPuzzle()
    }
    
    @objc
    func flowerTapped() {
        pickFlower()
    }
    
    func displayContaminationLevels(_ levels: [Int?]) {
        let message = levels.map { "\($0 ?? -1)" }.joined(separator: ", ")
        let alert = UIAlertController(title: "Contamination Levels", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func puzzleViewControllerDidRequestExit(_ viewController: UIViewController) {
        navigationController?.popViewController(animated: true)
        self.updateButtonVisibility()
        if GameManager.shared.isRadarEquipped.value { self.updateRadarButtons() }
    }
    
    // MARK: Logic for game responsiveness
    
    func setupSubscriptions() {
        GameManager.shared.isRadarEquipped.sink { completed in
            if completed {
                self.backgroundImageView.viewWithTag(184)?.removeFromSuperview()
            }
        }.store(in: &cancellables)
        
        GameManager.shared.isPuzzlePipesCompleted.sink { completed in
            if completed {
                self.map.currentRoom?.puzzleImageName = "asset_puzzletubos_aberto"
            }
        }.store(in: &cancellables)
        
        GameManager.shared.isGameOver.sink { completed in
            if completed {
                self.pulseTimer?.invalidate()
            }
        }.store(in: &cancellables)
        
        GameManager.shared.hasPickedFlower.sink { completed in
            if completed {
                self.map.currentRoom?.puzzleImageName = "Asset_PzlTubulacao_PodVazio"
                self.updateButtonVisibility()
                if GameManager.shared.isRadarEquipped.value {
                    self.updateRadarButtons()
                }
                GameManager.shared.shouldAddFlowerToComputer.value = true
            }
        }.store(in: &cancellables)
        
        GameManager.shared.hasAddedFlowerToComputer.sink { completed in
            if completed {
                self.map.currentRoom?.puzzleImageName = "Asset_pzlBotoes_comFlor"
                self.updateButtonVisibility()
                if GameManager.shared.isRadarEquipped.value {
                    self.updateRadarButtons()
                }
            }
        }.store(in: &cancellables)
        
        GameManager.shared.isPuzzleLightCompleted.sink { completed in
            if completed {
                self.frameButton.isUserInteractionEnabled = completed
            }
        }.store(in: &cancellables)
        
        GameManager.shared.didTurnSwitchOn.sink{ completed in
            if completed {
                self.endButton.isHidden = false
                self.endButton.isUserInteractionEnabled = true
            }
        }.store(in: &cancellables)
    }
}
