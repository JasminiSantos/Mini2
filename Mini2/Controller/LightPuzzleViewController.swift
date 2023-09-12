//
//  LightPuzzleViewController.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 27/08/23.
//

import UIKit

class LightPuzzleViewController: UIViewController {

    private var lightPuzzleView = LightPuzzleView()
    weak var delegate: PuzzleViewControllerDelegate?
    
    override func loadView() {
        view = lightPuzzleView
        lightPuzzleView.popToParentView = { [weak self] in
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
        lightPuzzleView.setupScene()
    }
}
