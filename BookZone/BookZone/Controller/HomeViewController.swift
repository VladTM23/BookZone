//
//  HomeViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import Firebase

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    private var user: User?

    var bookTitle: String!
    var bookTitleArray: [String]!
    let imagePicker = UIImagePickerController()

    // MARK: - IBOutlets
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookShelfButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
        
        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        fetchUser()
    }

    // MARK: - User Interface

    func configureUI() {
        configureMainButton()
        configureQuote()
    }

    func configureMainButton() {
        mainButton.layer.borderColor = UIColor(named: K.Colors.kaki)?.cgColor
        mainButton.layer.borderWidth = 10
    }
    
    func configureQuote() {
        
        let randomId = Int.random(in: 0..<K.Quotes.quotes.count)
        quoteLabel.text = K.Quotes.quotes[randomId]
        authorLabel.text = K.Quotes.authors[randomId]
    }

    // MARK: - API

    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            self.user = user
        }
    }

    // MARK: - IBActions

    @IBAction func mainCameraTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func searchButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: K.Identifiers.searchVCIdentifier, sender: self)
    }

    @IBAction func profileButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: K.Identifiers.goToProfileSettings, sender: self)
    }

    @IBAction func bookShelfButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: K.Identifiers.goToBookshelf, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.Identifiers.resultsVCIdentifier {
            let resultsVC = segue.destination as! ResultsViewController
            resultsVC.titleLabelVar = bookTitle
            resultsVC.titleArray = bookTitleArray
        }
        
        else if segue.identifier == K.Identifiers.radioButtonsIdentifier {
            
            let radioVC = segue.destination as! RadioButtonsViewController
            radioVC.titleArray = bookTitleArray
            radioVC.titleString = bookTitle
        }

        else if segue.identifier == K.Identifiers.goToProfileSettings {
            guard let user = user else { return }
            let profileSettingsVC = segue.destination as! SettingsViewController
            profileSettingsVC.delegate = self
            profileSettingsVC.commonInit(user: user)
        }
    }
}

//MARK: - Link to PickerController

extension HomeViewController {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage {

            guard let cgImage = image.cgImage else {return}

            let textReader = AppleTextRecognizer()
            textReader.textRecognize(cgImage : cgImage)

            let textArray = textReader.getStrings()
            var stringFromArray = ""
            for element in textArray {
                stringFromArray = stringFromArray + " " + element
            }
            print(stringFromArray)
            self.bookTitle = stringFromArray
            self.bookTitleArray = textArray
            
        }

        imagePicker.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: K.Identifiers.radioButtonsIdentifier, sender: self)
    }
}

//MARK: - SettingsControllerDelegate

extension HomeViewController: SettingsViewControllerDelegate {

    func settingsController(_ controller: SettingsViewController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
    }
}


