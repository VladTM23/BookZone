//
//  ViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 11/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import FaveButton
import Firebase

class ResultsViewController: UIViewController  {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navbarView: NavbarView!
    @IBOutlet weak var averageRating: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var faveButton: FaveButton!
    @IBOutlet weak var addToBookshelfLabel: UILabel!
    

    
    //MARK: - Properties
    
    var titleLabelVar: String?
    var titleArray: [String]?
   
    var flag : Bool = false
    var ISBN : String?
    let reuseIdentifier = K.ReuseIdentifiers.resultCard
    
    var apiResults: [String]?
    let resultExp       = [K.LabelTexts.ratings,
                           K.LabelTexts.reviews,
                           K.LabelTexts.editions,
                           K.LabelTexts.people]
    let systemImageName = [K.LabelTexts.star,
                           K.LabelTexts.pencil,
                           K.LabelTexts.book,
                           K.LabelTexts.person]
    
    private var user: User?
    private var book: Book?
    private var author: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
        
        if (Auth.auth().currentUser == nil){
            faveButton.isHidden = true;
            addToBookshelfLabel.isHidden=true;
            
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        faveButton.delegate = self
        
        configureUI()

        if flag == false {
            getByTitle(titleArray: titleArray!, authorArray: [])
            print("in if")
        }
        else {
            getByISBN(isbn: ISBN!)
        }
        
        
    }

    // MARK: - User interface

    func configureUI() {
        
        faveButton.setSelected(selected: false, animated: true)
        
        faveButton.isEnabled = false
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 285, height: 255)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        configureNavbar()
        
    }

    func configureNavbar() {
        navbarView.titleLabelNavbar.text = K.NavbarTitles.resultsTitle
    }
    
    
    //MARK: - actions


    @IBAction func heartButtonPressed(_ sender: UIButton) {
        
        if (sender.isSelected == true) {
            
            self.user!.selectedBooks.append(self.apiResults![4])
            
            let book = Book(dictionary: [ "bid" : self.apiResults![4],
                                          "title": self.titleLabel.text!,
                                          "author": "Nina",
                                         "imageURL": self.apiResults![5],
                                         "rating": self.averageRating.text!] )
            
            Service.saveBookData(book: book) { (error) in
                if error != nil {
                    print("Error when adding a book to Books collection, \(error?.localizedDescription)")
                }
            }
        }
        else{
            self.user!.selectedBooks.removeLast()
            Service.deleteBookData(bookID : self.apiResults![4]) { (error) in
                if error != nil {
                    print("Error when deleting a book to Books collection, \(error?.localizedDescription)")
                }
            }
        }
        
        Service.saveUserData(user: user!) { (error) in
            if error != nil {
                print("Error when adding bookId to user, \(error?.localizedDescription)")
            }
        }
        
       
        
    }

}




//MARK: - API Extension GoodReads

extension ResultsViewController {

    func getByTitle(titleArray: [String], authorArray: [String]) {

        var authorOptionalParameter = ""
        if authorArray.count != 0 {
            let authorString = authorArray.joined(separator: "+")
            authorOptionalParameter="author=\(authorString)&"
        }
        
        let titleString = titleArray.joined(separator: "+")

        AF.request("\(K.Endpoints.titleURL)\(authorOptionalParameter)key=\(K.key)&title=\(titleString)").response {
            response in

            if let data = response.data {
                let responseBody = SWXMLHash.parse(data)
                
                let bookId = responseBody["GoodreadsResponse"]["book"]["id"].element!.text
                
                self.faveButton.isSelected = false
                
                
                if (Auth.auth().currentUser != nil){
                    if (self.user?.selectedBooks.contains(bookId)==true){
                        self.faveButton.setSelected(selected: true, animated: true)
                    }
                    
                }
                self.faveButton.isEnabled = true
                
                let bookPicture = responseBody["GoodreadsResponse"]["book"]["image_url"].element!.text
                
                let title = responseBody["GoodreadsResponse"]["book"]["work"]["original_title"].element!.text
                let ratingsCount = responseBody["GoodreadsResponse"]["book"]["work"]["ratings_count"].element!.text
                let reviewsCount = responseBody["GoodreadsResponse"]["book"]["work"]["text_reviews_count"].element!.text
                let editionsCount = responseBody["GoodreadsResponse"]["book"]["work"]["books_count"].element!.text
                let averageRating = responseBody["GoodreadsResponse"]["book"]["average_rating"].element!.text
                let addedBy = responseBody["GoodreadsResponse"]["book"]["work"]["reviews_count"].element!.text
                
                
                //self.author = responseBody["GoodreadsResponse"]["book"]["authors"]["author"].element!.text

                let labelArray =  [ratingsCount, reviewsCount, editionsCount, addedBy, bookId, bookPicture]
                
                
                self.titleLabel.text = title
                self.apiResults = labelArray
                self.averageRating.text = averageRating
                self.collectionView.reloadData()
                
            }
        }
    }

