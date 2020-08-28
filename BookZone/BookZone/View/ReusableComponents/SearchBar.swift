//
//  SearchBar.swift
//  BookZone
//
//  Created by Alexandra-Gabriela Laicu-Hausberger on 21/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class SearchBar: UIView {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonImageView: UIImageView!
    
    @IBOutlet weak var searchImageView: UIImageView!
    
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
        let nib = UINib(nibName: K.Nibs.searchBarNibname, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
