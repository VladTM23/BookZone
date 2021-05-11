//
//  AppNavigationHelper.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 06.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class AppNavigationHelper {
    static let sharedInstance = AppNavigationHelper()

    func navigateToMainPage() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeScreen = storyboard.instantiateViewController(withIdentifier:
                                                                K.Identifiers.homeVC)
        homeScreen.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =
            storyboard.instantiateInitialViewController()
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.present(
            homeScreen, animated: false, completion: nil)
    }
}
