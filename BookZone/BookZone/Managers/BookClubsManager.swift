//
//  BookClubsManager.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 10.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import Foundation

class BookClubsManager {
    static let shared = BookClubsManager()

    func getActiveBookClubEvents(userId: String, completion: @escaping([BookClub], Error?) -> Void) {
        var activeBookClubsArray = [BookClub]()
        BookClubService.shared.fetchBookClubsForCurrentUser(userId: userId) { bookClubsArray, error in
            if let error = error {
                print("Error fetching active book clubs")
                completion([],error)
            }
            for bookClub in bookClubsArray {
                if bookClub.eventDate > Date() {
                    activeBookClubsArray.append(bookClub)
                }
            }
            completion(activeBookClubsArray,nil)
        }
    }

    func getExpiredBookClubEvents(userId: String, completion: @escaping([BookClub], Error?) -> Void) {
        var expiredBookClubsArray = [BookClub]()
        BookClubService.shared.fetchBookClubsForCurrentUser(userId: userId) { bookClubsArray, error in
            if let error = error {
                print("Error fetching active book clubs")
                completion([],error)
            }
            for bookClub in bookClubsArray {
                if bookClub.eventDate < Date() {
                    expiredBookClubsArray.append(bookClub)
                }
            }
            completion(expiredBookClubsArray,nil)
        }
    }
}
