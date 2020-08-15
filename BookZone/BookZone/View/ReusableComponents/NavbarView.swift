//
//  NavbarView.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 15/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class NavbarView: UIView {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: K.Nibs.navbarNibname, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
}
