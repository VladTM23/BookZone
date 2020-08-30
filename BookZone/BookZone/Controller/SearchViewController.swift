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
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        
        if(sender.isOn){
            titleSwitchLabel.alpha = CGFloat(0.5)
            isbnSwitchLabel.alpha = CGFloat(1)
            searchBar.searchTextField.placeholder = K.LabelTexts.searchByISBN
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
            
            searchBar.searchTextField.placeholder = K.LabelTexts.searchByTitle
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

    func configureUI() {
        configureNavBar()
        configureSearchBar()
        configureSwitchAndLabels()
    }
    
    func configureSwitchAndLabels() {
        
        isbnSwitchLabel.alpha = CGFloat(0.5)
        searchSwitch.setOn(false, animated: true)
        searchSwitch.isOn = false
        switchToggled(searchSwitch)
    }

    func configureNavBar() {
        navBarView.titleLabelNavbar.text = K.NavbarTitles.searchTitle
    }
    
    func configureSearchBar(){
        
        searchBar.buttonView.layer.borderColor = UIColor(named: K.Colors.kaki)?.cgColor
        searchBar.buttonView.layer.borderWidth = 3
        searchBar.buttonView.layer.cornerRadius = 15
        searchBar.buttonImageView.layer.cornerRadius = 15
        searchBar.searchButton.layer.cornerRadius = 15
        
        searchBar.searchView.layer.cornerRadius = 15
        searchBar.searchImageView.layer.cornerRadius = 15
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
        print("pressed")
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
                    searchBar.searchTextField.placeholder = K.LabelTexts.invalidISBNStringPlaceholder
                    }
            }
          else {
                  performSegue(withIdentifier: K.Identifiers.resultVCIdentifierFromSearch, sender: self)
            }
        }
        else {
            searchBar.searchTextField.placeholder = K.LabelTexts.emptyStringPlaceholder
        }
        
    
        print("pressed")
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchBar.searchTextField.endEditing(true)
        print(textField.text!)
    }
    
    // moving the keyboard
    
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


    //MARK: - Perform segue

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
