//
//  BookShelfViewController.swift
//  BookZone
//
//  Created by Alexandra-Gabriela Laicu-Hausberger on 15.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class BookShelfViewController: UIViewController {

    @IBOutlet weak var navbarView: NavbarView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let reuseIdentifier = K.ReuseIdentifiers.bookshelf
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        configureUi()
        

    }
    
    func configureUi(){
        configureNavBar()
    }
    
    func configureNavBar() {
        navbarView.titleLabelNavbar.text = K.NavbarTitles.bookshelfTitle
    }
    

}

//MARK: - UICollectionView

extension BookShelfViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! BookShelfCollectionViewCell
        
        cell.bookshelfCell.bookAuthor.text = "Ale"
        cell.bookshelfCell.bookCover.image = UIImage(named: "homeGirl")
        cell.bookshelfCell.bookTitle.text = "Love"
        cell.bookshelfCell.bookRating.text = "5.5"
        
        
        
        if (indexPath.item % 2 == 0 ) {
            cell.bookshelfCell.backgroundColor = UIColor(patternImage: UIImage (named:"yellowCardBackground")!)
        }
        else {
            cell.bookshelfCell.backgroundColor = UIColor(patternImage: UIImage (named:"pinkCardBackground")!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = UIScreen.main.bounds.size.width
        return CGSize(width:cellWidth, height:cellWidth/3)
    }
    
    
    
}
