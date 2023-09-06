//
//  ButtonPuzzleView.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 25/08/23.
//

import UIKit
import Combine

class ButtonPuzzleView: UIView {
    var sequencePublisher = PassthroughSubject<Int, Never>()
    var pressedButtons: Set<Int> = []
    var isComplete: CurrentValueSubject<Bool, Never>?
    var isAvailable = false
    
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
    func handleFirstButtonTap() {
        sequencePublisher.send(1)
        pressedButtons.insert(1)
        updateButtonStates()
        consoleMatrix.moveBallDown()
    }
    
    @objc
    func handleSecondButtonTap() {
        sequencePublisher.send(2)
        pressedButtons.insert(2)
        updateButtonStates()
        consoleMatrix.moveBallUpLeft()
    }
    
    @objc
    func handleThirdButtonTap() {
        sequencePublisher.send(3)
        pressedButtons.insert(3)
        updateButtonStates()
        consoleMatrix.moveBallUpRight()
    }
    
    @objc
    func handleFourthButtonTap() {
        sequencePublisher.send(4)
        pressedButtons.insert(4)
        updateButtonStates()
        consoleMatrix.moveBallRightDown()
    }
    
    @objc
    func handleFifthButtonTap() {
        sequencePublisher.send(5)
        pressedButtons.insert(5)
        updateButtonStates()
        consoleMatrix.moveBallRightUp()
    }
    
    private lazy var consoleMatrix: ButtonPuzzleMatrixView = {
        let view = ButtonPuzzleMatrixView()
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
        view.isUserInteractionEnabled = !pressedButtons.contains(1)

        return view
    }()
    
    private lazy var secondButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "button-puzzle2"), for: .normal)
        view.addTarget(self, action: #selector(handleSecondButtonTap), for: .touchUpInside)
        view.isUserInteractionEnabled = !pressedButtons.contains(2)

        return view
    }()
    
    private lazy var thirdButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "button-puzzle3"), for: .normal)
        view.addTarget(self, action: #selector(handleThirdButtonTap), for: .touchUpInside)
        view.isUserInteractionEnabled = !pressedButtons.contains(3)

        return view
    }()
    
    private lazy var fourthButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "button-puzzle4"), for: .normal)
        view.addTarget(self, action: #selector(handleFourthButtonTap), for: .touchUpInside)
        view.isUserInteractionEnabled = !pressedButtons.contains(4)
        
        return view
    }()
    
    private lazy var fifthButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "button-puzzle5"), for: .normal)
        view.addTarget(self, action: #selector(handleFifthButtonTap), for: .touchUpInside)
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
        view.distribution = .fill
        view.alignment    = .center
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
//        addSubview(buttonHStackView)
//        addSubview(successImage)
        addSubview(firstButton)
        addSubview(secondButton)
        addSubview(thirdButton)
        addSubview(fourthButton)
        addSubview(fifthButton)
        
        addSubview(consoleImage)
        addSubview(consoleMatrix)
    }
    
    private func setupConstraints() {
//        buttonHStackView.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
//        buttonHStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 200).setActive()
//        buttonHStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -200).setActive()
//        buttonHStackView.heightAnchor.constraint(equalToConstant: 35).setActive()
//        buttonHStackView.bottomAnchor.constraint(equalTo: bottomAnchor).setActive()
        
        backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor).setActive()
        backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor).setActive()
        backgroundImage.topAnchor.constraint(equalTo: topAnchor).setActive()
        backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor).setActive()
        
        firstButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 196).setActive()
        firstButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -41).setActive()
        firstButton.widthAnchor.constraint(equalToConstant: 48.15).setActive()
        firstButton.heightAnchor.constraint(equalToConstant: 45).setActive()

        secondButton.leadingAnchor.constraint(equalTo: firstButton.trailingAnchor, constant: 43).setActive()
        secondButton.bottomAnchor.constraint(equalTo: firstButton.bottomAnchor).setActive()
        secondButton.widthAnchor.constraint(equalTo: firstButton.widthAnchor).setActive()
        secondButton.heightAnchor.constraint(equalTo: firstButton.heightAnchor).setActive()
        
        thirdButton.leadingAnchor.constraint(equalTo: secondButton.trailingAnchor, constant: 46).setActive()
        thirdButton.bottomAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 3).setActive()
        thirdButton.widthAnchor.constraint(equalTo: firstButton.widthAnchor).setActive()
        thirdButton.heightAnchor.constraint(equalTo: firstButton.heightAnchor).setActive()
        
        fourthButton.leadingAnchor.constraint(equalTo: thirdButton.trailingAnchor, constant: 47).setActive()
        fourthButton.bottomAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 3).setActive()
        fourthButton.widthAnchor.constraint(equalTo: firstButton.widthAnchor).setActive()
        fourthButton.heightAnchor.constraint(equalTo: firstButton.heightAnchor).setActive()
        
        fifthButton.leadingAnchor.constraint(equalTo: fourthButton.trailingAnchor, constant: 51).setActive()
        fifthButton.bottomAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 3).setActive()
        fifthButton.widthAnchor.constraint(equalTo: firstButton.widthAnchor).setActive()
        fifthButton.heightAnchor.constraint(equalTo: firstButton.heightAnchor).setActive()
        
        consoleImage.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
        consoleImage.centerYAnchor.constraint(equalTo: centerYAnchor).setActive()
        consoleImage.widthAnchor.constraint(equalToConstant: consoleImage.frame.width/4).setActive()
        consoleImage.heightAnchor.constraint(equalToConstant: consoleImage.frame.height/4).setActive()
        
        consoleMatrix.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -187).setActive()
        consoleMatrix.topAnchor.constraint(equalTo: topAnchor, constant: 57).setActive()
//        consoleMatrix.widthAnchor.constraint(equalToConstant: 400).setActive()
        
//        successImage.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
//        successImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50).setActive()
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
        firstButton.isUserInteractionEnabled = !pressedButtons.contains(1) && isAvailable
        secondButton.isUserInteractionEnabled = !pressedButtons.contains(2) && isAvailable
        thirdButton.isUserInteractionEnabled = !pressedButtons.contains(3) && isAvailable
        fourthButton.isUserInteractionEnabled = !pressedButtons.contains(4) && isAvailable
        fifthButton.isUserInteractionEnabled = !pressedButtons.contains(5) && isAvailable
    }
}
