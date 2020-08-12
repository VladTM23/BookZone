//
//  goodreadsAPI.swift
//  BookZone
//
//  Created by Alexandra-Gabriela Laicu-Hausberger on 11/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

let key = "RNsVx8TWoCWvPVwuzzV4A"
let secret = "rBBSJQtj0PjyIZ4uTi33tESjTvRZ6EKYFkCnbBGiyg"

class SendGoodreadsAPI {
    
    private var labelArray: [String] = []
    
    func getByISBN(isbn: String) {
        
        AF.request("https://www.goodreads.com/book/isbn/\(isbn)?key=\(key)").response
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
                    
                    self.labelArray =  ["This book has \(ratingsCount) ratings and \(reviewsCount) reviews from all \(editionsCount) editions." ,
                        "The average rating of the book is \(averageRating) and it was added by \(addedBy) people."]
                    
                }
        }
    }
    
    func getByTitle(titleArray: Array<String>, authorArray: Array<String>)  {
        
        var authorOptionalParameter = ""
        if authorArray.count != 0 {
            let authorString = authorArray.joined(separator: "+")
             authorOptionalParameter="author=\(authorString)&"
        }

        let titleString = titleArray.joined(separator: "+")
        
        AF.request("https://www.goodreads.com/book/title.xml?\(authorOptionalParameter)key=\(key)&title=\(titleString)").response {
            response in
            
            if let data = response.data {
                let responseBody = SWXMLHash.parse(data)
                
                let title = titleArray.joined(separator: " ")
                let author = authorArray.joined(separator: " ")
                
                print(title + "    " + author )
                
                let ratingsCount = responseBody["GoodreadsResponse"]["book"]["work"]["ratings_count"].element!.text
                let reviewsCount = responseBody["GoodreadsResponse"]["book"]["work"]["text_reviews_count"].element!.text
                let editionsCount = responseBody["GoodreadsResponse"]["book"]["work"]["books_count"].element!.text
                let averageRating = responseBody["GoodreadsResponse"]["book"]["average_rating"].element!.text
                
                let addedBy = responseBody["GoodreadsResponse"]["book"]["work"]["reviews_count"].element!.text
                
                self.labelArray = ["This book has \(ratingsCount) ratings and \(reviewsCount) reviews from all \(editionsCount) editions." ,
                    "The average rating of the book is \(averageRating) and it was added by \(addedBy) people."]
                
            }
        }
}
    
    func getLabelArray() -> [String] {
        
        return self.labelArray
    }
}
