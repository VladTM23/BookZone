//
//  UserViewModel.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 08.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import Foundation

struct UserViewModel {
    var name: String

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
