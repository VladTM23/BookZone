//
//  RadioButtonsViewController.swift
//  BookZone
//
//  Created by Alexandra-Gabriela Laicu-Hausberger on 25/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class RadioButtonsViewController: UIViewController {
    
    let reuseIdentifier = "radioButton"
    
    var titleArray: [String]?
    var titleString: String?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
         performSegue(withIdentifier: K.Identifiers.resultVCIdentifierFromRadio, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.delegate = self
        collectionView.dataSource = self

        configureUI()
    }
    
    func configureUI(){
        
        cofigureCellView()
        configureButton()
        titleLabel.text = titleString
        
    }
    
    func configureButton(){
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        searchButton.layer.cornerRadius = 15
    }
    
    func cofigureCellView(){
    
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
              layout.itemSize = CGSize(width: screenWidth/3, height: 50)
              layout.scrollDirection = .vertical
              collectionView.collectionViewLayout = layout
    }
    
}

//MARK: - UICollectionView

extension RadioButtonsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray?.count ?? 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! RadioButtonCollectionViewCell
               
        // Use the outlet in our custom class to get a reference to the UILabel in the cel
        configureCell(cell: cell, index: indexPath.item)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
           return 20
       }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
           return UIEdgeInsets( top:10, left: 50,  bottom:10, right: 50)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    
        let cell = collectionView.cellForItem(at: indexPath) as! RadioButtonCollectionViewCell
        
        if cell.radioButton.image == UIImage(named: "ticked") {
             cell.radioButton.image = UIImage(named: "unticked")
        }
            else{
             cell.radioButton.image = UIImage(named: "ticked")
        }
        
        let selectedWord = cell.radioLabel.text!
        
        if (titleArray?.contains(selectedWord))!{
            
            let index = (titleArray?.firstIndex(of: selectedWord))!
            titleArray?.remove(at: index)
        }
        else {
            titleArray?.append(selectedWord)
        
        }
        titleString = titleArray?.joined(separator: " ")
                   titleLabel.text = titleString
        
    }
    
}

 //MARK:- configuring functions

extension RadioButtonsViewController {
    
    func configureCell( cell : RadioButtonCollectionViewCell, index: Int) {
        
        cell.radioLabel.text = titleArray?[index]
        cell.radioButton.image = UIImage(named: "ticked")
        cell.layer.borderWidth = 1
        cell.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        cell.layer.cornerRadius = 15
        
    }
}

 //MARK:- PREPARE FOR SEGUE

extension RadioButtonsViewController {
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == K.Identifiers.resultVCIdentifierFromRadio {
        let resultsVC = segue.destination as! ResultsViewController
      
        resultsVC.titleLabelVar = titleString
        resultsVC.titleArray = titleArray
    }
}
}


