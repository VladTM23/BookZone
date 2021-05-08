//
//  BookClub.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 06.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import FirebaseFirestore

class BookClub: Codable {
    var bookClubName: String = ""
    var bookTitle: String = ""
    var owner: String = ""
    var bookClubID: String = ""
    var eventDate: Date = Date()
    var eventPlatform: String = ""
    var eventURL: String = ""
    var bookCoverURL: String = ""
    var eventGuests: [String] = [String]()
    var eventInviteList: [String] = [String]()

    init(bookClubID: String = "",dictionary: [String: Any]) {
        self.bookClubName = dictionary["bookClubName"] as? String ?? ""
        self.bookTitle = dictionary["bookTitle"] as? String ?? ""
        self.owner = dictionary["owner"] as? String ?? ""
        self.bookClubID = bookClubID
        let firebaseTimestamp = dictionary["eventDate"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSinceNow: 86400))
        self.eventDate = firebaseTimestamp.dateValue()
        self.eventPlatform = dictionary["eventPlatform"] as? String ?? ""
        self.eventURL = dictionary["eventURL"] as? String ?? ""
        self.bookCoverURL = dictionary["bookCoverURL"] as? String ?? ""
        self.eventGuests = dictionary["eventGuests"] as? [String] ?? [String]()
        self.eventInviteList = dictionary["eventInviteList"] as? [String] ?? [String]()
    }

    enum CodingKeys: String, CodingKey {
        case bookClubName
        case owner
        case bookClubID
        case eventDate
        case eventPlatform
        case eventURL
        case bookCoverURL
        case eventGuests
        case eventInviteList
    }
}
