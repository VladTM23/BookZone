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

class ResultsViewController: UIViewController  {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navbarView: NavbarView!
    @IBOutlet weak var averageRating: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - Properties
    var titleLabelVar: String?
    var titleArray: [String]?
    var flag : Bool = false
    var ISBN : String?
    let reuseIdentifier = K.ReuseIdentifiers.resultCard
    
    var apiResults: [String]?
    let resultExp = [K.LabelTexts.ratings,
                     K.LabelTexts.reviews,
                     K.LabelTexts.editions,
                     K.LabelTexts.people]
    let systemImageName = [K.LabelTexts.star,
                           K.LabelTexts.pencil,
                           K.LabelTexts.book,
                           K.LabelTexts.person]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 285, height: 255)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        configureUI()
        print(flag)
        print(titleArray)
        
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
        configureNavbar()

    }

    func configureNavbar() {
        navbarView.titleLabelNavbar.text = K.NavbarTitles.resultsTitle
    }


}

//MARK: - API Extension

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
                
                _ = titleArray.joined(separator: " ")
                _ = authorArray.joined(separator: " ")
                
                let title = responseBody["GoodreadsResponse"]["book"]["work"]["original_title"].element!.text
                let ratingsCount = responseBody["GoodreadsResponse"]["book"]["work"]["ratings_count"].element!.text
                let reviewsCount = responseBody["GoodreadsResponse"]["book"]["work"]["text_reviews_count"].element!.text
                let editionsCount = responseBody["GoodreadsResponse"]["book"]["work"]["books_count"].element!.text
                let averageRating = responseBody["GoodreadsResponse"]["book"]["average_rating"].element!.text

                let addedBy = responseBody["GoodreadsResponse"]["book"]["work"]["reviews_count"].element!.text

                let labelArray =  [ratingsCount, reviewsCount, editionsCount,addedBy]
                self.titleLabel.text = title
                self.apiResults = labelArray
                self.averageRating.text = averageRating
                
            }
        }
    }

    func getByISBN(isbn: String) {

        AF.request("\(K.Endpoints.isbnURL)\(isbn)?key=\(K.key)").response
            { response in

                if let data = response.data {
                    let responseBody = SWXMLHash.parse(data)

                    let title = responseBody["GoodreadsResponse"]["book"]["work"]["original_title"].element!.text
                    //let author = responseBody["GoodreadsResponse"]["book"]["authors"]["author"]["name"].element!.text

                    //print(title + "    " + author )
                    let ratingsCount = responseBody["GoodreadsResponse"]["book"]["work"]["ratings_count"].element!.text
                    let reviewsCount = responseBody["GoodreadsResponse"]["book"]["work"]["text_reviews_count"].element!.text
                    let editionsCount = responseBody["GoodreadsResponse"]["book"]["work"]["books_count"].element!.text
                    let averageRating = responseBody["GoodreadsResponse"]["book"]["average_rating"].element!.text

                    let addedBy = responseBody["GoodreadsResponse"]["book"]["work"]["reviews_count"].element!.text

                    let labelArray =  [ratingsCount, reviewsCount, editionsCount,addedBy]
                    self.titleLabel.text = title
                    self.apiResults = labelArray
                    self.averageRating.text = averageRating

                }
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
            
            cell.resultCardCellView.numberLabel.text = self.apiResults?[indexPath.item]
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





