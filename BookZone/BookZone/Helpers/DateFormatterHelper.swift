//
//  DateFormatterHelper.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 08.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import Foundation

class DateFormatterHelper {
    static func getBookClubDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short

        var locale: String = "en"
        let currentLanguage = UserDefaults.standard.string(forKey: K.UserKeys.userShortLanguage)
        switch currentLanguage {
        case K.Languages.en:
            locale = "en"
        case K.Languages.ro:
            locale = "ro_RO"
        default:
            locale = "en"
        }

        formatter.locale = Locale(identifier: locale)
        formatter.doesRelativeDateFormatting = true
        return formatter
    }

    static func getBookClubDateFormatterWithoutTime() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        return formatter
    }

    static func getSmallFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter
    }

    static func getLocalTimeDateFormatter(_ offset: Int) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = usesAMPM() ? "h:mm" : "HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: offset)
        return formatter
    }

    static func getLocalTimeDateFormatterAM_PM(_ offset: Int) -> String {
        guard usesAMPM() else { return "" }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        formatter.timeZone = TimeZone(secondsFromGMT: offset)

        return formatter.string(from: date)
    }

    static func usesAMPM() -> Bool {
        let locale = Locale.current
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)!
        if dateFormat.range(of: "a") != nil {
            return true
        } else {
            return false
        }
    }
}
