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
    @IBOutlet weak var animationView: AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - User interface

    func configureUI() {
        configureNavBar()
        configureAnimation()
    }

    func configureNavBar() {
        navBarView.titleLabelNavbar.text = NSLocalizedString(K.NavbarTitles.infoTitle, comment: "")
        navBarView.backButton.isHidden = true
        navBarView.closeButton.isHidden = false
    }

    func configureAnimation() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.play()
    }

    @IBAction func getStartedButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: K.UserKeys.tutorialCompleted)
        performSegue(withIdentifier: K.Identifiers.getStarted, sender: self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
