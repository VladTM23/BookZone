//
//  AppSettingsViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 30.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class AppSettingsViewController: UIViewController {

    @IBOutlet weak var navBarView: NavbarView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageDropdown: Dropdown!
    @IBOutlet weak var appPrefferedLanguageLabel: UILabel!
    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var doneToolbar: UIToolbar!
    @IBOutlet weak var userLanguagePicker: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pickerHeight: NSLayoutConstraint!

    var languagesArray = [K.Languages.english, K.Languages.romana]
    var pickerData: PickerData?

    override func viewDidLoad() {
        super.viewDidLoad()

        userLanguagePicker.delegate = self
        userLanguagePicker.dataSource = self
        setUserLanguage()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        configurePickerViews()
    }

    private func configureUI() {
        configureNavbar()
        configureDropdown()
        configureLabels()
    }

    private func configureNavbar() {
        navBarView.titleLabelNavbar.text = NSLocalizedString(K.NavbarTitles.appSettingsTitle, comment: "")
    }

    private func configureLabels() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String

        languageLabel.text = NSLocalizedString("language", comment: "")
        appPrefferedLanguageLabel.text = NSLocalizedString("prefLanguage", comment: "")
        tutorialButton.setTitle(NSLocalizedString("goToTutorial", comment: ""), for: .normal)
        creditsLabel.text = NSLocalizedString("credits", comment: "")
        creditsLabel.isUserInteractionEnabled = true
        versionLabel.text = "\(NSLocalizedString("versions", comment: "")) \(appVersion!) (\(build!))"

        creditsAction()
    }

    private func configureDropdown() {
        let userLanguage = UserDefaults.standard.string(forKey: K.UserKeys.userLanguage)
        var labelLanguage = ""

        switch userLanguage {
        case K.Languages.en:
            labelLanguage = K.Languages.english
        case K.Languages.ro:
            labelLanguage = K.Languages.romana
        default:
            labelLanguage = K.Languages.english
        }

        languageDropdown.dropDownView.backgroundColor = UIColor(named: "pink")
        languageDropdown.dropDownLabel.text = UserDefaults.standard.string(forKey: K.UserKeys.userLanguage)
        languageDropdown.setupShadow()

        let userLanguageTap = UITapGestureRecognizer(target: self, action: #selector(self.userLanguageDropdownPressed))

        languageDropdown.addGestureRecognizer(userLanguageTap)
    }

    private func configurePickerViews() {
        let userLanguageRow = UserDefaults.standard.integer(forKey: K.UserKeys.userLanguageRow)
        self.userLanguagePicker.selectRow(userLanguageRow, inComponent: 0, animated: false)
    }

    private func creditsAction() {
        let creditsTap = UITapGestureRecognizer(target: self, action: #selector(creditsTapped))

        creditsLabel.addGestureRecognizer(creditsTap)
    }

    //MARK: - Actions

    @objc func creditsTapped() {
        performSegue(withIdentifier: K.Identifiers.credits, sender: self)
    }

    @objc func userLanguageDropdownPressed() {
        configurePickerViews()
        doneToolbar.isHidden = !doneToolbar.isHidden
        userLanguagePicker.isHidden = !userLanguagePicker.isHidden
        scrollView.scrollToBottom(animated: true)

        pickerHeight.constant = doneToolbar.isHidden ? 0 : 190
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func redoTutorial(_ sender: Any) {
        performSegue(withIdentifier: K.Identifiers.redoTutorial, sender: self)
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        userLanguagePicker.isHidden = true
        doneToolbar.isHidden = true
        handleDonePressed()
    }


    // MARK: - Helpers

    func handleDonePressed() {
        let currentLanguage = UserDefaults.standard.string(forKey: K.UserKeys.userLanguage)
        var differentLanguageFlag = false

        if let pickerSelectedData = pickerData {

            setupUserValues(userLanguage: pickerSelectedData.pickerLanguage,
                                   shortLanguage: pickerSelectedData.pickerShortLanguage,
                                   rowNumber: pickerSelectedData.pickerSelectedRow)
            languageDropdown.dropDownLabel.text =
                languagesArray[UserDefaults.standard.integer(forKey: K.UserKeys.userLanguageRow)]

            differentLanguageFlag = currentLanguage! != pickerSelectedData.pickerLanguage ? true : false
            if differentLanguageFlag {
                switchLanguageInApp(language:
                                        UserDefaults.standard.string(forKey:
                                                                        K.UserKeys.userShortLanguage)!,
                                    deadline: 0.3)
            }
        }
    }

    func setUserLanguage() {
        let userLanguage = Bundle.main.preferredLocalizations.first! as String
        let selectionMade = UserDefaults.standard.bool(forKey: K.UserKeys.languageSelectionMade)

        if !selectionMade {
            switch userLanguage {
            case K.Languages.ro:
                setupDefaultUserLanguageSettings(userPhoneLanguage: languagesArray[1])
            default:
                setupDefaultUserLanguageSettings(userPhoneLanguage: languagesArray[0])
            }
        }
    }

    private func reloadRootVC() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeScreen = storyboard.instantiateViewController(withIdentifier:
                                                                K.Identifiers.homeVC)
        let options = storyboard.instantiateViewController(withIdentifier:
                                                            K.Identifiers.reloadSettings)
        options.modalPresentationStyle = .fullScreen
        homeScreen.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =
            storyboard.instantiateInitialViewController()
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.present(
            homeScreen, animated: false, completion: nil)
        homeScreen.present(options, animated: false, completion: nil)

    }

   private func switchLanguageInApp(language: String, deadline: Double) {
        Bundle.setLanguage(language)
        DispatchQueue.main.asyncAfter(deadline: .now() + deadline) {
            self.reloadRootVC()
        }
    }
}

//MARK: - Picker

extension AppSettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languagesArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languagesArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var shorthandLanguage: String = ""
        switch languagesArray[row] {
        case K.Languages.romana:
            shorthandLanguage = K.Languages.ro
        default:
            shorthandLanguage = K.Languages.en
        }
        let pickerSelectedData = PickerData(pickerLanguage: languagesArray[row],
                                            pickerShortLanguage: shorthandLanguage,
                                            pickerSelectedRow: row)
        pickerData = pickerSelectedData
    }
}

//MARK: - Picker language

extension AppSettingsViewController {

    func setupDefaultUserLanguageSettings(userPhoneLanguage: String) {
        UserDefaults.standard.set(userPhoneLanguage, forKey: K.UserKeys.userLanguage)
        let languageIndex = languagesArray.firstIndex(of: userPhoneLanguage)! as Int
        UserDefaults.standard.set(languageIndex, forKey: K.UserKeys.userLanguageRow)
    }

    func setupUserValues(userLanguage: String, shortLanguage: String, rowNumber: Int) {
        UserDefaults.standard.set(true, forKey: K.UserKeys.languageSelectionMade)
        UserDefaults.standard.set(userLanguage, forKey: K.UserKeys.userLanguage)
        UserDefaults.standard.set(shortLanguage, forKey: K.UserKeys.userShortLanguage)
        UserDefaults.standard.set(rowNumber, forKey: K.UserKeys.userLanguageRow)
    }
}
