//
//  PipePuzzleViewController.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 01/09/23.
//

import UIKit

class PipePuzzleViewController: UIViewController {

    private var pipePuzzleView = PipePuzzleView()
    
    override func loadView() {
        view = pipePuzzleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pipePuzzleView.setupScene()
    }
}
