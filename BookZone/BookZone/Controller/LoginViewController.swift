//
//  LoginViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14/10/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var signInButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

    @IBAction func login(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        performSegue(withIdentifier: K.Identifiers.loginSuccess, sender: self)
    }
}
