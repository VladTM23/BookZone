//
//  SecondPageScroll.swift
//  BookZone
//
//  Created by Alexandra-Gabriela Laicu-Hausberger on 29/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class SecondPageScroll: UIView {

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
           let nib = UINib(nibName: K.Nibs.secondPageScrollNibname, bundle: nil)
           return nib.instantiate(withOwner: self, options: nil).first as? UIView
       }


}
