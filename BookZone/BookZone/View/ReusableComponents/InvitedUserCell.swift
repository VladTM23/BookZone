//
//  InvitedUserCell.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 08.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import SDWebImage
import SwipeCellKit

class InvitedUsersCell: SwipeTableViewCell {

    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var removeUserButton: UIButton!

    var userEmail: String?
    var userImageUrl: String?
    var userModel: User?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.contentView.autoresizingMask = .flexibleHeight
        self.layoutIfNeeded()
        self.addSubview(view)
    }

    func loadViewFromNib() -> UITableViewCell? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "InvitedUserCell", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UITableViewCell
    }

    func configureCell(with userModel: User) {
        self.userModel = userModel
        userName.text = userModel.name
        guard let imageURL = URL(string: userModel.imageURLs.last!) else { return }
        SDWebImageManager.shared().loadImage(with: imageURL, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            self.userPhoto.image = image
            }
    }
    
    @IBAction func removeUserButtonPressed(_ sender: UIButton) {
    }
}
