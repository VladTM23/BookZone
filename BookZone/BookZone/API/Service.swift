//
//  Service.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Service {

    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }

    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()

        COLLECTION_USERS.getDocuments { (snapshot, error) in
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)

                users.append(user)

                if users.count == snapshot?.documents.count {
                    completion(users)
                }
            })
        }
    }

    static func fetchUsersWithIds(userIds: [String], completion: @escaping([User]) -> Void) {
        var allUsers = [User]()
        var filteredUsers = [User]()

        COLLECTION_USERS.getDocuments { (snapshot, error) in
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)

                allUsers.append(user)

                if allUsers.count == snapshot?.documents.count {
                    for userId in userIds {
                        for user in allUsers {
                            if user.uid == userId {
                                filteredUsers.append(user)
                            }
                        }
                    }
                    completion(filteredUsers)
                }
            })
        }
    }
    
    static func fetchUserBooks(withArray arr : [String], completion: @escaping([Book]) -> Void) {
        var books = [Book]()
        print(arr.count)
            for id in arr {
                COLLECTION_BOOKS.document(id).getDocument { (snapshot, error) in
                    guard let dictionary = snapshot?.data() else { return }
                    let book = Book(dictionary: dictionary)
                    books.append(book)
                    completion(books)
            }
        }
    }

    static func fetchBook(withId id: String, completion: @escaping(Book?) -> Void) {
        COLLECTION_BOOKS.document(id).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let book = Book(dictionary: dictionary)
            completion(book)
        }
    }


    static func saveUserData(user: User, completion: @escaping(Error?) -> Void) {
        let data = ["uid": user.uid,
                    "fullName": user.name,
                    "imageURLs": user.imageURLs,
                    "age": user.age,
                    "bio": user.bio,
                    "favBook": user.favBook,
                    "selectedBooks": user.selectedBooks,
                    "readBooks": user.readBooks,
                    "achievementsArray": user.achievementsArray] as [String : Any]
        COLLECTION_USERS.document(user.uid).setData(data,completion: completion)
    }
    
    static func saveBookData(book: Book, completion: @escaping(Error?) -> Void) {
        
        let data = ["bid": book.bid,
                    "title": book.title,
                    "author": book.author,
                    "imageURL": book.imageURL,
                    "rating": book.rating] as [String : Any]
        
        let doc = COLLECTION_BOOKS.document(book.bid)
        
        doc.getDocument { (document,error) in
            
            if document!.exists {
                print("Document Book exists in book db!")
            }
            else {
                doc.setData(data,completion: completion)
            }
            
        }
    }
    
    static func deleteBookData(bookID: String, completion: @escaping(Error?) -> Void) {
        
        COLLECTION_BOOKS.document(bookID).delete()
    }

    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion("No photo.")
            return
            
        }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")

        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG: Error uploading image \(error.localizedDescription)")
                return
            }

            ref.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
