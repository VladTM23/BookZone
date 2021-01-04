//
//  SettingsViewModel.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import Foundation

enum SettingsSection: Int, CaseIterable {
    case name
    case age
    case bio
    case favBook

    var description: String {
        switch self {
        case .name: return NSLocalizedString("name", comment: "")
        case .age: return NSLocalizedString("age", comment: "")
        case .bio: return "Bio"
        case .favBook: return NSLocalizedString("favBook", comment: "")
        }
    }
}

struct SettingsViewModel {

    private let user: User
    let section: SettingsSection

    let placeholderText: String
    var value: String?

    init(user: User, section: SettingsSection) {
        self.user = user
        self.section = section

        placeholderText = "\(NSLocalizedString("enter", comment: "")) \(section.description.lowercased())"

        switch section {
        case .name:
            value = user.name
        case .age:
            value = "\(user.age)"
        case .bio:
            value = user.bio
        case .favBook:
            value = user.favBook
        }
    }
}

