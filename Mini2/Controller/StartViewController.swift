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
        if let navController = self.navigationController as? FadeNavigationController {
            navController.pushViewController(RoomViewController(), animated: true)
        }
    }
}
