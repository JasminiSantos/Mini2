//
//  FadeNavigationController.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 05/09/23.
//

import UIKit

class FadeNavigationController: UINavigationController, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeTransitionAnimator()
    }
}

