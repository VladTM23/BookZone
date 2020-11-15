//
//  BookShelfCell.swift
//  BookZone
//
//  Created by Alexandra-Gabriela Laicu-Hausberger on 14/11/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class BookShelfCell: UIView {

    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookRating: UILabel!
    @IBOutlet weak var bookRead: UIImageView!
    
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
          let nib = UINib(nibName: K.Nibs.bookshelfNibname, bundle: nil)
          return nib.instantiate(withOwner: self, options: nil).first as? UIView
      }

}
