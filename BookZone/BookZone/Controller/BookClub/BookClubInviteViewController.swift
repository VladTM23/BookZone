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
import SafariServices

class BookClubInviteViewController: UIViewController {

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
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var inviteFriendsView: UIView!
    @IBOutlet weak var eventGuestsLabel: UILabel!
    @IBOutlet weak var eventGuestsTextfield: UITextField!
    @IBOutlet weak var eventGuestsTableView: UITableView!
    @IBOutlet weak var userSuggestionsTableView: UserSuggestionsTableView!
    
    @IBOutlet weak var bookCoverBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var platformPickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventPickerBottomConstraint: NSLayoutConstraint!

    var bookTitle: String?
    var bookCoverUrl: String?
    var createMode: Bool? 
    var bookClubModel: BookClub?
    var usersArray: [User]?
    var filteredUsers: [User]?
    var invitedUsersArray: [User]?

    fileprivate var platformPicker: UIPickerView!
    fileprivate var eventDatePicker: UIDatePicker!
    private let platformsArray: [String] = Platforms.platformsArray

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        fetchInvitedUsers()
        initUI()
        configureBookClubModel() {
            self.updateUI()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.contentInset.bottom = 0
    }

    // MARK: - UI

    private func initUI() {
        configureNavbar()
        configureTextfields()
        configureTableViews()
        configureBookCover()
        configureBookCoverGesture()
        configureFinishEditingButton()
        configureCreateBookClubButton()
        setStrings()
        addRoundCorners()
    }

    private func updateUI() {
        configurePickers()
        configureAfterBookClub()
        configurePlatformImage()
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

        inviteLinkButton.layer.cornerRadius = inviteLinkButton.frame.height / 2.0
        inviteLinkButton.clipsToBounds = true
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
        platformSelectLabel.text = NSLocalizedString(K.LabelTexts.pleaseSelectPlatform, comment: "")
        eventDateSelectLabel.text = NSLocalizedString(K.LabelTexts.pleaseSetDate, comment: "")
        platformSelectDoneButton.setTitle(NSLocalizedString(K.ButtonTiles.done, comment: ""), for: .normal)
        eventDateDoneButton.setTitle(NSLocalizedString(K.ButtonTiles.done, comment: ""), for: .normal)
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
        inviteLinkButton.setTitle(NSLocalizedString(K.ButtonTiles.startMeeting, comment: ""), for: .normal)
    }

    private func addRoundCorners() {
        editorView.clipsToBounds = true
        editorView.layer.cornerRadius = 2
        guestViewContainer.clipsToBounds = true
        guestViewContainer.layer.cornerRadius = 2
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 2
    }

    private func configureTextfields() {
        bookClubName.delegate = self
        inviteLinkTextfield.delegate = self
        eventGuestsTextfield.delegate = self
        eventGuestsTextfield.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }

