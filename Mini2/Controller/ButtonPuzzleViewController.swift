//
//  Puzzle1ViewController.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 25/08/23.
//

import UIKit
import Combine

protocol PuzzleViewControllerDelegate: AnyObject {
    func puzzleViewControllerDidRequestExit(_ viewController: UIViewController)
}

class ButtonPuzzleViewController: UIViewController {
    var isAvailable: Bool
    private var buttonPuzzleView: ButtonPuzzleView?
    private let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let heavyImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    weak var delegate: PuzzleViewControllerDelegate?
    
    private var cancellables = Set<AnyCancellable>()
    
    let correctSequence = [3, 1, 5, 4, 2]
    var currentSequence: [Int] = []
    
    let correctPosition = (0, 2)
    
    init(isAvailable: Bool, buttonPuzzleView: ButtonPuzzleView? = nil) {
        self.isAvailable = isAvailable
        super.init(nibName: nil, bundle: nil)
        lightImpactFeedbackGenerator.prepare()
        heavyImpactFeedbackGenerator.prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func loadView() {
        self.buttonPuzzleView = ButtonPuzzleView(frame: CGRect.zero, isAvailable: isAvailable)
        view = buttonPuzzleView
        buttonPuzzleView?.popToParentView = { [weak self] in
            if let self = self {
                delegate?.puzzleViewControllerDidRequestExit(self)
            }
        }
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonPuzzleView?.frame = view.frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscriptions()
    }
    
    @objc
    func didPressExitButton(from controller: UIViewController) {
        delegate?.puzzleViewControllerDidRequestExit(self)
    }
    
    // MARK: Main puzzle logic
    
    func checkPosition() {
        let currentPos = buttonPuzzleView!.consoleMatrix.getCurrentPosition()
        
        if correctPosition == currentPos {
            GameManager.shared.markPuzzleButtonsAsCompleted()
            performCompletionHaptics()
            
        } else {
            if currentSequence.count == 5 {
                self.currentSequence.removeAll()
                
                startPixelatedShake()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.buttonPuzzleView!.resetPuzzle()
                }
                
                for i in 0..<4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * 0.1)) {
                        self.heavyImpactFeedbackGenerator.impactOccurred()
                    }
                }
            }
        }
    }
    
    func addToCurrentSequence(_ value: Int) {
        if !currentSequence.contains(value) {
            currentSequence.append(value)
        }
    }

    // MARK: setting up Combine
    
    private func setupSubscriptions() {
        buttonPuzzleView!.sequencePublisher
            .sink { [weak self] value in
                self?.addToCurrentSequence(value)
                self?.checkPosition()
            }
            .store(in: &cancellables)
    }
    
    // MARK: Completion impact
    func performCompletionHaptics() {
        // Primeiro impacto
        heavyImpactFeedbackGenerator.impactOccurred()
        
        // Pausa curta e segundo impacto
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.heavyImpactFeedbackGenerator.impactOccurred()
        }
        
        // Pausa longa e terceiro impacto
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.heavyImpactFeedbackGenerator.impactOccurred()
        }
    }
    
    // MARK: Shake animation
    
    var timer: Timer?
    var shakeCount = 0
    let maxShakes = 8  // Número de "vibrações"
    let shakeDistance: CGFloat = 5.0  // Distância de cada "vibração"
    
    func startPixelatedShake() {
        shakeCount = 0
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(performPixelatedShake), userInfo: nil, repeats: true)
    }
    
    @objc func performPixelatedShake() {
        if shakeCount >= maxShakes {
            timer?.invalidate()
            timer = nil
            return
        }
        
        // Calcula a nova posição
        var xOffset: CGFloat = 0
        if shakeCount % 2 == 0 {
            xOffset = shakeDistance
        } else {
            xOffset = -shakeDistance
        }
        
        // Move a greenBall
        let originalCenter = buttonPuzzleView?.consoleMatrix.greenBall.center ?? CGPoint.zero
        buttonPuzzleView?.consoleMatrix.greenBall.center = CGPoint(x: originalCenter.x + xOffset, y: originalCenter.y)
        
        // Incrementa o contador
        shakeCount += 1
    }
}
