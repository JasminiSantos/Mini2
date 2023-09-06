//
//  FadeTransitionAnimator.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 05/09/23.
//

import UIKit

class FadeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            return
        }

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        toView.alpha = 0.0

        // Create a dark view
        let darkView = UIView(frame: containerView.bounds)
        darkView.backgroundColor = UIColor.black
        darkView.alpha = 0.0
        containerView.insertSubview(darkView, aboveSubview: fromView)
        
        let duration = transitionDuration(using: transitionContext)

        // First animation: Fade out the fromView and fade in the darkView
        UIView.animate(withDuration: duration / 2, animations: {
            fromView.alpha = 0.0
            darkView.alpha = 1.0
        }) { _ in
            containerView.bringSubviewToFront(toView) // Ensure toView is at the front

            // Second animation: Fade out the darkView and fade in the toView
            UIView.animate(withDuration: duration / 2, animations: {
                toView.alpha = 1.0
                darkView.alpha = 0.0
            }, completion: { finished in
                darkView.removeFromSuperview() // Remove dark view after animation
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }


}

