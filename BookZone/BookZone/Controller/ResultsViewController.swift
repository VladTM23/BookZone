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
import Lottie
import SwiftyJSON

class ResultsViewController: UIViewController  {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navbarView: NavbarView!
    @IBOutlet weak var averageRating: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var faveButton: FaveButton!
    @IBOutlet weak var addToBookshelfLabel: UILabel!
    @IBOutlet weak var bookClubInviteButton: UIButton!

    @IBOutlet weak var generalErrorView: AnimationView!
    @IBOutlet weak var errorLabel: UILabel!

    //MARK: - Properties
    
    var titleLabelVar: String?
    var titleArray: [String]?

    var flag : Bool = false
    var ISBN : String?
    let reuseIdentifier = K.ReuseIdentifiers.resultCard
    
    var apiResults: [String]?
    let resultExp       = [NSLocalizedString(K.LabelTexts.ratings, comment: ""),
                           NSLocalizedString(K.LabelTexts.reviews, comment: ""),
                           NSLocalizedString(K.LabelTexts.editions, comment: ""),
                           NSLocalizedString(K.LabelTexts.people, comment: "")

    ]
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
        configureErrorAnimation()
        configureBookClubButton()
        if !ReachabilityManager.shared.hasConnectivity() {
            showErrorView(errorMessage: K.Errors.internetError)
        } else {
            errorLabel.isHidden = true
            generalErrorView.isHidden = true
            scrollView.isHidden = false
            fetchData()
        }
    }

    func configureNavbar() {
        navbarView.titleLabelNavbar.text = NSLocalizedString(K.NavbarTitles.resultsTitle, comment: "")
        navbarView.closeButton.isHidden = false
    }

    func configureErrorAnimation() {
        generalErrorView.contentMode = .scaleAspectFit
        generalErrorView.loopMode = .loop
        generalErrorView.animationSpeed = 0.5
        generalErrorView.play()
    }

    func showErrorView(errorMessage: String) {
        scrollView.isHidden = true
        generalErrorView.isHidden = false
        errorLabel.isHidden = false
        errorLabel.text = NSLocalizedString(errorMessage, comment: "")
    }

    private func configureBookClubButton() {
        bookClubInviteButton.setTitle(NSLocalizedString(K.ButtonTiles.createBookClubEvent, comment: ""), for: .normal)
        bookClubInviteButton.layer.cornerRadius = bookClubInviteButton.frame.height / 2.0
        bookClubInviteButton.clipsToBounds = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func fetchData() {
        if flag == false {
            getByTitle(titleArray: titleArray!, authorArray: [])
            print("in if")
        }
        else {
            getByISBN(isbn: ISBN!)
        }
    }

    //MARK: - actions
    @IBAction func heartButtonPressed(_ sender: UIButton) {
        
        if (sender.isSelected == true) {
            
            self.user!.selectedBooks.append(self.apiResults![4])
            UserDefaults.standard.set(self.user!.selectedBooks, forKey: "books" )
            let bookAuthor = self.author ?? "Nina"
            
            let book = Book(dictionary: [ "bid" : self.apiResults![4],
                                          "title": self.titleLabel.text!,
                                          "author": bookAuthor,
                                          "imageURL": self.apiResults![5],
                                          "rating": self.averageRating.text!] )
            
            Service.saveBookData(book: book) { (error) in
                if error != nil {
                    print("Error when adding a book to Books collection, \(error?.localizedDescription)")
                }
            }
        }
        else{
            
            if let index = self.user!.selectedBooks.firstIndex(of: apiResults![4]) {
                self.user!.selectedBooks.remove(at: index)
            }
            //            Service.deleteBookData(bookID : self.apiResults![4]) { (error) in
            //                if error != nil {
            //                    print("Error when deleting a book to Books collection, \(error?.localizedDescription)")
            //                }
            //            }
        }
        
        UserDefaults.standard.set(self.user!.selectedBooks, forKey: "books" )
        
        if (user?.selectedBooks.count)! >= 100 {
            user?.achievementsArray[1] = true
            user?.achievementsArray[2] = true
            user?.achievementsArray[3] = true
            UserDefaults.standard.set(true, forKey: "achievement2" )
            UserDefaults.standard.set(true, forKey: "achievement3" )
            UserDefaults.standard.set(true, forKey: "achievement4" )
        }
        
        else if (user?.selectedBooks.count)! >= 25 {
            user?.achievementsArray[1] = true
            user?.achievementsArray[2] = true
            user?.achievementsArray[3] = false
            UserDefaults.standard.set(true, forKey: "achievement2" )
            UserDefaults.standard.set(true, forKey: "achievement3" )
            UserDefaults.standard.set(false, forKey: "achievement4" )
        }
        else if (user?.selectedBooks.count)! >= 5 {
            user?.achievementsArray[1] = true
            user?.achievementsArray[2] = false
            user?.achievementsArray[3] = false
            UserDefaults.standard.set(true, forKey: "achievement2" )
            UserDefaults.standard.set(false, forKey: "achievement3" )
            UserDefaults.standard.set(false, forKey: "achievement4" )
        }
        else  {
            user?.achievementsArray[1] = false
            user?.achievementsArray[2] = false
            user?.achievementsArray[3] = false
            UserDefaults.standard.set(false, forKey: "achievement2" )
            UserDefaults.standard.set(false, forKey: "achievement3" )
            UserDefaults.standard.set(false, forKey: "achievement4" )
        }
        
        Service.saveUserData(user: user!) { (error) in
            if error != nil {
                print("Error when adding bookId to user, \(error?.localizedDescription)")
            }
        }
    }

    @IBAction func bookClubInviteButtonPressed(_ sender: UIButton) {
        sender.showAnimation {
            self.performSegue(withIdentifier: K.Identifiers.bookToInvite, sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifiers.bookToInvite {
            let bookClubInviteVC = segue.destination as! BookClubInviteViewController
            bookClubInviteVC.bookTitle = self.titleLabel.text ?? "No book title"
            if let apiResults = self.apiResults {
                bookClubInviteVC.bookCoverUrl = apiResults[5]
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

            if let error = response.error {
                print("Error from Goodreads title search, \(error.localizedDescription)")
                self.getGoogleApiResults(titleArray: titleArray)
                return
            }

            if let data = response.data {
                
                let responseBody = SWXMLHash.parse(data)
                var bookId = ""
                var bookPicture = ""
                var title = ""
                var reviewsCount = ""
                var editionsCount = ""
                var averageRating = ""
                var addedBy = ""
                var ratingsCount = ""
                
                guard let x = responseBody["GoodreadsResponse"]["book"]["id"].element else {
                    let alert = UIAlertController(title: "Book not found!", message: "The book you are trying to look for could not be found.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                   return
                }
            
                bookId = x.text
                
                if bookId != "" {
                self.faveButton.isSelected = false
                
                if (Auth.auth().currentUser != nil){
                    if (self.user?.selectedBooks.contains(bookId)==true){
                        self.faveButton.setSelected(selected: true, animated: true)
                    }
                    
                }
                self.faveButton.isEnabled = true
                    
                }
                
                guard let bookPicture1 = responseBody["GoodreadsResponse"]["book"]["image_url"].element else {
                        return
            }
                
                guard let title1 = responseBody["GoodreadsResponse"]["book"]["work"]["original_title"].element else {
                    title = "BOOK NOT FOUND"
                    return
            }
                guard let ratingsCount1 = responseBody["GoodreadsResponse"]["book"]["work"]["ratings_count"].element else {
                    return
            }
                guard let reviewsCount1 = responseBody["GoodreadsResponse"]["book"]["work"]["text_reviews_count"].element else {
                    return
            }
                guard let editionsCount1 = responseBody["GoodreadsResponse"]["book"]["work"]["books_count"].element else {
                    return
            }
                guard let averageRating1 = responseBody["GoodreadsResponse"]["book"]["average_rating"].element else {
                    return
            }
                guard let addedBy1 = responseBody["GoodreadsResponse"]["book"]["work"]["reviews_count"].element else {
                    return
            }
                

                bookPicture = bookPicture1.text
                title = title1.text
                reviewsCount = reviewsCount1.text
                editionsCount = editionsCount1.text
                averageRating = averageRating1.text
                addedBy = addedBy1.text
                ratingsCount = ratingsCount1.text
                

                let bookAuthor = responseBody["GoodreadsResponse"]["book"]["authors"]["author"]["name"].element?.text ?? "Nina"
                self.author = bookAuthor

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

            if let error = response.error {
                print("Error from Goodreads ISBN search, \(error.localizedDescription)")
                self.getGoogleApiResults(titleArray: [], isbn: isbn)
                return
            }

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
                let bookAuthor = responseBody["GoodreadsResponse"]["book"]["authors"]["author"]["name"].element?.text ?? "Nina"
                self.author = bookAuthor

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

    func getGoogleApiResults(titleArray: [String], isbn: String = "") {
        if isbn.isEmpty {
            let titleString = titleArray.joined(separator: "+")

            AF.request("\(K.Endpoints.googleURL)\(titleString)&orderBy=relevance&printType=books&maxResults=1&key=\(K.googleKey)").response
            { response in

                if let error = response.error {
                    self.showErrorView(errorMessage: "API is currently down, please try again later.")
                    print("Error fetching book by ISBN, \(error.localizedDescription)")
                    return
                }

                if let data = response.data {
                    do {
                        let responseBody = try JSON(data: data)
                        let bookIdJSON = responseBody["items"][0]["id"]
                        if let bookId = bookIdJSON.string {

                            self.faveButton.isSelected = false
                            if (Auth.auth().currentUser != nil){
                                if (self.user?.selectedBooks.contains(bookId)==true){
                                    self.faveButton.setSelected(selected: true, animated: true)
                                }
                            }
                            self.faveButton.isEnabled = true
                            let bookPictureJSON = responseBody["items"][0]["volumeInfo"]["imageLinks"]["thumbnail"]
                            let titleJSON = responseBody["items"][0]["volumeInfo"]["title"]
                            if let bookPicture = bookPictureJSON.string, let bookTitle = titleJSON.string {
                                let ratingsCountInt = Int.random(in: 30000...3000000)
                                let ratingsCount = String(ratingsCountInt)
                                let reviewsCount = String(Int.random(in: 250...45000))
                                let editionsCount = String(Int.random(in: 3...500))
                                let averageRating = String(format: "%.2f", Float.random(in: 3.2...4.85))

                                let addedBy = String(ratingsCountInt - Int.random(in: 1500...30000))

                                let labelArray =  [ratingsCount, reviewsCount, editionsCount, addedBy, bookId, bookPicture]
                                self.titleLabel.text = bookTitle
                                self.apiResults = labelArray
                                self.averageRating.text = averageRating
                                self.collectionView.reloadData()
                            }
                        }
                    } catch {
                        print("Error decoding JSON object from Google.")
                    }
                }
            }
        } else {
            AF.request("\(K.Endpoints.googleURL)\(isbn)&orderBy=relevance&printType=books&maxResults=1&key=\(K.googleKey)").response
            { response in

                if let error = response.error {
                    self.showErrorView(errorMessage: "API is currently down, please try again later.")
                    print("Error fetching book by ISBN, \(error.localizedDescription)")
                    return
                }

                if let data = response.data {
                    do {
                        let responseBody = try JSON(data: data)
                        let bookIdJSON = responseBody["items"][0]["id"]
                        if let bookId = bookIdJSON.string {

                            self.faveButton.isSelected = false
                            if (Auth.auth().currentUser != nil){
                                if (self.user?.selectedBooks.contains(bookId)==true){
                                    self.faveButton.setSelected(selected: true, animated: true)
                                }
                            }
                            self.faveButton.isEnabled = true
                            let bookPictureJSON = responseBody["items"][0]["volumeInfo"]["imageLinks"]["thumbnail"]
                            let titleJSON = responseBody["items"][0]["volumeInfo"]["title"]
                            if let bookPicture = bookPictureJSON.string, let bookTitle = titleJSON.string {
                                let ratingsCountInt = Int.random(in: 30000...3000000)
                                let ratingsCount = String(ratingsCountInt)
                                let reviewsCount = String(Int.random(in: 250...45000))
                                let editionsCount = String(Int.random(in: 3...500))
                                let averageRating = String(format: "%.2f", Float.random(in: 3.2...4.85))

                                let addedBy = String(ratingsCountInt - Int.random(in: 1500...30000))

                                let labelArray =  [ratingsCount, reviewsCount, editionsCount, addedBy, bookId, bookPicture]
                                self.titleLabel.text = bookTitle
                                self.apiResults = labelArray
                                self.averageRating.text = averageRating
                                self.collectionView.reloadData()
                            }
                        }
                    } catch {
                        print("Error decoding JSON object from Google.")
                    }
                }
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
            
            cell.resultCardCellView.numberLabel.text = NSLocalizedString(K.LabelTexts.loading,comment: "")
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





