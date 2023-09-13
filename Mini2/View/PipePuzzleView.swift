//
//  PipePuzzleView.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 01/09/23.
//

import UIKit
import SpriteKit

class PipePuzzleView: UIView {
    var popToParentView: () -> Void = {}
    
    lazy var skView: SKView = {
        let view = SKView(frame: self.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var exitButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.addTarget(self, action: #selector(handleExitButtonTap), for: .touchUpInside)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func handleExitButtonTap() {
        popToParentView()
    }
    
    private func addSubviews() {
        addSubview(skView)
        addSubview(exitButton)
    }
    
    private func setupConstraints() {
        skView.bottomAnchor.constraint(equalTo: bottomAnchor).setActive()
        skView.topAnchor.constraint(equalTo: topAnchor).setActive()
        skView.leadingAnchor.constraint(equalTo: leadingAnchor).setActive()
        skView.trailingAnchor.constraint(equalTo: trailingAnchor).setActive()
        
        exitButton.bottomAnchor.constraint(equalTo: bottomAnchor).setActive()
        exitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70).setActive()
        exitButton.heightAnchor.constraint(equalToConstant: 75).setActive()
        exitButton.widthAnchor.constraint(equalToConstant: 75).setActive()
    }
    
    func setupScene() {
        let puzzleScene = PipePuzzleScene(size: skView.bounds.size)
        
        puzzleScene.backgroundColor = .black
        puzzleScene.scaleMode       = .aspectFill
        
        self.skView.presentScene(puzzleScene)
    }
}