    private func configureTableViews() {
        userSuggestionsTableView.delegate = self
        userSuggestionsTableView.dataSource = self
        eventGuestsTableView.delegate = self
        eventGuestsTableView.dataSource = self

        eventGuestsTableView.register(InvitedUsersCell.self, forCellReuseIdentifier: "invitedUserCell")
        eventGuestsTableView.rowHeight = UITableView.automaticDimension
        eventGuestsTableView.estimatedRowHeight = 50.0

        userSuggestionsTableView.register(UserSuggestionsTableViewCell.self, forCellReuseIdentifier: "userSuggestionsCell")
        userSuggestionsTableView.addTableHeaderViewSeparator()
        userSuggestionsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height:  CGFloat.leastNonzeroMagnitude))
        userSuggestionsTableView.rowHeight = UITableView.automaticDimension
        userSuggestionsTableView.estimatedRowHeight = 50.0
    }

    private func configureAfterBookClub() {
        eventDatePicker.date = bookClubModel?.eventDate ?? Date()
        inviteLinkTextfield.text = bookClubModel?.eventURL ?? ""
        let formatter = DateFormatterHelper.getBookClubDateFormatter()
        let eventDate = formatter.string(from: bookClubModel?.eventDate ?? Date(timeIntervalSinceNow: 86400))
        setDateButton.setTitle(eventDate, for: .normal)
        setPlatformButton.setTitle(bookClubModel?.eventPlatform, for: .normal)
        dateLabel.text = eventDate
        platformLabel.text = bookClubModel?.eventPlatform
        bookClubName.text = bookClubModel?.bookClubName ?? NSLocalizedString(K.LabelTexts.insertBookClubName, comment: "")
    }

    private func configurePlatformImage() {
        guard let safeBookClub = bookClubModel else { return }
        switch safeBookClub.eventPlatform {
        case Platforms.platformsArray[0]:
            platformImage.image = UIImage(named: Platforms.platformsImages[0])
        case Platforms.platformsArray[1]:
            platformImage.image = UIImage(named: Platforms.platformsImages[1])
        case Platforms.platformsArray[2]:
            platformImage.image = UIImage(named: Platforms.platformsImages[2])
        case Platforms.platformsArray[3]:
            platformImage.image = UIImage(named: Platforms.platformsImages[3])
        case Platforms.platformsArray[4]:
            platformImage.image = UIImage(named: Platforms.platformsImages[4])
        default:
            platformImage.image = UIImage(named: Platforms.platformsImages[0])
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
        if let safeBookClubModel = bookClubModel {
            if !safeBookClubModel.eventURL.isEmpty {
                if let url = URL(string: safeBookClubModel.eventURL) {
                    if ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
                        // Can open with SFSafariViewController
                        let safariViewController = SFSafariViewController(url: url)
                        self.present(safariViewController, animated: true, completion: nil)
                    } else {
                        showBrokenLinkAlert()
                    }
                } else {
                    showBrokenLinkAlert()
                }
            } else {
                showBrokenLinkAlert()
            }
        } else {
            showBrokenLinkAlert()
        }
    }

    private func showBrokenLinkAlert() {
        let alert = UIAlertController(title: "", message: NSLocalizedString(K.ButtonTiles.noEventLink, comment: "") , preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }

    @IBAction func createBookClubPressed(_ sender: UIButton) {
        sender.showAnimation {
            if !ReachabilityManager.shared.hasConnectivity() {
                let alert = UIAlertController(title: NSLocalizedString(K.ButtonTiles.noInternetTitle, comment: ""), message: NSLocalizedString(K.Errors.internetError, comment: "") , preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                self.createBookClub()
            }
        }
    }

    @IBAction func setDateButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        showPicker(fromContainer: eventDatePickerContainer, bottomConstraint: eventPickerBottomConstraint)
    }

    @IBAction func selectDateDonePressed(_ sender: UIButton) {
        bookClubModel?.eventDate = eventDatePicker.date
        let formatter = DateFormatterHelper.getBookClubDateFormatter()
        let eventDate = formatter.string(from: bookClubModel?.eventDate ?? Date(timeIntervalSinceNow: 86400))
        setDateButton.setTitle(eventDate, for: .normal)
        dateLabel.text = eventDate
        hidePicker(fromContainer: eventDatePickerContainer, bottomConstraint: eventPickerBottomConstraint)
    }

    @IBAction func setPlatformButtonPressed(_ sender: Any) {
        view.endEditing(true)
        showPicker(fromContainer: platformPickerContainer, bottomConstraint: platformPickerBottomConstraint)
        let currentlySelectedPlatformIndex = Platforms.platformsArray.firstIndex(where: { $0 == self.bookClubModel?.eventPlatform }) ?? 0
        platformPicker.selectRow(currentlySelectedPlatformIndex, inComponent: 0, animated: false)
    }

    @IBAction func selectPlatformDonePressed(_ sender: UIButton) {
        let selectedRow = platformPicker.selectedRow(inComponent: 0)
        let selectedPlatform = Platforms.platformsArray[selectedRow]
        bookClubModel?.eventPlatform = selectedPlatform
        setPlatformButton.setTitle(bookClubModel?.eventPlatform, for: .normal)
        platformLabel.text = bookClubModel?.eventPlatform
        platformImage.image = UIImage(named: Platforms.platformsImages[selectedRow])
        hidePicker(fromContainer: platformPickerContainer, bottomConstraint: platformPickerBottomConstraint)
    }

    // MARK: - Helpers

    private func configureBookClubModel(completion: (() -> Void)? = nil) {
        if createMode == true {
            self.bookClubModel = BookClubService.shared.getDefaultBookClub()
            completion?()
        } else {
            completion?()
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
        safeBookClubModel.bookCoverURL = bookCoverUrl ?? ""
        safeBookClubModel.owner = Auth.auth().currentUser?.uid ?? ""
        safeBookClubModel.eventInviteList = getGuestsStringArray()
        safeBookClubModel.eventGuests = getGuestsStringArray()
        safeBookClubModel.eventDate = eventDatePicker.date
        safeBookClubModel.eventPlatform = Platforms.platformsArray[platformPicker.selectedRow(inComponent: 0)]

        BookClubService.shared.createBookClub(bookClub: bookClubModel!) { result, error in
            if let error = error {
                print("Error creating book club, \(error.localizedDescription)")
            }
            AppNavigationHelper.sharedInstance.navigateToMainPage()
        }
    }

    private func fetchUsers() {
        Service.fetchUsers { users in
            self.usersArray = users
        }
    }

    private func fetchInvitedUsers() {
        self.invitedUsersArray = [User]()
    }

    private func getUserSuggestions(for filterName: String, from usersArray: [User]) {
        filteredUsers = [User]()

        for user in usersArray {
            if user.name.lowercased().contains(filterName.lowercased()) {
                filteredUsers?.append(user)
            }
        }
        userSuggestionsTableView.tableHeaderView?.isHidden = filteredUsers?.isEmpty == true
    }

    private func getGuestsStringArray() -> [String] {
        guard let safeInvitedUsersArray = invitedUsersArray else { return [] }
        var userIdsArray = [String]()
        for user in safeInvitedUsersArray {
            userIdsArray.append(user.uid)
        }
        return userIdsArray
    }

    private func selectedSuggestion(for suggestionCell: UserSuggestionsTableViewCell) {
        userSuggestionsTableView.isHidden = true
        eventGuestsTableView.isHidden = false
        if let safeInvitedUsersArray = invitedUsersArray {
            for invitedUser in safeInvitedUsersArray {
                if invitedUser.uid == suggestionCell.userModel?.uid {
                    return
                }
            }
            if let safeUserModel = suggestionCell.userModel {
                invitedUsersArray?.append(safeUserModel)
                eventGuestsTableView.reloadData()
            }
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

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
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

// MARK: - Pickers
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

// MARK: - Textfields
extension BookClubInviteViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case inviteLinkTextfield:
            if let safeTextFieldText = textField.text {
                bookClubModel?.eventURL = safeTextFieldText
            }
        case bookClubName:
            if let safeTextFieldText = textField.text {
                bookClubModel?.bookClubName = safeTextFieldText
            }
        default:
            return
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // Do not add a line break
        return false
    }

    @objc private func textFieldDidChange(textField: UITextField) {
        guard let safeUserText = textField.text, let safeUsers = usersArray else { return }
        // Start suggestions only after at least 3 characters
        if safeUserText.count > 2 {
            getUserSuggestions(for: safeUserText, from: safeUsers)
            userSuggestionsTableView.isHidden = false
            userSuggestionsTableView.reloadData()
            eventGuestsTableView.isHidden = true
        } else {
            userSuggestionsTableView.isHidden = true
        }
    }
}

// MARK: - TableViews

extension BookClubInviteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case eventGuestsTableView:
            return invitedUsersArray?.count ?? 0
        case userSuggestionsTableView:
            return filteredUsers?.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case eventGuestsTableView:
            return UITableView.automaticDimension
        case userSuggestionsTableView:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case userSuggestionsTableView:
            guard let safeFilteredUsers = filteredUsers else { return UITableViewCell.init(frame: .zero) }
            let cell = tableView.dequeueReusableCell(withIdentifier: "userSuggestionsCell", for: indexPath as IndexPath) as!
                UserSuggestionsTableViewCell
            cell.configureCell(with: safeFilteredUsers[indexPath.row])
            return cell
        case eventGuestsTableView:
            guard let safeInvitedUsers = invitedUsersArray else { return UITableViewCell.init(frame: .zero) }
            let cell = tableView.dequeueReusableCell(withIdentifier: "invitedUserCell", for: indexPath as IndexPath) as!
                InvitedUsersCell
            cell.configureCell(with: safeInvitedUsers[indexPath.row])
            return cell
        default:
            return UITableViewCell.init(frame: .zero)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case userSuggestionsTableView:
            let suggestionCell = tableView.cellForRow(at: indexPath) as! UserSuggestionsTableViewCell
            selectedSuggestion(for: suggestionCell)
        default:
            print("You should not be here")
        }
    }
}
