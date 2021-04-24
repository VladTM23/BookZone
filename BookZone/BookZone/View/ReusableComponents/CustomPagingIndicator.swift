//
//  CustomPagingIndicator.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 24.04.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import Parchment

class CustomPagingIndicator: PagingIndicatorView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
