//
//  BookClubInviteViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 01.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import SDWebImage

class BookClubInviteViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Properties
    @IBOutlet weak var navbarView: NavbarView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var bookClubName: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var finishEditingButton: UIButton!
    @IBOutlet weak var bookCoverBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var guestViewContainer: UIView!
    @IBOutlet weak var editorView: UIView!

    var bookTitle: String?
    var bookCoverUrl: String?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bookClubName.delegate = self
    }

    // MARK: - UI
    private func configureUI() {
        configureNavbar()
        configureBookCover()
        configureBookCoverGesture()
        configureFinishEditingButton()
    }

    private func configureNavbar() {
        navbarView.titleLabelNavbar.text = NSLocalizedString(K.NavbarTitles.bookClubsInvite, comment: "")
        navbarView.subtitleLabel.text = bookTitle
        navbarView.subtitleLabel.isHidden = false
        navbarView.closeButton.isHidden = false
    }

    private func configureBookCover() {
        guard let safeBookCoverUrl = bookCoverUrl else { return }
        bookCoverImage.sd_setImage(with: URL(string: safeBookCoverUrl))
    }

    private func configureBookCoverGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bookCoverTapped))
        bookCoverImage.isUserInteractionEnabled = true
        bookCoverImage.addGestureRecognizer(tapGestureRecognizer)
    }

    private func configureFinishEditingButton() {
        finishEditingButton.setTitle(NSLocalizedString(K.ButtonTiles.finishEditing, comment: ""), for: .normal)
        finishEditingButton.layer.cornerRadius = finishEditingButton.frame.height / 2.0
        finishEditingButton.clipsToBounds = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Actions
    @objc func bookCoverTapped(){
        performSegue(withIdentifier: K.Identifiers.inviteToBookInfo, sender: self)
    }

    @IBAction func editButtonPressed(_ sender: UIButton) {
        sender.showAnimation {
            self.toggleEditing(editMode: true)
        }
    }
    
    @IBAction func finishEditingButtonPressed(_ sender: UIButton) {
        sender.showAnimation {
            self.toggleEditing(editMode: false)
        }
    }

    // MARK: - Helpers

    private func toggleEditing(editMode: Bool) {
        // Show finish editing button
        finishEditingButton.isHidden = !editMode

        // Toggle constraints
        mainViewBottomConstraint.constant = editMode ? 65 : 25
        bookCoverBottomConstraint.constant = editMode ? 65 : 25

        // Setup textfield
        setupTextfield(editMode)

        // Toggle views
        editorView.isHidden = !editMode
        guestViewContainer.isHidden = editMode
    }

    private func setupTextfield(_ editMode: Bool) {
        if editMode {
            bookClubName.isEnabled = true
            bookClubName.borderStyle = .roundedRect
            bookClubName.backgroundColor = .white.withAlphaComponent(0.85)
            bookClubName.textColor = UIColor(named: "darkGreen") ?? .green
            bookClubName.tintColor = UIColor(named: "darkGreen") ?? .green
        } else {
            bookClubName.isEnabled = false
            bookClubName.borderStyle = .none
            bookClubName.backgroundColor = .clear
            bookClubName.textColor = .white
            bookClubName.tintColor = .white
        }
    }

    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == K.Identifiers.inviteToBookInfo {
         let resultsVC = segue.destination as! ResultsViewController
         resultsVC.flag = false
         let safeBookTitle: String = bookTitle ?? "No book found"
         resultsVC.titleLabelVar = safeBookTitle
         resultsVC.titleArray = safeBookTitle.components(separatedBy: " ")
     }
 }
}