//
//  K.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 12/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import Foundation

struct K {
    static let key = "RNsVx8TWoCWvPVwuzzV4A"
    static let secret = "rBBSJQtj0PjyIZ4uTi33tESjTvRZ6EKYFkCnbBGiyg"

    struct Endpoints {
        static let isbnURL = "https://www.goodreads.com/book/isbn/"
        static let titleURL = "https://www.goodreads.com/book/title.xml?"
    }

    struct Colors {
        static let kaki = "kaki"
        static let pink = "pink"
        static let lightGreen = "lightGreen"
    }
    
    struct Identifiers {
        static let resultsVCIdentifier = "goToResults"
        static let infoVCIdentifier = "goToInfo"
        static let searchVCIdentifier = "goToSearch"
    }

    struct Nibs {
        static let navbarNibname = "Navbar"
    }

    struct NavbarTitles {
        static let searchTitle = "Search your next book"
        static let infoTitle = "Info Page"
        static let resultsTitle = "Results Page"
    }
}
