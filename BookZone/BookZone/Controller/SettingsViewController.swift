//
//  SettingsViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

private let reuseIdentifier = K.ReuseIdentifiers.settingsCell

protocol SettingsViewControllerDelegate: class {
    func settingsController(_ controller: SettingsViewController, wantsToUpdate user: User)
}

class SettingsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var navbarView: NavbarView!
    @IBOutlet weak var tableView: UITableView!

    private var user: User?

    private var headerView: SettingsHeader!
    private let settingsFooter = SettingsFooter()
    private let imagePicker = UIImagePickerController()
    private var imageIndex = 0

    weak var delegate: SettingsViewControllerDelegate?

    // MARK: - Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func commonInit(user: User) {
        self.user = user
        headerView = SettingsHeader(user: user)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        configureUI()
    }

    // MARK: - API

    func uploadImage(image: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving image"
        hud.show(in: view)

        Service.uploadImage(image: image) { (imageUrl) in
            self.user!.imageURLs.append(imageUrl)
            hud.dismiss()
        }
    }

    // MARK: - Helpers

    func configureUI() {
        headerView.delegate = self
        imagePicker.delegate = self
        configureNavbar()

        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = UIColor(named: K.Colors.kaki)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 350)

        tableView.tableFooterView = settingsFooter
        settingsFooter.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        settingsFooter.delegate = self
    }
    

    func setHeaderImage(_ image: UIImage?) {
        headerView.buttons[imageIndex].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }

    func configureNavbar() {
        navbarView.titleLabelNavbar.text = K.NavbarTitles.profileSettings
    }
}

//MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        guard let section = SettingsSection(rawValue: indexPath.section) else { return cell }
        let viewModel = SettingsViewModel(user: user!, section: section)
        cell.viewModel = viewModel
        cell.delegate = self
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingsSection(rawValue: section) else { return nil }
        return section.description
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let section = SettingsSection(rawValue: indexPath.section) else { return 0 }
        return 44
    }
}

// MARK: - SettingsHeaderDelegate

extension SettingsViewController: SettingsHeaderDelegate {
    func settingsHeader(_ header: SettingsHeader, didSelect index: Int) {
        self.imageIndex = index
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }

        uploadImage(image: selectedImage)
        setHeaderImage(selectedImage)

        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: SettingsCellDelegate {
    func settingsCell(_ cell: SettingsCell, wantsToUpdateUserWith value: String, for section: SettingsSection) {
        switch section{
        case .name:
            user?.name = value
        case .age:
            user?.age = Int(value) ?? user!.age
        case .bio:
            user?.bio = value
        case .favBook:
            user?.favBook = value
        }
    }
}

extension SettingsViewController: SettingsFooterDelegate {
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch {
            print("Failed to sign out")
        }
    }

    func handleDone() {
        view.endEditing(true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Your Data"
        hud.show(in: view)

        Service.saveUserData(user: user!) { (error) in
            self.delegate?.settingsController(self, wantsToUpdate: self.user!)
        }
    }
}

