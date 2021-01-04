//
//  UIResponder.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

extension UIResponder {

  func getOwningViewController() -> UIViewController? {
    var nextResponser = self
    while let next = nextResponser.next {
      nextResponser = next
      if let viewController = nextResponser as? UIViewController {
        return viewController
      }
    }
    return nil
  }
}
