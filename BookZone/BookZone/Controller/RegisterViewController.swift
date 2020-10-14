//
//  RegisterViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14/10/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var navbarView: NavbarView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - User interface

    func configureUI() {
        configureNavbar()

    }

    func configureNavbar() {
        navbarView.titleLabelNavbar.text = K.NavbarTitles.registerTitle
    }

}