    func getByISBN(isbn: String) {

        AF.request("\(K.Endpoints.isbnURL)\(isbn)?key=\(K.key)").response
            { response in

                if let data = response.data {
                    let responseBody = SWXMLHash.parse(data)
                    
                    let bookId = responseBody["GoodreadsResponse"]["book"]["id"].element!.text
                    
                    self.faveButton.isSelected = false
                    
                    if (Auth.auth().currentUser != nil){
                        if (self.user?.selectedBooks.contains(bookId)==true){
                            self.faveButton.setSelected(selected: true, animated: true)
                        }
                        
                    }
                    self.faveButton.isEnabled = true
                    let bookPicture = responseBody["GoodreadsResponse"]["book"]["image_url"].element!.text
                    
                    let title = responseBody["GoodreadsResponse"]["book"]["work"]["original_title"].element!.text
                    //let author = responseBody["GoodreadsResponse"]["book"]["authors"]["author"]["name"].element!.text

                    //print(title + "    " + author )
                    let ratingsCount = responseBody["GoodreadsResponse"]["book"]["work"]["ratings_count"].element!.text
                    let reviewsCount = responseBody["GoodreadsResponse"]["book"]["work"]["text_reviews_count"].element!.text
                    let editionsCount = responseBody["GoodreadsResponse"]["book"]["work"]["books_count"].element!.text
                    let averageRating = responseBody["GoodreadsResponse"]["book"]["average_rating"].element!.text

                    let addedBy = responseBody["GoodreadsResponse"]["book"]["work"]["reviews_count"].element!.text

                    let labelArray =  [ratingsCount, reviewsCount, editionsCount, addedBy, bookId, bookPicture]
                    self.titleLabel.text = title
                    self.apiResults = labelArray
                    self.averageRating.text = averageRating
                    self.collectionView.reloadData()

                }
        }
    }
    
    
    // MARK: - API Firebase

    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            self.user = user
            
        }
    }
}



//MARK: - UICollectionView

extension ResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{

        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ResultCardCollectionViewCell

        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        if self.apiResults?.count ?? 0 < 4 {
            
            cell.resultCardCellView.numberLabel.text = K.LabelTexts.loading
        }
        else {
            
            cell.resultCardCellView.numberLabel.text = formatNumber((self.apiResults?[indexPath.item])!)
        }
        
        cell.resultCardCellView.categoryLabel.text = self.resultExp[indexPath.item]
        cell.resultCardCellView.categoryImageView.image = UIImage(systemName: self.systemImageName[indexPath.item])
        

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ResultCardCollectionViewCell
        cell.resultCardCellView.backgroundImage.image = UIImage(named: K.ImageNames.yellowBackground)
    }


    // change background color back when user releases touch
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ResultCardCollectionViewCell
        cell.resultCardCellView.backgroundImage.image = UIImage(named: K.ImageNames.pinkBackground)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets( top:10, left: 50,  bottom:10, right: 50)
    }
    
    
    
}



//MARK:- Helper functions

func formatNumber(_ number: String) -> String {
    let largeNumber = Int(number)!
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber))!
    return(formattedNumber)
}





