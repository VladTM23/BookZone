//
//  BookClubInviteViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 01.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class BookClubInviteViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Properties
    @IBOutlet weak var navbarView: NavbarView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var bookClubName: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var finishEditingButton: UIButton!
    @IBOutlet weak var guestViewContainer: UIView!
    @IBOutlet weak var editorView: UIView!
    @IBOutlet weak var eventDatePlaceholder: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventPlatformPlaceholder: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var platformImage: UIImageView!
    @IBOutlet weak var inviteLinkButton: UIButton!
    @IBOutlet weak var eventDatePlaceholderEditMode: UILabel!
    @IBOutlet weak var setDateButton: UIButton!
    @IBOutlet weak var eventPlatformPlaceholderEditMode: UILabel!
    @IBOutlet weak var setPlatformButton: UIButton!
    @IBOutlet weak var inviteLinkPlaceholder: UILabel!
    @IBOutlet weak var inviteLinkTextfield: UITextField!
    @IBOutlet weak var eventDatePickerContainer: UIView!
    @IBOutlet weak var eventDateDoneButton: UIButton!
    @IBOutlet weak var eventDateSelectLabel: UILabel!
    @IBOutlet weak var platformPickerContainer: UIView!
    @IBOutlet weak var platformSelectDoneButton: UIButton!
    @IBOutlet weak var platformSelectLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var createBookClubButton: UIButton!

    @IBOutlet weak var bookCoverBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var platformPickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventPickerBottomConstraint: NSLayoutConstraint!

    var bookTitle: String?
    var bookCoverUrl: String?
    var createMode: Bool? 
    var bookClubModel: BookClub?

    fileprivate var platformPicker: UIPickerView!
    fileprivate var eventDatePicker: UIDatePicker!
    private let platformsArray: [String] = Platforms.platformsArray

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBookClubModel()
        configureUI()
        bookClubName.delegate = self
        inviteLinkTextfield.delegate = self
    }

    // MARK: - UI
    private func configureUI() {
        configureNavbar()
        configureBookCover()
        configureBookCoverGesture()
        configureFinishEditingButton()
        configurePickers()
        setStrings()
        configureAfterBookClub()
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

    private func configureCreateBookClubButton() {
        createBookClubButton.setTitle(NSLocalizedString(K.ButtonTiles.done, comment: ""), for: .normal)
        createBookClubButton.layer.cornerRadius = finishEditingButton.frame.height / 2.0
        createBookClubButton.clipsToBounds = true
    }

    private func configurePickers() {
        // make sure there are no duplicate overlaping pickers
        platformPicker?.removeFromSuperview()
        eventDatePicker?.removeFromSuperview()
        // create and pin pickers
        platformPicker = UIPickerView(frame: .zero)
        platformPicker.delegate = self
        platformPicker.dataSource = self
        pin(picker: platformPicker, inParent: platformPickerContainer, chainToButton: platformSelectDoneButton)
        eventDatePicker = UIDatePicker(frame: .zero)
        eventDatePicker.minimumDate = Date()
        eventDatePicker.date = Date()
        pin(picker: eventDatePicker, inParent: eventDatePickerContainer, chainToButton: eventDateDoneButton)
        if #available(iOS 13.4, *) {
            eventDatePicker.preferredDatePickerStyle = .wheels
        }
    }

    private func setStrings() {
        // Picker texts
        platformSelectLabel.text = K.LabelTexts.pleaseSelectPlatform
        eventDateSelectLabel.text = K.LabelTexts.pleaseSetDate
        platformSelectDoneButton.setTitle(NSLocalizedString(K.ButtonTiles.done, comment: ""), for: .normal)
        setDateButton.setTitle(NSLocalizedString(K.ButtonTiles.done, comment: ""), for: .normal)

        // Edit view texts
        eventDatePlaceholderEditMode.text = NSLocalizedString(K.LabelTexts.eventDate, comment: "")
        eventPlatformPlaceholderEditMode.text =
            NSLocalizedString(K.LabelTexts.eventPlatform, comment: "")
        inviteLinkPlaceholder.text = NSLocalizedString(K.LabelTexts.inviteLink, comment: "")

        // Guest view texts
        eventDatePlaceholder.text = NSLocalizedString(K.LabelTexts.eventDate, comment: "")
        eventPlatformPlaceholder.text =
            NSLocalizedString(K.LabelTexts.eventPlatform, comment: "")
        dateLabel.text = ""
        platformLabel.text = ""
        inviteLinkButton.setTitle(NSLocalizedString(K.LabelTexts.editions, comment: ""), for: .normal)
    }

    private func configureAfterBookClub() {
        if createMode == true {
            // Setup everything here
        }
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
            self.view.endEditing(true)
            self.toggleEditing(editMode: false)
        }
    }

    @IBAction func inviteLinkButtonPressed(_ sender: UIButton) {
    }

    @IBAction func createBookClubPressed(_ sender: UIButton) {
        sender.showAnimation {
            self.createBookClub()
        }
    }


    @IBAction func setDateButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        showPicker(fromContainer: eventDatePickerContainer, bottomConstraint: eventPickerBottomConstraint)
    }

    @IBAction func selectDateDonePressed(_ sender: UIButton) {
        hidePicker(fromContainer: eventDatePickerContainer, bottomConstraint: eventPickerBottomConstraint)
    }

    @IBAction func setPlatformButtonPressed(_ sender: Any) {
        view.endEditing(true)
        showPicker(fromContainer: platformPickerContainer, bottomConstraint: platformPickerBottomConstraint)
        //        let currentlySelectedCountryIndex = countries.firstIndex(where: { $0.countryCode == self.holiday?.countryCode }) ?? 0
        //        countryPicker.selectRow(currentlySelectedCountryIndex, inComponent: 0, animated: false)
    }

    @IBAction func selectPlatformDonePressed(_ sender: UIButton) {
        let selectedRow = platformPicker.selectedRow(inComponent: 0)
        hidePicker(fromContainer: platformPickerContainer, bottomConstraint: platformPickerBottomConstraint)
    }

    // MARK: - Helpers

    private func configureBookClubModel() {
        if createMode == true {
            self.bookClubModel = BookClubService.shared.getDefaultBookClub()
        }
    }

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
            bookClubName.layer.borderWidth = 0
            bookClubName.backgroundColor = UIColor(named: "pink")?.withAlphaComponent(0.85)
            bookClubName.textColor = .white
            bookClubName.tintColor = .white
        } else {
            bookClubName.isEnabled = false
            bookClubName.borderStyle = .none
            bookClubName.backgroundColor = .clear
            bookClubName.textColor = .white
            bookClubName.tintColor = .white
        }
        inviteLinkTextfield.placeholder = NSLocalizedString(K.LabelTexts.inviteLinkPlaceholder, comment: "")
    }

    private func createBookClub() {
        guard let safeBookClubModel = bookClubModel else { return }
        safeBookClubModel.bookClubName = bookClubName.text ?? ""
        safeBookClubModel.bookTitle = bookTitle ?? "Povestea mea"
        safeBookClubModel.eventURL = inviteLinkTextfield.text ?? ""
        safeBookClubModel.owner = Auth.auth().currentUser?.uid ?? ""
        safeBookClubModel.eventInviteList = []
        safeBookClubModel.eventGuests = []
        safeBookClubModel.eventDate = eventDatePicker.date
        safeBookClubModel.eventPlatform = Platforms.platformsArray[platformPicker.selectedRow(inComponent: 0)]

        BookClubService.shared.createBookClub(bookClub: bookClubModel!) { result, error in
            if let error = error {
                print("Error creating book club, \(error.localizedDescription)")
            }
            AppNavigationHelper.sharedInstance.navigateToMainPage()
        }
    }

    // MARK: Picker

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        if blurView.isHidden {
            view.endEditing(true)
        } else {
            if !platformPickerContainer.isHidden {
                setPlatformButtonPressed(self)
            }
        }
    }

    private func showPicker(fromContainer container: UIView, bottomConstraint: NSLayoutConstraint) {
        blurView.isHidden = false
        container.isHidden = false
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    private func hidePicker(fromContainer container: UIView, bottomConstraint: NSLayoutConstraint) {
        bottomConstraint.constant = -container.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.blurView.isHidden = true
            container.isHidden = true
        })
    }

    private func pin(picker: UIView, inParent parentView: UIView, chainToButton button: UIButton) {
        picker.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(picker)
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            picker.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            picker.topAnchor.constraint(equalTo: button.bottomAnchor)
        ])
    }

    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifiers.inviteToBookInfo {
            let resultsVC = segue.destination as! ResultsViewController
            resultsVC.flag = false
            let safeBookTitle: String = bookTitle ?? NSLocalizedString(K.LabelTexts.noBookFound, comment: "")
            resultsVC.titleLabelVar = safeBookTitle
            resultsVC.titleArray = safeBookTitle.components(separatedBy: " ")
        }
    }
}

extension BookClubInviteViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return platformsArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return platformsArray[row]
    }
}
