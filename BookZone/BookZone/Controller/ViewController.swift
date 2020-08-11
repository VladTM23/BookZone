//
//  ViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 11/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        AppleTextRecognizer().textRecognize()
        SendGoodreadsAPI().getByISBN(isbn: "0441172717")
        SendGoodreadsAPI().getByTitle(titleArray: ["Hound","of","the","Baskervilles"], authorArray: ["Arthur","Conan","Doyle"])
        
    }
}

