//
//  ButtonPuzzleView.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 25/08/23.
//

import UIKit
import Combine

class ButtonPuzzleView: UIView {
    var popToParentView: () -> Void = {}
    
    var sequencePublisher = PassthroughSubject<Int, Never>()
    var pressedButtons: Set<Int> = []
    var isComplete: CurrentValueSubject<Bool, Never>?
    var isAvailable = false
    let heavyImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    init(frame: CGRect, isAvailable: Bool) {
        self.isAvailable = isAvailable
        super.init(frame: frame)
        
        configureAdditionalSettings()
        addSubviews()
        setupConstraints()
        updateButtonStates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    @objc
    func handleButtonTouchDown() {
        lightImpactFeedbackGenerator.impactOccurred(intensity: 1)
    }
    
    @objc
    func handleFirstButtonTap() {
        heavyImpactFeedbackGenerator.impactOccurred(intensity: 1.0)
        consoleMatrix.moveBallDown()
        sequencePublisher.send(1)
        pressedButtons.insert(1)
        updateButtonStates()
    }
    
    @objc
    func handleSecondButtonTap() {
        heavyImpactFeedbackGenerator.impactOccurred(intensity: 1.0)
        consoleMatrix.moveBallUpLeft()
        sequencePublisher.send(2)
        pressedButtons.insert(2)
        updateButtonStates()
    }
    
    @objc
    func handleThirdButtonTap() {
        heavyImpactFeedbackGenerator.impactOccurred(intensity: 1.0)
        consoleMatrix.moveBallUpRight()
        sequencePublisher.send(3)
        pressedButtons.insert(3)
        updateButtonStates()
    }
    
    @objc
    func handleFourthButtonTap() {
        heavyImpactFeedbackGenerator.impactOccurred(intensity: 1.0)
        consoleMatrix.moveBallRightDown()
        sequencePublisher.send(4)
        pressedButtons.insert(4)
        updateButtonStates()
    }
    
    @objc
    func handleFifthButtonTap() {
        heavyImpactFeedbackGenerator.impactOccurred(intensity: 1.0)
        consoleMatrix.moveBallRightUp()
        sequencePublisher.send(5)
        pressedButtons.insert(5)
        updateButtonStates()
    }
    
    @objc
    func handleExitButtonTap() {
        popToParentView()
    }
    
    private lazy var exitButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.addTarget(self, action: #selector(handleExitButtonTap), for: .touchUpInside)
        
        return view
    }()
    
    lazy var consoleMatrix: ButtonPuzzleMatrixView = {
        let view = ButtonPuzzleMatrixView(frame: self.frame, isAvailable: self.isAvailable)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var consoleImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: isAvailable ? "button-console" : "button-access-denied"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "button-background"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var firstButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "button-puzzle1"), for: .normal)
        view.addTarget(self, action: #selector(handleFirstButtonTap), for: .touchUpInside)
        view.addTarget(self, action: #selector(handleButtonTouchDown), for: .touchDown)
        view.isUserInteractionEnabled = !pressedButtons.contains(1)

        return view
    }()
    
    private lazy var secondButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "button-puzzle2"), for: .normal)
        view.addTarget(self, action: #selector(handleSecondButtonTap), for: .touchUpInside)
        view.addTarget(self, action: #selector(handleButtonTouchDown), for: .touchDown)
        view.isUserInteractionEnabled = !pressedButtons.contains(2)

        return view
    }()
    
    private lazy var thirdButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "button-puzzle3"), for: .normal)
        view.addTarget(self, action: #selector(handleThirdButtonTap), for: .touchUpInside)
        view.addTarget(self, action: #selector(handleButtonTouchDown), for: .touchDown)
        view.isUserInteractionEnabled = !pressedButtons.contains(3)

        return view
    }()
    
    private lazy var fourthButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "button-puzzle4"), for: .normal)
        view.addTarget(self, action: #selector(handleFourthButtonTap), for: .touchUpInside)
        view.addTarget(self, action: #selector(handleButtonTouchDown), for: .touchDown)
        view.isUserInteractionEnabled = !pressedButtons.contains(4)
        
        return view
    }()
    
    private lazy var fifthButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "button-puzzle5"), for: .normal)
        view.addTarget(self, action: #selector(handleFifthButtonTap), for: .touchUpInside)
        view.addTarget(self, action: #selector(handleButtonTouchDown), for: .touchDown)
        view.isUserInteractionEnabled = !pressedButtons.contains(5)
        
        return view
    }()
    
    lazy var buttonHStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            firstButton, secondButton,
            thirdButton, fourthButton,
            fifthButton
        ])

        view.axis         = .horizontal
        view.spacing      = 25
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    lazy var successImage: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.frame.size = CGSize(width: 200, height: 200)
        return view
    }()
    
    func setComplete() {
        isComplete?.value = true
    }
    
    
    private func addSubviews() {
        addSubview(backgroundImage)
        addSubview(buttonHStackView)
//        addSubview(successImage)
        
        addSubview(exitButton)
        
        addSubview(consoleImage)
        addSubview(consoleMatrix)
    }
    
    private func setupConstraints() {
        buttonHStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 195).setActive()
        buttonHStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -225).setActive()
        buttonHStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24).setActive()
        
        firstButton.heightAnchor.constraint(equalTo: firstButton.widthAnchor, multiplier: 15/14).setActive()
        
        backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor).setActive()
        backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor).setActive()
        backgroundImage.topAnchor.constraint(equalTo: topAnchor).setActive()
        backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor).setActive()
        
        consoleImage.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
        consoleImage.centerYAnchor.constraint(equalTo: centerYAnchor).setActive()
        consoleImage.widthAnchor.constraint(equalToConstant: consoleImage.frame.width/4).setActive()
        consoleImage.heightAnchor.constraint(equalToConstant: consoleImage.frame.height/4).setActive()
        
        consoleMatrix.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -187).setActive()
        consoleMatrix.topAnchor.constraint(equalTo: topAnchor, constant: 57).setActive()

        exitButton.topAnchor.constraint(equalTo: topAnchor, constant: 25).setActive()
        exitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).setActive()
        exitButton.heightAnchor.constraint(equalToConstant: 75).setActive()
        exitButton.widthAnchor.constraint(equalToConstant: 75).setActive()
    }
    
    private func configureAdditionalSettings() {
        isComplete = CurrentValueSubject(false)
    }
    
    func resetPuzzle() {
        consoleMatrix.resetBall()
        pressedButtons.removeAll()
        updateButtonStates()
    }
    
    private func updateButtonStates() {
        let buttonConditions = [
            (!pressedButtons.contains(1) && !GameManager.shared.isPuzzleButtonsCompleted.value),
            (!pressedButtons.contains(2) && !GameManager.shared.isPuzzleButtonsCompleted.value),
            (!pressedButtons.contains(3) && !GameManager.shared.isPuzzleButtonsCompleted.value),
            (!pressedButtons.contains(4) && !GameManager.shared.isPuzzleButtonsCompleted.value),
            (!pressedButtons.contains(5) && !GameManager.shared.isPuzzleButtonsCompleted.value)
        ]
        
        let buttons = [firstButton, secondButton, thirdButton, fourthButton, fifthButton]
        
        for (index, button) in buttons.enumerated() {
            let condition = buttonConditions[index]
            button.isUserInteractionEnabled = condition
            let buttonImageName = condition ? "button-puzzle\(index + 1)" : "graybutton-puzzle\(index + 1)"
            button.setImage(UIImage(named: buttonImageName), for: .normal)
        }
    }
}
