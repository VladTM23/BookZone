//
//  InfoViewController.swift
//  BookZone
//
//  Created by Alexandra-Gabriela Laicu-Hausberger on 14/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var navBarView: NavbarView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - User interface

    func configureUI() {
        configureNavBar()
    }

    func configureNavBar() {
        navBarView.titleLabel.text = K.NavbarTitles.infoTitle
    }
    
}
