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
    
    var isComplete: CurrentValueSubject<Bool, Never>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
        configureAdditionalSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private lazy var consoleMatrix: ButtonPuzzleMatrixView = {
        let view = ButtonPuzzleMatrixView()
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
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()

    
    lazy var buttonHStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            firstButton, secondButton,
            thirdButton, fourthButton,
            fifthButton
        ])

        view.axis         = .horizontal
//        view.spacing      = 100
        view.distribution = .fillEqually
//        view.alignment    = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.sizeThatFits(CGSize(width: frame.width * 0.1, height: frame.height * 0.1))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var successImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "checkmark.circle.fill")
        
        
        return view
    }()
    
    func setComplete() {
        isComplete?.value = true
    }
    
    private func addSubviews() {
        addSubview(successImage)
//        addSubview(firstButton)
//        addSubview(secondButton)
//        addSubview(thirdButton)
//        addSubview(fourthButton)
//        addSubview(fifthButton)
        
        addSubview(buttonHStackView)
        addSubview(consoleMatrix)
    }
    
    private func setupConstraints() {
        successImage.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
        successImage.bottomAnchor.constraint(equalTo: centerYAnchor).setActive()
//
//        firstButton.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
//        firstButton.centerYAnchor.constraint(equalTo: centerYAnchor).setActive()
//
//        secondButton.centerYAnchor.constraint(equalTo: centerYAnchor).setActive()
//        secondButton.centerYAnchor.constraint(equalTo: centerYAnchor).setActive()
//
//        thirdButton.centerYAnchor.constraint(equalTo: centerYAnchor).setActive()
//        thirdButton.centerYAnchor.constraint(equalTo: centerYAnchor).setActive()
//
//        fourthButton.centerYAnchor.constraint(equalTo: centerYAnchor).setActive()
//        fourthButton.centerYAnchor.constraint(equalTo: centerYAnchor).setActive()
//
//        fifthButton.centerYAnchor.constraint(equalTo: centerYAnchor).setActive()
//        fifthButton.centerYAnchor.constraint(equalTo: centerYAnchor).setActive()
        
        buttonHStackView.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
        buttonHStackView.topAnchor.constraint(equalTo: centerYAnchor, constant: 40).setActive()
        buttonHStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 200).setActive()
        buttonHStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -200).setActive()
        
        consoleMatrix.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
        consoleMatrix.topAnchor.constraint(equalTo: topAnchor).setActive()
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
        firstButton.isUserInteractionEnabled = !pressedButtons.contains(1)
        secondButton.isUserInteractionEnabled = !pressedButtons.contains(2)
        thirdButton.isUserInteractionEnabled = !pressedButtons.contains(3)
        fourthButton.isUserInteractionEnabled = !pressedButtons.contains(4)
        fifthButton.isUserInteractionEnabled = !pressedButtons.contains(5)
    }
}
