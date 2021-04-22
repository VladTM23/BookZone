//
//  CreditsViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 12.04.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class CreditsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var navbarView: NavbarView!
    @IBOutlet weak var alamofireLabel: UILabel!
    @IBOutlet weak var hashLabel: UILabel!
    @IBOutlet weak var firebaseLabel: UILabel!
    @IBOutlet weak var sdWebImageLabel: UILabel!
    @IBOutlet weak var lottieLabel: UILabel!
    @IBOutlet weak var progressHudLabel: UILabel!
    @IBOutlet weak var faveButtonLabel: UILabel!
    @IBOutlet weak var easyTipViewLabel: UILabel!
    @IBOutlet weak var swipeCellKitLabel: UILabel!
    @IBOutlet weak var swiftyJsonLabel: UILabel!
    @IBOutlet weak var parchmentLabel: UILabel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureActions()
    }

    // MARK: - UI

    private func configureUI() {
        configureNavbar()
    }

    private func configureNavbar() {
        navbarView.titleLabelNavbar.text = NSLocalizedString(K.NavbarTitles.creditsTitle, comment: "")
    }

    // MARK: - Action registration

    private func configureActions() {
        alamofireAction()
        hashAction()
        firebaseAction()
        sdWebImageAction()
        lottieAction()
        progressHudAction()
        faveButtonAction()
        easyTipViewAction()
        swipeCellAction()
        swiftyJsonAction()
        parchmentAction()
    }

    private func alamofireAction() {
        let creditsTap = UITapGestureRecognizer(target: self, action: #selector(alamofireLabelTapped))
        alamofireLabel.addGestureRecognizer(creditsTap)
    }

    private func hashAction() {
        let creditsTap = UITapGestureRecognizer(target: self, action: #selector(hashLabelTapped))
        hashLabel.addGestureRecognizer(creditsTap)
    }

    private func firebaseAction() {
        let creditsTap = UITapGestureRecognizer(target: self, action: #selector(firebaseLabelTapped))
        firebaseLabel.addGestureRecognizer(creditsTap)
    }

    private func sdWebImageAction() {
        let creditsTap = UITapGestureRecognizer(target: self, action: #selector(sdWebImageLabelTapped))
        sdWebImageLabel.addGestureRecognizer(creditsTap)
    }

    private func lottieAction() {
        let creditsTap = UITapGestureRecognizer(target: self, action: #selector(lottieLabelTapped))
        lottieLabel.addGestureRecognizer(creditsTap)
    }

    private func progressHudAction() {
        let creditsTap = UITapGestureRecognizer(target: self, action: #selector(progressHudLabelTapped))
        progressHudLabel.addGestureRecognizer(creditsTap)
    }

    private func faveButtonAction() {
        let creditsTap = UITapGestureRecognizer(target: self, action: #selector(faveButtonLabelTapped))
        faveButtonLabel.addGestureRecognizer(creditsTap)
    }

    private func easyTipViewAction() {
        let creditsTap = UITapGestureRecognizer(target: self, action: #selector(easyTipViewLabelTapped))
        easyTipViewLabel.addGestureRecognizer(creditsTap)
    }

    private func swipeCellAction() {
        let creditsTap = UITapGestureRecognizer(target: self, action: #selector(swipeCellKitLabelTapped))
        swipeCellKitLabel.addGestureRecognizer(creditsTap)
    }

    private func swiftyJsonAction() {
        let creditsTap = UITapGestureRecognizer(target: self, action: #selector(swiftyJsonLabelTapped))
        swiftyJsonLabel.addGestureRecognizer(creditsTap)
    }

    private func parchmentAction() {
        let creditsTap = UITapGestureRecognizer(target: self, action: #selector(parchmentLabelTapped))
        parchmentLabel.addGestureRecognizer(creditsTap)
    }

    // MARK: - Actions

    @objc func alamofireLabelTapped() {
        let webVC = SFSafariViewController(url: URL(string: K.Documentation.alamofireURL)!)
        present(webVC, animated: true)
    }

    @objc func hashLabelTapped() {
        let webVC = SFSafariViewController(url: URL(string: K.Documentation.hashURL)!)
        present(webVC, animated: true)
    }

    @objc func firebaseLabelTapped() {
        let webVC = SFSafariViewController(url: URL(string: K.Documentation.firebaseDocURL)!)
        present(webVC, animated: true)
    }

    @objc func sdWebImageLabelTapped() {
        let webVC = SFSafariViewController(url: URL(string: K.Documentation.sdWebURL)!)
        present(webVC, animated: true)
    }

    @objc func lottieLabelTapped() {
        let webVC = SFSafariViewController(url: URL(string: K.Documentation.lottieURL)!)
        present(webVC, animated: true)
    }

    @objc func progressHudLabelTapped() {
        let webVC = SFSafariViewController(url: URL(string: K.Documentation.progressHudURL)!)
        present(webVC, animated: true)
    }

    @objc func faveButtonLabelTapped() {
        let webVC = SFSafariViewController(url: URL(string: K.Documentation.faveButtonURL)!)
        present(webVC, animated: true)
    }

    @objc func easyTipViewLabelTapped() {
        let webVC = SFSafariViewController(url: URL(string: K.Documentation.easyTipViewURL)!)
        present(webVC, animated: true)
    }

    @objc func swipeCellKitLabelTapped() {
        let webVC = SFSafariViewController(url: URL(string: K.Documentation.swipeCellKitURL)!)
        present(webVC, animated: true)
    }

    @objc func swiftyJsonLabelTapped() {
        let webVC = SFSafariViewController(url: URL(string: K.Documentation.swiftyJSONURL)!)
        present(webVC, animated: true)
    }

    @objc func parchmentLabelTapped() {
        let webVC = SFSafariViewController(url: URL(string: K.Documentation.parchmentURL)!)
        present(webVC, animated: true)
    }
}
