//
//  LightPuzzleViewController.swift
//  Mini2
//
//  Created by Gustavo Munhoz Correa on 27/08/23.
//

import UIKit

class LightPuzzleViewController: UIViewController {

    private var lightPuzzleView = LightPuzzleView()
    
    override func loadView() {
        view = lightPuzzleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lightPuzzleView.setupScene()
    }
}
