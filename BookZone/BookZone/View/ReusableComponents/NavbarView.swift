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

    @IBOutlet weak var titleLabelNavbar: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    
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
        guard let parentVC = self.getOwningViewController() else { return }
        parentVC.dismiss(animated: true, completion: nil)
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        AppNavigationHelper.sharedInstance.navigateToMainPage()
    }

}
