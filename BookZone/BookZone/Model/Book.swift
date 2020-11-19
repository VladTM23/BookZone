//
//  Book.swift
//  BookZone
//
//  Created by Alexandra-Gabriela Laicu-Hausberger on 16.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

struct Book: Equatable{
    let bid: String
    let title: String
    let author: String
    let imageURL: String
    let rating: String


    init(dictionary: [String: Any]) {
        self.bid = dictionary["bid"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.author = dictionary["author"] as? String ?? ""
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.rating = dictionary["rating"] as? String ?? ""

    }
    
    static func ==(lhs: Book, rhs: Book) -> Bool {
        return lhs.bid == rhs.bid 
    }
}
