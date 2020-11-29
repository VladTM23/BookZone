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
import SwipeCellKit

class BookShelfViewController: UIViewController {

    @IBOutlet weak var navbarView: NavbarView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let reuseIdentifier = K.ReuseIdentifiers.bookshelf
    
    var user: User?
    private var books: [Book]?
    
    var isRead : Bool?
    var buttonStyle: ButtonStyle = .circular
    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        user?.selectedBooks = UserDefaults.standard.stringArray(forKey : "books")!
        user?.readBooks = UserDefaults.standard.stringArray(forKey : "readBooks")!
        
        fetchUserBooks(isInitial: true)
        configureUi()
        
    }
    

    
    func configureUi(){
        configureNavBar()
        
    }
    
    func configureNavBar() {
        navbarView.titleLabelNavbar.text = K.NavbarTitles.bookshelfTitle
    }
    
    private func fetchUserBooks( isInitial initial : Bool) {
        Service.fetchUserBooks(withArray: UserDefaults.standard.stringArray(forKey : "books")!) { (books) in
            self.books=books
            
            if initial {
                self.collectionView.reloadData()
                self.configureCountLabel()
            }
        }
        
    }
    
    func configureCountLabel() {
        let read = user?.readBooks.count
        let total = user?.selectedBooks.count
        
        navbarView.countLabel.text = "\(read ??  0) / \(total ??  0)"
        navbarView.countLabel.isHidden = false
    }
    
}

//MARK: - UICollectionView

extension BookShelfViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,SwipeCollectionViewCellDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let cell = collectionView.cellForItem(at: indexPath) as! BookShelfCollectionViewCell
        
        if orientation == .right {

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                
                
                let bookID = cell.bookshelfCell.bookID.text!
                if let index = UserDefaults.standard.stringArray(forKey : "books")!.firstIndex(of: bookID) {
                    self.user!.selectedBooks.remove(at: index)
                    
                    for book in self.books! {
                        if book.bid == bookID {
                            if let ind = self.books!.firstIndex(of: book) {
                                self.books!.remove(at: ind)
                                
                                self.collectionView.deleteItems(at: [IndexPath(row: ind, section: 0)])
                                collectionView.reloadData()

                        }
                    }
                    }
                    
                    UserDefaults.standard.set(self.user!.selectedBooks, forKey : "books")
                        
//                    Service.deleteBookData(bookID : bookID) { (error) in
//                        if error != nil {
//                            print("Error when deleting a book to Books collection, \(error?.localizedDescription)")
//                            }
//                        }
                        
                        if ((self.user?.selectedBooks.count)! < 100) {
                            self.user?.achievementsArray[3] = false
                            UserDefaults.standard.set(false, forKey: "achievement4" )
                        }
                    
                        if ((self.user?.selectedBooks.count)! < 25) {
                            self.user?.achievementsArray[2] = false
                            UserDefaults.standard.set(false, forKey: "achievement3" )
                        }
                    
                        if ((self.user?.selectedBooks.count)! < 5) {
                            self.user?.achievementsArray[1] = false
                            UserDefaults.standard.set(false, forKey: "achievement2" )
                        }
                
                    
                        Service.saveUserData(user: self.user!) { (error) in
                            if error != nil {
                                print("Error when adding bookId to user, \(error?.localizedDescription)")
                                
                            }
                        }
                    
                    
                }
            }
            
            configure(action: deleteAction, with: .trash)
            return [deleteAction]
            
            }
        else {
            
            if (self.user?.readBooks.contains(cell.bookshelfCell.bookID.text!) == true){
                self.isRead = true
            }
            else {
                self.isRead = false
            }
            
            let readAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
                
                if self.isRead == false {
                    
                    var auxReadList = UserDefaults.standard.stringArray(forKey : "readBooks")!
                    auxReadList.append(cell.bookshelfCell.bookID.text!)
                    UserDefaults.standard.setValue(auxReadList, forKey: "readBooks")
                    
                    collectionView.reloadData()
                }
                
                else {
                    
                    var auxReadList = UserDefaults.standard.stringArray(forKey : "readBooks")!
                    if let index = auxReadList.firstIndex(of: cell.bookshelfCell.bookID.text!){
                        
                        auxReadList.remove(at: index)
                        UserDefaults.standard.setValue(auxReadList, forKey: "readBooks")
                        
                        collectionView.reloadData()
                        
                    }
                }
               
                self.user?.readBooks = UserDefaults.standard.stringArray(forKey : "readBooks")!
                Service.saveUserData(user: self.user!) { (error) in
                    if error != nil {
                        print("Error when adding bookId to user, \(error?.localizedDescription)")
                            
                    }
                }
                
                
        }
            let descriptor: ActionDescriptor = isRead ?? false ? .read : .unread
            configure(action: readAction, with: descriptor)
            return [readAction]
        }
        
    }
    
    
    

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books?.count ?? 0
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! BookShelfCollectionViewCell
        
        
        cell.delegate = self
        cell.bookshelfCell.bookAuthor.text = "Ale"
        cell.bookshelfCell.bookCover.sd_setImage(with: URL(string: (books?[indexPath.item].imageURL)!))
        cell.bookshelfCell.bookTitle.text = books?[indexPath.item].title
        cell.bookshelfCell.bookRating.text = books?[indexPath.item].rating
        cell.bookshelfCell.bookID.text = books?[indexPath.item].bid
        
        
        if UserDefaults.standard.stringArray(forKey : "readBooks")?.contains((books?[indexPath.item].bid)!) == true {
            cell.bookshelfCell.backgroundColor = .green
        }
        else if (indexPath.item % 2 == 0 ) {
            cell.bookshelfCell.backgroundColor = UIColor(patternImage: UIImage (named:"yellowBookshelf")!)
        }
        else {
            cell.bookshelfCell.backgroundColor = UIColor(patternImage: UIImage (named:"pinkBookshelf")!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .border
        return options
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = UIScreen.main.bounds.size.width
        return CGSize(width:cellWidth, height:cellWidth/3)
    }
    

    //MARK:- Helpers
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title(forDisplayMode: buttonDisplayMode)
        action.image = descriptor.image(forStyle: buttonStyle, displayMode: buttonDisplayMode)
            
            switch buttonStyle {
            case .backgroundColor:
                action.backgroundColor = descriptor.color(forStyle: buttonStyle)
            case .circular:
                action.backgroundColor = UIColor(named: K.Colors.kaki)
                action.textColor = .white
                action.font = .systemFont(ofSize: 13)
                action.transitionDelegate = ScaleTransition.default
            }
        }
    
}


