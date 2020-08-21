//
//  SearchViewController.swift
//  BookZone
//
//  Created by Alexandra-Gabriela Laicu-Hausberger on 14/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var navBarView: NavbarView!
    @IBOutlet weak var searchBar: SearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchTextField.delegate = self
        
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
        
        searchBar.searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
    }
    
    @objc func searchButtonPressed () {
        searchBar.searchTextField.endEditing(true)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Please write a title"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text!)
    }
    
    
}
