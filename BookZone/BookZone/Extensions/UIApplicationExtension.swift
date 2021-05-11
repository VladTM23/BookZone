//
//  UIAplicationExtension.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 10.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

extension UIApplication {
    func scheduleLocalNotification(alertTitle: String?, alertBody: String, fireDate: Date?, notificationID: String) {
        let localNotification = UILocalNotification()

        var infoDict: [String: Any] = [
            "bookClubEventId": notificationID
        ]

        localNotification.userInfo = infoDict
        localNotification.fireDate = fireDate
        localNotification.alertTitle = alertTitle
        localNotification.alertBody = alertBody
        localNotification.timeZone = .current
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }

    func scheduleLocalNotification(for bookClub: BookClub) {
        scheduleLocalNotification(
            alertTitle: nil,
            alertBody: NSLocalizedString(K.LabelTexts.bookClubNotificationText, comment: ""),
            fireDate: Calendar.current.date(byAdding: .hour, value: -1, to: bookClub.eventDate),
            notificationID: bookClub.bookClubID
        )
    }

    func cancelLocalNotification(for bookClub: BookClub?) {
        guard let reminder = scheduledLocalNotifications?.first(where: { ($0.userInfo?["bookClubEventId"] as? String) == bookClub?.bookClubID }) else { return }
        cancelLocalNotification(reminder)
    }
}
