//
//  BookShelfViewController.swift
//  BookZone
//
//  Created by Alexandra-Gabriela Laicu-Hausberger on 15.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class BookShelfViewController: UIViewController {

    @IBOutlet weak var navbarView: NavbarView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let reuseIdentifier = K.ReuseIdentifiers.bookshelf
    
    var user: User?
    private var books: [Book]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchUserBooks()
        configureUi()
        
    }
    

    
    func configureUi(){
        configureNavBar()
    }
    
    func configureNavBar() {
        navbarView.titleLabelNavbar.text = K.NavbarTitles.bookshelfTitle
    }
    
    
    private func fetchUserBooks() {
        guard let user = user else {return}
        Service.fetchUserBooks(withArray: user.selectedBooks) { (books) in
            self.books=books
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionView

extension BookShelfViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! BookShelfCollectionViewCell
        
        cell.bookshelfCell.bookAuthor.text = "Ale"
        cell.bookshelfCell.bookCover.sd_setImage(with: URL(string: (books?[indexPath.item].imageURL)!))
        cell.bookshelfCell.bookTitle.text = books?[indexPath.item].title
        cell.bookshelfCell.bookRating.text = books?[indexPath.item].rating
        
        
        
        if (indexPath.item % 2 == 0 ) {
            cell.bookshelfCell.backgroundColor = UIColor(patternImage: UIImage (named:"yellowBookshelf")!)
        }
        else {
            cell.bookshelfCell.backgroundColor = UIColor(patternImage: UIImage (named:"pinkBookshelf")!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = UIScreen.main.bounds.size.width
        return CGSize(width:cellWidth, height:cellWidth/3)
    }
    
    
    
}
