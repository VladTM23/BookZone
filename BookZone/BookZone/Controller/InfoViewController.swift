//
//  InfoViewController.swift
//  BookZone
//
//  Created by Alexandra-Gabriela Laicu-Hausberger on 14/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import Lottie

class InfoViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var navBarView: NavbarView!
    @IBOutlet weak var resultCardView: ResultCardView!
    @IBOutlet weak var animationView: AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - User interface

    func configureUI() {
        configureNavBar()
        configureAnimation()
//        let image = UIImage(systemName: "multiply.circle.fill")
    
    }

    func configureNavBar() {
        navBarView.titleLabelNavbar.text = K.NavbarTitles.infoTitle
    }

    func configureAnimation() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.play()
    }

    @IBAction func getStartedButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Identifiers.getStarted, sender: self)
    }
}
