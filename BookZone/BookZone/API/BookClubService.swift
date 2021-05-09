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

    func fetchBookClub(completion: @escaping([BookClub]) -> Void) {
        var bookClubs = [BookClub]()
        guard let userId = Auth.auth().currentUser?.uid else { return }

//        COLLECTION_USERS_DETAILS.document(userId).getDocument { (document, err) in
//            // After a successful login, when opening up the menu for the first time, the user will have it populated, afterwards,
//            // regardless of an error received here, the menu will remain populated.
//            if let err = err {
//                print("Error getting document: \(err.localizedDescription)")
//                completion(holidayPreviewsArray)
//                return
//            } else {
//                guard let holidayPreviews = document?.get(FirestoreFields.holidayPreviews.rawValue) as? [String: [String: Any]] else { completion(holidayPreviewsArray)
//                    return }
//                for (holidayId, value) in holidayPreviews {
//                    let holidayPreview = self.convertToHolidayPreview(firestoreValue: value, holidayId: holidayId)
//                    holidayPreviewsArray.append(holidayPreview)
//                }
//                if holidayPreviewsArray.count == holidayPreviews.count {
//                    completion(holidayPreviewsArray)
//                }
//            }
//        }
    }

    func fetchActiveBookClubsForCurrentUser(userId: String, completion: @escaping([BookClub], Error?) -> Void) {
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

    func deleteBookClub(bookClubID: String, completion: @escaping(Error?) -> Void) {
        COLLECTION_BOOKCLUBS.document(bookClubID).delete()
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
