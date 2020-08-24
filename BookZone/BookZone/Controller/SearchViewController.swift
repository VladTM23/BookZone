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

     // MARK: - IBOutlest
    
    @IBOutlet weak var navBarView: NavbarView!
    @IBOutlet weak var searchBar: SearchBar!
    
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
        searchBar.buttonImageView.image = UIImage(named: "pinkCardBackground")
        print("pressed")
    }
    
    @objc func searchButtonReleased () {
        searchBar.searchTextField.endEditing(true)
        searchBar.buttonImageView.image = UIImage(named: "yellowCardBackground")
        
        self.bookTitle = searchBar.searchTextField.text
        self.bookTitleArray = bookTitle.components(separatedBy: " ")
        
        if searchBar.searchTextField.text != "" {
            performSegue(withIdentifier: K.Identifiers.resultVCIdentifierFromSearch, sender: self)
        } else {
           searchBar.searchTextField.placeholder = "Please write a title"
        }
        
        print(bookTitleArray)
    
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
            resultsVC.titleLabelVar = bookTitle
            resultsVC.titleArray = bookTitleArray
        }
    }
    
}
