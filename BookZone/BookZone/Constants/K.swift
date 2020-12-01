//
//  K.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 12/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_BOOKS = Firestore.firestore().collection("books")

struct K {
    static let key = "RNsVx8TWoCWvPVwuzzV4A"
    static let secret = "rBBSJQtj0PjyIZ4uTi33tESjTvRZ6EKYFkCnbBGiyg"

    struct UserKeys {
        static let tutorialCompleted = "tutorialCompleted"
        static let userLanguage = "userLanguage"
        static let languageSelectionMade = "languageSelectionMade"
        static let userLanguageRow = "userLanguageRow"
        static let userShortLanguage = "userShortLanguage"
    }

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
        static let resultVCIdentifierFromSearch = "goToResultFromSearch"
        static let resultVCIdentifierFromRadio = "goToResultFromRadio"
        static let radioButtonsIdentifier = "goToRadioButtons"
        static let goToNormalSearch = "goToNormalSearch"
        static let getStarted = "getStarted"
        static let loginSuccess = "loginToHome"
        static let registerSuccess = "registerToHome"
        static let skipToHome = "skipToHome"
        static let toLogin = "toLoginScreen"
        static let toRegister = "toRegisterScreen"
        static let loginToRegister = "loginToRegister"
        static let registerToLogin = "registerToLogin"
        static let registerToTutorial = "registerToTutorial"
        static let loginToTutorial = "loginToTutorial"
        static let goToProfileSettings = "goToProfileSettings"
        static let goToBookshelf = "goToBookshelf"
        static let goToSettings = "goToSettings"
        static let redoTutorial = "redoTutorial"
        static let reloadSettings = "reloadSettings"
        static let homeVC = "homeVC"
    }

    struct Nibs {
        static let navbarNibname = "Navbar"
        static let resultCardNibname = "ResultCard"
        static let searchBarNibname = "SearchBar"
        static let firstPageScrollNibname = "FirstPageScroll"
        static let secondPageScrollNibname = "SecondPageScroll"
        static let bookshelfNibname = "BookShelfCell"
        static let dropdown = "Dropdown"
    }

    struct NavbarTitles {
        static let searchTitle = "searchTitle"
        static let infoTitle = "infoPage"
        static let resultsTitle = "resultsPage"
        static let registerTitle = "register"
        static let loginTitle = "login"
        static let profileSettings = "profileSettings"
        static let bookshelfTitle = "bookshelfTitle"
        static let appSettingsTitle = "settings"
        static let radioButtonsTitle = "radioButtons"
    }

    struct LabelTexts {
        static let ratings = "ratings"
        static let reviews = "reviews"
        static let editions = "editions"
        static let people = "people"
        static let star = "star"
        static let pencil = "pencil"
        static let book = "book"
        static let person = "person"
        static let loading = "loading"
        static let searchByISBN = "isbnSearch"
        static let searchByTitle = "titleSearch"
        static let emptyStringPlaceholder = "emptyPlaceholder"
        static let invalidISBNStringPlaceholder = "invalidISBN"
    }

    struct ImageNames {
        static let yellowBackground = "yellowCardBackground"
        static let pinkBackground = "pinkCardBackground"
        static let ticked = "ticked"
        static let unticked = "unticked"
    }

    struct ReuseIdentifiers {
        static let resultCard = "resultCard"
        static let radioButton = "radioButton"
        static let settingsCell = "SettingsCell"
        static let bookshelf = "bookshelf"
    }

    struct Languages {
        static let en = "en"
        static let ro = "ro"
        static let english = "English"
        static let romana = "Romanian"
    }
    
    struct Quotes {
        static let quotes = [
            "'Those who don’t believe in magic will never find it.'",
            "'Be yourself and people will like you.'",
            "'It is better to be hated for what you are than to be loved for what you are not.'",
            "'Sometimes weak and wan, sometimes strong and full of light. The moon understands what it means to be human'",
            "'The moment you doubt whether you can fly, you cease forever to be able to do it.'",
            "'Time you enjoy wasting is not wasted time.'",
            "'When you can’t find someone to follow, you have to find a way to lead by example.'",
            "'She decided long ago that life was a long journey. She would be strong, and she would be weak, and both would be okay.'",
            "'It is only with the heart that one can see rightly; what is essential is invisible to the eye.'",
            "'The worst enemy to creativity is self-doubt.'",
            "'Hoping for the best, prepared for the worst, and unsurprised by anything in between.'",
            "'It is a curious thought, but it is only when you see people looking ridiculous that you realize just how much you love them.'",
            "'And, now that you don’t have to be perfect you can be good.'",
            "'A friend may be waiting behind a stranger’s face.'",
            "'We all require devotion to something more than ourselves for our lives to be endurable.'",
            "'There is never a time or place for true love. It happens accidentally, in a heartbeat, in a single flashing, throbbing moment.'",
            "'Even the darkest night will end and the sun will rise.'",
            "'Each of us is more than the worst thing we’ve ever done.'",
            "'It was all very well to be ambitious, but ambition should not kill the nice qualities in you.'",
            "'Just because your version of normal isn’t the same as someone else’s version doesn’t mean that there’s anything wrong with you.'",
            "'You are your best thing.'",
            "'There is some good in this world, and it’s worth fighting for.'",
            "'There is nothing sweeter in this sad world than the sound of someone you love calling your name.'",
            "'I don’t understand it any more than you do, but one thing I’ve learned is that you don’t have to understand things for them to be.'",
            "'Isn’t it nice to think that tomorrow is a new day with no mistakes in it yet?'",
            "'It’s the possibility of having a dream come true that makes life interesting.'",
            "'I am not afraid of storms, for I am learning how to sail my ship.'",
            "'So many things are possible just as long as you don’t know they’re impossible.'",
            "'Love doesn’t just sit there, like a stone, it has to be made, like bread; remade all the time, made new.'",
        ]
        
        static let authors = [
            "The Minpins by Roald Dahl",
            "Diary of a Wimpy Kid by Jeff Kinney",
            "Autumn Leaves by André Gide",
            "Shatter Me by Tahereh Mafi",
            "Peter Pan by J.M. Barrie",
            "Phrynette Married by Marthe Troly-Curtin",
            "Bad Feminist by Roxane Gay",
            "Furthermore by Tahereh Mafi",
            "The Little Prince by Antoine de Saint-Exupéry",
            "The Unabridged Journals of Sylvia Plath by Sylvia Plath",
            "I Know Why the Caged Bird Sings by Maya Angelou",
            "An Autobiography by Agatha Christie",
            "East of Eden by John Steinbeck",
            "Letter to My Daughter by Maya Angelou",
            "Being Mortal by Atul Gawande",
            "The Truth About Forever by Sarah Dessen",
            "Les Misérables by Victor Hugo",
            "Just Mercy by Bryan Stevenson",
            "Ballet Shoes by Noel Streatfeild",
            "The Terrible Thing That Happened to Barnaby Brocket by John Boyne",
            "Beloved by Toni Morrison",
            "The Two Towers by J.R.R. Tolkien",
            "The Tale of Despereaux by Kate DiCamillo",
            "A Wrinkle in Time by Madeleine L’Engle",
            "Anne of Green Gables by L.M. Montgomery",
            "The Alchemist by Paulo Coelho",
            "Little Women by Louisa May Alcott",
            "The Phantom Tollbooth by Norton Juster",
            "The Lathe of Heaven by Ursula K. Le Guin"
        ]
    }

}
