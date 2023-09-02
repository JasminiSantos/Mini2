//
//  PipePuzzleView.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 01/09/23.
//

import UIKit
import SpriteKit

class PipePuzzleView: UIView {
    lazy var skView: SKView = {
        let view = SKView(frame: self.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    private func addSubviews() {
        self.addSubview(skView)
    }
    
    private func setupConstraints() {
        skView.bottomAnchor.constraint(equalTo: bottomAnchor).setActive()
        skView.topAnchor.constraint(equalTo: topAnchor).setActive()
        skView.leadingAnchor.constraint(equalTo: leadingAnchor).setActive()
        skView.trailingAnchor.constraint(equalTo: trailingAnchor).setActive()
    }
    
    func setupScene() {
        let puzzleScene = PipePuzzleScene(size: skView.bounds.size)
        
        puzzleScene.backgroundColor = .black
        puzzleScene.scaleMode       = .aspectFill
        skView.presentScene(puzzleScene)
    }
}
