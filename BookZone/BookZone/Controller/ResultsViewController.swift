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

class ResultsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel1: UILabel!
    @IBOutlet weak var infoLabel2: UILabel!
    @IBOutlet weak var navbarView: NavbarView!

    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        //SendGoodreadsAPI().getByISBN(isbn: "0441172717")
        //SendGoodreadsAPI().getByTitle(titleArray: ["The","shining"], authorArray: [])
    }

    // MARK: - User interface

    func configureUI() {
        configureNavbar()
    }

    func configureNavbar() {
        navbarView.titleLabel.text = K.NavbarTitles.resultsTitle
    }

}
    //MARK: - API Extension

    extension ResultsViewController {

        func getByTitle(titleArray: Array<String>, authorArray: Array<String>) {

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

                    let title = titleArray.joined(separator: " ")
                    let author = authorArray.joined(separator: " ")

                    print("DEBUG:    " + title + "    " + author )

                    let ratingsCount = responseBody["GoodreadsResponse"]["book"]["work"]["ratings_count"].element!.text
                    let reviewsCount = responseBody["GoodreadsResponse"]["book"]["work"]["text_reviews_count"].element!.text
                    let editionsCount = responseBody["GoodreadsResponse"]["book"]["work"]["books_count"].element!.text
                    let averageRating = responseBody["GoodreadsResponse"]["book"]["average_rating"].element!.text

                    let addedBy = responseBody["GoodreadsResponse"]["book"]["work"]["reviews_count"].element!.text

                    let labelArray = ["This book has \(ratingsCount) ratings and \(reviewsCount) reviews from all \(editionsCount) editions.",
                        "The average rating of the book is \(averageRating) and it was added by \(addedBy) people."]
                    self.infoLabel1.text = labelArray[0]
                    self.infoLabel2.text = labelArray[1]
                }
            }
        }

        func getByISBN(isbn: String) {

            AF.request("\(K.Endpoints.isbnURL)\(isbn)?key=\(K.key)").response
                { response in
                    //debugPrint(response)

                    if let data = response.data {
                        let responseBody = SWXMLHash.parse(data)

                        let title = responseBody["GoodreadsResponse"]["book"]["work"]["original_title"].element!.text
                        let author = responseBody["GoodreadsResponse"]["book"]["authors"]["author"]["name"].element!.text

                        print(title + "    " + author )
                        let ratingsCount = responseBody["GoodreadsResponse"]["book"]["work"]["ratings_count"].element!.text
                        let reviewsCount = responseBody["GoodreadsResponse"]["book"]["work"]["text_reviews_count"].element!.text
                        let editionsCount = responseBody["GoodreadsResponse"]["book"]["work"]["books_count"].element!.text
                        let averageRating = responseBody["GoodreadsResponse"]["book"]["average_rating"].element!.text

                        let addedBy = responseBody["GoodreadsResponse"]["book"]["work"]["reviews_count"].element!.text

                        let labelArray =  ["This book has \(ratingsCount) ratings and \(reviewsCount) reviews from all \(editionsCount) editions." ,
                            "The average rating of the book is \(averageRating) and it was added by \(addedBy) people."]
                        self.infoLabel1.text = labelArray[0]
                        self.infoLabel2.text = labelArray[1]
                    }
            }
        }
    }








