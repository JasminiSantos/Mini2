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
    
    @objc
    func handleFirstButtonTap() {
        self.sequencePublisher.send(1)
    }
    
    @objc
    func handleSecondButtonTap() {
        self.sequencePublisher.send(2)
    }
    
    @objc
    func handleThirdButtonTap() {
        self.sequencePublisher.send(3)
    }
    
    @objc
    func handleFourthButtonTap() {
        self.sequencePublisher.send(4)
    }
    
    var isComplete: CurrentValueSubject<Bool, Never>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        
        addSubviews()
        setupConstraints()
        configureAdditionalSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private lazy var firstButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(systemName: "square.fill"), for: .normal)
        view.addTarget(self, action: #selector(handleFirstButtonTap), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var secondButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        view.addTarget(self, action: #selector(handleSecondButtonTap), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var thirdButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(systemName: "triangle.fill"), for: .normal)
        view.addTarget(self, action: #selector(handleThirdButtonTap), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var fourthButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(systemName: "hexagon.fill"), for: .normal)
        view.addTarget(self, action: #selector(handleFourthButtonTap), for: .touchUpInside)
        
        return view
    }()
    
    lazy var buttonHStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            firstButton, secondButton,
            thirdButton, fourthButton
        ])
        
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 100
        view.distribution = .fillEqually
        view.alignment = .fill
        
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
        addSubview(buttonHStackView)
    }
    
    private func setupConstraints() {
        successImage.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
        successImage.bottomAnchor.constraint(equalTo: centerYAnchor).setActive()
        
        buttonHStackView.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
        buttonHStackView.topAnchor.constraint(equalTo: centerYAnchor, constant: 40).setActive()
    }
    
    private func configureAdditionalSettings() {
        isComplete = CurrentValueSubject(false)
    }
}
