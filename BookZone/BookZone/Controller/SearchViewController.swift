//
//  SearchViewController.swift
//  BookZone
//
//  Created by Alexandra-Gabriela Laicu-Hausberger on 14/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties

    var bookTitle: String!
    var bookTitleArray: [String]!
    var flag:Bool!
    var ISBN:String!

    // MARK: - IBOutlest
    
    @IBOutlet weak var navBarView: NavbarView!
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var titleSwitchLabel: UILabel!
    @IBOutlet weak var isbnSwitchLabel: UILabel!
    @IBOutlet weak var searchSwitch: UISwitch!
    @IBOutlet weak var getRecommendationsButton: UIButton!
    @IBOutlet weak var inspirationLabel: UILabel!

    @IBAction func switchToggled(_ sender: UISwitch) {
        if(sender.isOn){
            titleSwitchLabel.alpha = CGFloat(0.5)
            isbnSwitchLabel.alpha = CGFloat(1)
            searchBar.searchTextField.placeholder = NSLocalizedString(K.LabelTexts.searchByISBN, comment: "")
            searchBar.buttonImageView.image = UIImage(named: K.ImageNames.pinkBackground)
            searchBar.searchImageView.image = UIImage(named: K.ImageNames.pinkBackground)
            flag = true
        }
        else {
            titleSwitchLabel.alpha = CGFloat(1)
            isbnSwitchLabel.alpha = CGFloat(0.5)
            sender.tintColor = #colorLiteral(red: 0.5370000005, green: 0.7879999876, blue: 0.7220000029, alpha: 1)
            sender.layer.cornerRadius = sender.frame.height / 2
            sender.backgroundColor = #colorLiteral(red: 0.5370000005, green: 0.7879999876, blue: 0.7220000029, alpha: 1)
            
            searchBar.searchTextField.placeholder = NSLocalizedString(K.LabelTexts.searchByTitle, comment: "")
            searchBar.searchImageView.image = UIImage(named: K.ImageNames.yellowBackground)
            searchBar.buttonImageView.image = UIImage(named: K.ImageNames.yellowBackground)
            flag = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchTextField.delegate = self
        addSearchFunctionalityForButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureUI()
    }

    // MARK: - User interface
    private func configureUI() {
        configureNavBar()
        configureSearchBar()
        configureSwitchAndLabels()
        configureInspirationLabel()
        configureRecommendationsButton()
    }
    
    private func configureSwitchAndLabels() {
        isbnSwitchLabel.alpha = CGFloat(0.5)
        searchSwitch.setOn(false, animated: true)
        searchSwitch.isOn = false
        switchToggled(searchSwitch)
    }

    private func configureNavBar() {
        navBarView.titleLabelNavbar.text = NSLocalizedString(K.NavbarTitles.searchTitle, comment: "")
    }
    
    private func configureSearchBar(){
        searchBar.buttonView.layer.borderColor = UIColor(named: K.Colors.kaki)?.cgColor
        searchBar.buttonView.layer.borderWidth = 3
        searchBar.buttonView.layer.cornerRadius = 15
        searchBar.buttonImageView.layer.cornerRadius = 15
        searchBar.searchButton.layer.cornerRadius = 15
        
        searchBar.searchView.layer.cornerRadius = 15
        searchBar.searchImageView.layer.cornerRadius = 15
    }

    private func configureRecommendationsButton() {
        getRecommendationsButton.setTitle(NSLocalizedString(K.ButtonTiles.getRecommendations, comment: ""), for: .normal)
        getRecommendationsButton.layer.cornerRadius = getRecommendationsButton.frame.height / 2.0
        getRecommendationsButton.clipsToBounds = true
    }

    private func configureInspirationLabel() {
        inspirationLabel.text = NSLocalizedString(K.LabelTexts.lookingForInspiration, comment: "")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func recommendationButtonPressed(_ sender: UIButton) {
        sender.showAnimation {
            if !ReachabilityManager.shared.hasConnectivity() {
                let alert = UIAlertController(title: NSLocalizedString(K.ButtonTiles.noInternetTitle, comment: ""), message: NSLocalizedString(K.Errors.internetError, comment: "") , preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                self.performSegue(withIdentifier: K.Identifiers.searchToRecommendations, sender: self)
            }
        }
    }

}
// MARK: - SearchBar

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.searchTextField.endEditing(true)
        return true
    }
    
    func addSearchFunctionalityForButton() {
        searchBar.searchButton.addTarget(self, action: #selector(searchButtonReleased), for: .touchUpInside)
        searchBar.searchButton.addTarget(self, action: #selector(searchButtonReleased), for: .touchDragExit)
        searchBar.searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchDown)
    }
    
    @objc func searchButtonPressed () {
        //searchBar.searchTextField.endEditing(true)
        
        if (searchBar.buttonImageView.image == UIImage(named: K.ImageNames.yellowBackground) ){
            searchBar.buttonImageView.image = UIImage(named: K.ImageNames.pinkBackground)
        }
        else {
            searchBar.buttonImageView.image = UIImage(named: K.ImageNames.yellowBackground)
        }
    }
    
    @objc func searchButtonReleased () {
        searchBar.searchTextField.endEditing(true)
        
        if (searchBar.buttonImageView.image == UIImage(named: K.ImageNames.yellowBackground) ){
            searchBar.buttonImageView.image = UIImage(named: K.ImageNames.pinkBackground)
        }
        else {
            searchBar.buttonImageView.image = UIImage(named: K.ImageNames.yellowBackground)
        }

        if flag == true {
            self.ISBN = searchBar.searchTextField.text
        }
        else {
            self.bookTitle = searchBar.searchTextField.text
            self.bookTitleArray = bookTitle.components(separatedBy: " ")
        }

        if searchBar.searchTextField.text != "" {
            if flag == true {
                if searchBar.searchTextField.text?.count == 13 || searchBar.searchTextField.text?.count == 10 {
                    performSegue(withIdentifier: K.Identifiers.resultVCIdentifierFromSearch, sender: self)
                }
                else {
                    searchBar.searchTextField.text = ""
                    searchBar.searchTextField.placeholder = NSLocalizedString(K.LabelTexts.invalidISBNStringPlaceholder, comment: "")
                }
            }
            else {
                performSegue(withIdentifier: K.Identifiers.resultVCIdentifierFromSearch, sender: self)
            }
        }
        else {
            searchBar.searchTextField.placeholder = NSLocalizedString(K.LabelTexts.emptyStringPlaceholder, comment: "")
        }
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchBar.searchTextField.endEditing(true)
        print(textField.text!)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height/2
        }
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += keyboardFrame.height/2
        }
    }
}

// MARK: - Perform segue
extension SearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifiers.resultVCIdentifierFromSearch {
            let resultsVC = segue.destination as! ResultsViewController
            resultsVC.ISBN = ISBN
            resultsVC.flag = flag
            resultsVC.titleLabelVar = bookTitle
            resultsVC.titleArray = bookTitleArray
        }
    }
}
