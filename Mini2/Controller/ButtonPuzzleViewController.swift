//
//  Puzzle1ViewController.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 25/08/23.
//

import UIKit
import Combine

class ButtonPuzzleViewController: UIViewController {
    private var buttonPuzzleView = ButtonPuzzleView()
    
    private var cancellables = Set<AnyCancellable>()
    
    let correctSequence = [1, 2, 3, 4]
    var currentSequence: [Int] = []
    
    override func loadView() {
        view = buttonPuzzleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubscriptions()
    }
    
    func addToCurrentSequence(_ value: Int) {
        currentSequence.append(value)
        
        if currentSequence.count == correctSequence.count {
            checkSequence()
        }
    }

    func checkSequence() {
        if currentSequence == correctSequence {
            blinkAnimation(count: 3, button: self.buttonPuzzleView.buttonHStackView, color: .green)
            buttonPuzzleView.successImage.tintColor = .green
            
        } else {
            blinkAnimation(count: 3, button: self.buttonPuzzleView.buttonHStackView, color: .red)
            buttonPuzzleView.successImage.tintColor = .red
        }
        currentSequence.removeAll()
    }
    
    func blinkAnimation(count: Int, button: UIView, color: UIColor) {
        if count <= 0 {
            return
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            button.tintColor = color
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                button.tintColor = .blue
            }, completion: { _ in
                self.blinkAnimation(count: count - 1, button: button, color: color)
            })
        })
    }

    private func setupSubscriptions() {
        buttonPuzzleView.sequencePublisher
            .sink { [weak self] value in
                self?.addToCurrentSequence(value)
                
            }
            .store(in: &cancellables)
    }
    
}
