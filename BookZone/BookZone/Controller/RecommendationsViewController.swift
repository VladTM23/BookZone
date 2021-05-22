//
//  RecommendationsViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 17.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import SDWebImage

class RecommendationsViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var navbarView: NavbarView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var seeMoreInfoButton: UIButton!
    @IBOutlet weak var tryAgainButton: UIButton!

    private var recommendedBook: Book?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getRecommendation()
    }

    // MARK: - UI
    private func configureUI() {
        configureNavbar()
    }

    private func configureNavbar() {
        navbarView.titleLabelNavbar.text = NSLocalizedString(K.NavbarTitles.recommendations, comment: "")
    }

    private func configureButtons() {
        seeMoreInfoButton.setTitle(NSLocalizedString(K.ButtonTiles.seeMoreInfo, comment: ""), for: .normal)
        seeMoreInfoButton.layer.cornerRadius = seeMoreInfoButton.frame.height / 2.0
        seeMoreInfoButton.clipsToBounds = true
        tryAgainButton.setTitle(NSLocalizedString(K.ButtonTiles.tryAgain, comment: ""), for: .normal)
        tryAgainButton.layer.cornerRadius = tryAgainButton.frame.height / 2.0
        tryAgainButton.clipsToBounds = true
    }

    private func setupBookUI() {
        guard let safeBook = recommendedBook else { return }
        bookTitleLabel.text = safeBook.title
        bookCoverImage.sd_setImage(with: URL(string: safeBook.imageURL))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifiers.recommendationToResults {
            let resultsVC = segue.destination as! ResultsViewController
            resultsVC.flag = false
            let safeBookTitle: String = recommendedBook?.title ?? NSLocalizedString(K.LabelTexts.noBookFound, comment: "")
            resultsVC.titleLabelVar = safeBookTitle
            resultsVC.titleArray = safeBookTitle.components(separatedBy: " ")
        }
    }

    // MARK: - Helper

    private func getRecommendation() {
        RecommenderManager.shared.getBookRecommendation { book in
            if let safeBook = book {
                self.recommendedBook = safeBook
                self.setupBookUI()
            }
        }
    }

    // MARK: - Actions

    @IBAction func seeMoreInfoButtonPressed(_ sender: UIButton) {
        sender.showAnimation {
            if !ReachabilityManager.shared.hasConnectivity() {
                let alert = UIAlertController(title: NSLocalizedString(K.ButtonTiles.noInternetTitle, comment: ""), message: NSLocalizedString(K.Errors.internetError, comment: "") , preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                self.performSegue(withIdentifier: K.Identifiers.recommendationToResults, sender: self)
            }
        }
    }


    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        sender.showAnimation {
            self.getRecommendation()
        }
    }

}
