//
//  StartViewController.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 13/09/23.
//

import UIKit

class StartViewController: UIViewController {
    private let startView = StartView()
    private var timer: Timer?
    
    override func loadView() {
        view = startView
        setupButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do { startView.removeCutscene() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playHaptics()
    }
    
    func playHaptics() {
        HapticsController.shared.startBreathingHaptic()
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
            HapticsController.shared.startBreathingHaptic()
        }
    }
    
    func setupButtons() {
        startView.handleStartButtonTap = startGame
    }
    
    func startGame() {
        HapticsController.shared.stopBreathingHaptic()
        timer?.invalidate()
        
        UIView.animate(withDuration: 1, animations: {
            self.view.alpha = 0
        }) { _ in
            self.view.alpha = 1
            self.startView.addCutscene()
            UIView.animate(withDuration: 5, animations: {
                HapticsController.shared.playDeathHaptic()
                self.view.alpha = 0
            }) { _ in
                if let navController = self.navigationController as? FadeNavigationController {
                    navController.pushViewController(RoomViewController(), animated: true)
                }
            }
        }
    }
}
