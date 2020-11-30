//
//  Dropdown.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 30.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class Dropdown: UIView {

    @IBOutlet var dropDownView: UIView!
    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(K.Nibs.dropdown, owner: self, options: nil)
        addSubview(dropDownView)
        dropDownView.frame = self.bounds
        dropDownView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func setShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(named: "dark20")?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
    }
}

