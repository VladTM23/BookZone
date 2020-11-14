//
//  LoginViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14/10/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
    }

    private func skipToHome() {
        performSegue(withIdentifier: K.Identifiers.skipToHome, sender: self)
    }

    private func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
             self?.performSegue(withIdentifier: K.Identifiers.skipToHome, sender: nil)
              }
        } else {
            print("Out")
        }
    }
}
