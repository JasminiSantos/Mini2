//
//  StartView.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 13/09/23.
//

import UIKit

class StartView: UIView {
    var handleStartButtonTap: () -> (Void) = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var background: UIImageView = {
        let view = UIImageView(image: UIImage(named: "Asset_TelaInício"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var startButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "Asset_Botao_TelaInicio")!, for: .normal)
        view.addTarget(self, action: #selector(didPressStartButton), for: .touchUpInside)
        
        
        return view
    }()
    
    @objc
    func didPressStartButton() {
        handleStartButtonTap()
    }
    
    private func setupAnimation() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0.4
        animation.duration = 1.75
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        startButton.layer.add(animation, forKey: "opacity")
    }
    
    private func addSubviews() {
        addSubview(background)
        addSubview(startButton)
    }
    
    private func setupConstraints() {
        background.leadingAnchor.constraint(equalTo: leadingAnchor).setActive()
        background.trailingAnchor.constraint(equalTo: trailingAnchor).setActive()
        background.topAnchor.constraint(equalTo: topAnchor).setActive()
        background.bottomAnchor.constraint(equalTo: bottomAnchor).setActive()
        
        startButton.leadingAnchor.constraint(equalTo: leadingAnchor).setActive()
        startButton.trailingAnchor.constraint(equalTo: trailingAnchor).setActive()
        startButton.topAnchor.constraint(equalTo: topAnchor).setActive()
        startButton.bottomAnchor.constraint(equalTo: bottomAnchor).setActive()
    }
}
