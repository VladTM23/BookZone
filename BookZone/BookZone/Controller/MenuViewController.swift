//
//  MenuViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 19.04.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var navbarView: NavbarView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var redoTutorialButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    @IBOutlet weak var selectLanguageButton: UIButton!
    @IBOutlet weak var bookClubsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - UI
    private func configureUI() {
        configureNavbar()
        setStrings()
    }

    private func configureNavbar() {
        navbarView.titleLabelNavbar.text = NSLocalizedString(K.NavbarTitles.menuTitle, comment: "")
    }

    private func setStrings() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
        versionLabel.text = "\(NSLocalizedString("versions", comment: "")) \(appVersion!) (\(build!))"

        selectLanguageButton.setTitle(NSLocalizedString("settings", comment: ""), for: .normal)
        redoTutorialButton.setTitle(NSLocalizedString("redoTutorial", comment: ""), for: .normal)
        creditsButton.setTitle(NSLocalizedString("credits", comment: ""), for: .normal)
        bookClubsButton.setTitle(NSLocalizedString("bookClubs", comment: ""), for: .normal)
    }

    // MARK: - Actions
    @IBAction func selectLanguagePressed(_ sender: UIButton) {
        sender.showAnimation {
            self.performSegue(withIdentifier: K.Identifiers.goToSettings, sender: self)
        }
    }

    @IBAction func redoTutorialPressed(_ sender: UIButton) {
        sender.showAnimation {
            self.performSegue(withIdentifier: K.Identifiers.redoTutorial, sender: self)
        }
    }

    @IBAction func creditsPressed(_ sender: UIButton) {
        sender.showAnimation {
            self.performSegue(withIdentifier: K.Identifiers.goToCredits, sender: self)
        }
    }

    @IBAction func bookClubButtonPressed(_ sender: UIButton) {
        sender.showAnimation {
            self.performSegue(withIdentifier: K.Identifiers.goToBookClubs, sender: self)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
