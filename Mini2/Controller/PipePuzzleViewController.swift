//
//  PipePuzzleViewController.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 01/09/23.
//

import UIKit

class PipePuzzleViewController: UIViewController {

    private var pipePuzzleView = PipePuzzleView()
    weak var delegate: PuzzleViewControllerDelegate?
    
    override func loadView() {
        view = pipePuzzleView
        pipePuzzleView.popToParentView = { [weak self] in
            if let self = self {
                delegate?.puzzleViewControllerDidRequestExit(self)
            }
        }
        
        navigationItem.hidesBackButton = true
    }
    
    @objc
    func didPressExitButton(from controller: UIViewController) {
        delegate?.puzzleViewControllerDidRequestExit(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pipePuzzleView.setupScene()
    }
}
