//
//  User.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

struct User {
    var name: String
    var age: Int
    var email: String
    let uid: String
    var imageURLs: [String]
    var bio: String
    var favBook: String
    var selectedBooks: [String]
    var readBooks: [String]
    var achievementsArray: [Bool] = [false,false,false,false,false]

    init(dictionary: [String: Any]) {
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.email = dictionary["email"] as? String ?? ""
        self.imageURLs = dictionary["imageURLs"] as? [String] ?? [String]()
        self.uid = dictionary["uid"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.favBook = dictionary["favBook"] as? String ?? ""
        self.selectedBooks = dictionary["selectedBooks"] as? [String] ?? [String]()
        self.readBooks = dictionary["readBooks"] as? [String] ?? [String]()
        self.achievementsArray = dictionary["achievementsArray"] as? [Bool] ?? [Bool]()
    }
}
