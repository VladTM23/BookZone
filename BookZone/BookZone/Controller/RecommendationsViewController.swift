//
//  RecommendationsViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 17.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class RecommendationsViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var navbarView: NavbarView!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - UI
    private func configureUI() {
        configureNavbar()
    }

    private func configureNavbar() {
        navbarView.titleLabelNavbar.text = NSLocalizedString(K.NavbarTitles.recommendations, comment: "")
    }
}
