//
//  ResultCardView.swift
//  BookZone
//
//  Created by Alexandra-Gabriela Laicu-Hausberger on 17/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class ResultCardView: UIView {


    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
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
        let nib = UINib(nibName: K.Nibs.resultCardNibname, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
