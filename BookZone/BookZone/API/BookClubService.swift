//
//  BookClubService.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 06.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class BookClubService {
    static let shared = BookClubService()

    func fetchBookClubsForCurrentUser(userId: String, completion: @escaping([BookClub], Error?) -> Void) {
        var allBookClubs = [BookClub]()
        var userBookClubs = [BookClub]()

        COLLECTION_BOOKCLUBS.getDocuments { dataSnapshot, error in
            if let error = error {
                print("Error getting documents, \(error.localizedDescription)")
                completion([],error)
            } else {
                if let safeData = dataSnapshot {
                    for document in safeData.documents {
                        allBookClubs.append(BookClub(bookClubID: document.documentID, dictionary: document.data()))
                    }
                    if allBookClubs.isEmpty {
                        completion([],nil)
                    } else {
                        for bookClub in allBookClubs {
                            // Search for the events where the user is the owner first
                            if bookClub.owner == userId {
                                userBookClubs.append(bookClub)
                            } else {
                                for guest in bookClub.eventGuests {
                                    if guest == userId {
                                        userBookClubs.append(bookClub)
                                    }
                                }
                            }
                        }
                        completion(userBookClubs,nil)
                    }
                }
            }
        }
    }

    func createBookClub(bookClub: BookClub, completion: @escaping(Bool, Error?) -> Void) {
        let randomDocumentId = COLLECTION_BOOKCLUBS.document().documentID
        do {
            try COLLECTION_BOOKCLUBS.document(randomDocumentId).setData(from: bookClub) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                    completion(false, err)
                } else {
                    completion(true,nil)
                }
            }
        } catch let error {
            print("Error creating bookClub: \(error.localizedDescription)")
            completion(false, error)
        }
    }

    func editBookClub(bookClubID: String, bookClub: BookClub, completion: @escaping(Bool, Error?) -> Void) {
        do {
            try COLLECTION_BOOKCLUBS.document(bookClubID).setData(from: bookClub) { err in
                if let err = err {
                    print("Error editing document: \(err)")
                    completion(false, err)
                } else {
                    print("Book Club with \(bookClubID) edited successfully.")
                    completion(true, nil)
                }
            }
        } catch let error {
            print("Error editing book club: \(error.localizedDescription)")
            completion(false, error)
        }
    }

    func deleteBookClub(bookClubID: String, completion: @escaping(Error?) -> Void) {
        COLLECTION_BOOKCLUBS.document(bookClubID).delete()
        completion(nil)
    }

    func getDefaultBookClub() -> BookClub {
        let userId = Auth.auth().currentUser?.uid ?? ""
        let bookClubDefaultModel = BookClub(dictionary: [
            "bookClubName": NSLocalizedString(K.LabelTexts.insertBookClubName, comment: ""),
            "bookTitle": "Povestea mea",
            "owner": userId,
            "bookClubID": "",
            "eventDate": Date(timeIntervalSinceNow: 86400.0 * 7.0),
            "eventPlatform": Platforms.platformsArray[0],
            "eventURL": "",
            "bookCoverURL": "",
            "eventGuests": [],
            "eventInviteList": []
        ])
        return bookClubDefaultModel
    }
}
