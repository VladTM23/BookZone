//
//  RecommenderManager.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 22.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import Foundation
import Firebase

class RecommenderManager {
    static let shared = RecommenderManager()

    func getBookRecommendation(completion: @escaping(Book?) -> Void) {
        if let currentUser = Auth.auth().currentUser?.uid {
            Service.fetchUser(withUid: currentUser) { user in
                // Fetching the user's books
                let userBookCollection = user.selectedBooks
                if userBookCollection.isEmpty {
                    completion(self.getPopularityRecommendation())
                    return
                } else {
                    let bookCount = userBookCollection.count
                    let bookIdToGetRecommendationsFor = userBookCollection[bookCount-1]
                    var matchFound = false

                    // Iterate through users to find a match
                    Service.fetchUsers { users in
                        for user in users {
                            // Avoid browsing current user books
                            if user.uid != currentUser {
                                if user.selectedBooks.contains(bookIdToGetRecommendationsFor) && !matchFound {
                                    let matchedUserSelections = user.selectedBooks
                                    let userSet:Set<String> = Set(userBookCollection)
                                    var matchedUserSet:Set<String> = Set(matchedUserSelections)
                                    matchedUserSet.subtract(userSet)
                                    let matchedUserSetArray = Array(matchedUserSet)

                                    if !matchedUserSetArray.isEmpty {
                                        matchFound = true
                                        let matchedBook = matchedUserSetArray.randomElement()!
                                        Service.fetchBook(withId: matchedBook) { foundBook in
                                            if let safeFoundBook = foundBook {
                                                UserDefaults.standard.set(matchedBook, forKey: "lastMatchedBook")
                                                completion(safeFoundBook)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if !matchFound {
                            completion(self.getPopularityRecommendation())
                        }
                    }
                }
            }
        } else {
            completion(nil)
            return
        }
    }

    func getPopularityRecommendation() -> Book {
        let randomPopularBookNumber = Int.random(in: 0...K.PopularBooks.popularBooksArray.count-1)
        let lastMatchedBook = UserDefaults.standard.string(forKey: "lastMatchedBook")
        if lastMatchedBook != K.PopularBooks.popularBooksArray[randomPopularBookNumber].bid {
            return K.PopularBooks.popularBooksArray[randomPopularBookNumber]
        } else {
            var hardCopyBooksArray = K.PopularBooks.popularBooksArray
            hardCopyBooksArray.remove(at: randomPopularBookNumber)
            return hardCopyBooksArray.randomElement()!
        }
    }
}
