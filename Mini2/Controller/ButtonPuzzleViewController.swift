//
//  Puzzle1ViewController.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 25/08/23.
//

import UIKit
import Combine

class ButtonPuzzleViewController: UIViewController {
    var isAvailable: Bool
    private var buttonPuzzleView: ButtonPuzzleView?
    
    private var cancellables = Set<AnyCancellable>()
    
    let correctSequence = [3, 1, 5, 4, 2]
    var currentSequence: [Int] = []
    
    init(isAvailable: Bool, buttonPuzzleView: ButtonPuzzleView? = nil) {
        self.isAvailable = isAvailable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func loadView() {
        self.buttonPuzzleView = ButtonPuzzleView(frame: view.frame, isAvailable: isAvailable)
        view = buttonPuzzleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubscriptions()
    }
    
    func addToCurrentSequence(_ value: Int) {
        if !currentSequence.contains(value) {
            currentSequence.append(value)
            
            if currentSequence.count == correctSequence.count {
                checkSequence()
            }
        }
    }

    func checkSequence() {
        if currentSequence == correctSequence {
            buttonPuzzleView!.successImage.tintColor = .green
        } else {
            buttonPuzzleView!.successImage.tintColor = .red
            DispatchQueue.main.async {
                self.buttonPuzzleView!.resetPuzzle()
            }
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
        buttonPuzzleView!.sequencePublisher
            .sink { [weak self] value in
                self?.addToCurrentSequence(value)
                
            }
            .store(in: &cancellables)
    }
}
