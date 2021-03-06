//
//  AuthService.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

public enum MyError: Error {
    case noPhotoError
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noPhotoError:
            return NSLocalizedString("No photo.", comment: "My error")
        }
    }
}

struct AuthCredentials {
    let email: String
    let password: String
    let fullName: String
    let profileImage: UIImage
}

struct AuthService {

    static func logUserIn(withEmail email: String,
                          password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }

    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping((Error?) -> Void)) {
            Service.uploadImage(image: credentials.profileImage) { imageUrl in
                print(imageUrl)
                if imageUrl == "No photo." {
                    let error: Error = MyError.noPhotoError
                    completion(error)
                }
                
                Auth.auth().createUser(withEmail: credentials.email,
                                       password: credentials.password) {
                    (result, error) in
                    if let error = error {
                        print("DEBUG: Error creating user \(error.localizedDescription)")
                        completion(error)
                        return
                    }

                    guard let uid = result?.user.uid else { return }
                    let data = ["email": credentials.email,
                                "fullName": credentials.fullName,
                                "imageURLs": [imageUrl],
                                "readBooks": [],
                                "selectedBooks": [],
                                "achievementsArray": [false,false,false,false,false],
                                "uid": uid,
                                "age": 18] as [String:Any]

                    COLLECTION_USERS.document(uid).setData(data,completion: completion)
                    }
                }
            }
    }
