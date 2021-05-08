//
//  UserSuggestionsTableView.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 08.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class UserSuggestionsTableView: UITableView {

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
      }

    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, 300.0)
        return CGSize(width: contentSize.width, height: height)
    }

    func addTableHeaderViewSeparator() {
        self.tableHeaderView = {
            let line = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1 / UIScreen.main.scale))
            line.backgroundColor = self.separatorColor
            return line
        }()
    }
}
