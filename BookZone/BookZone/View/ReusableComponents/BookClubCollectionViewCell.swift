//
//  BookClubCollectionViewCell.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 09.05.2021.
//  Copyright © 2021 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import SDWebImage

class BookClubCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bookClubNameLabel: UILabel!
    @IBOutlet weak var bookClubBookCoverImage: UIImageView!
    @IBOutlet weak var hostLabelPlaceholder: UILabel!
    @IBOutlet weak var hostView: UIView!
    @IBOutlet weak var hostLabelName: UILabel!
    @IBOutlet weak var hostImageView: UIImageView!
    @IBOutlet weak var datePlaceholderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    var bookClubHost: User?
    var bookClubName: String?
    var bookClub: BookClub?
    var bookClubId: String?
    var bookClubDate: Date?

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
        bringSubviewToFront(contentView)
        configureUI()
    }

    func loadViewFromNib() -> UICollectionViewCell? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BookClubCell", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UICollectionViewCell
    }

    private func configureUI() {
        setStrings()
        self.clipsToBounds = true
        self.layer.cornerRadius = 4
    }

    private func setStrings() {
        hostLabelPlaceholder.text = NSLocalizedString(K.LabelTexts.host, comment: "")
        datePlaceholderLabel.text = NSLocalizedString(K.LabelTexts.eventDate, comment: "")
    }

    func configureCell(with bookClubModel: BookClub) {
        self.bookClub = bookClubModel
        self.bookClubId = bookClubModel.bookClubID
        self.bookClubNameLabel.text = bookClubModel.bookClubName
        guard let imageURL = URL(string: bookClubModel.bookCoverURL) else { return }
        SDWebImageManager.shared().loadImage(with: imageURL, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            self.bookClubBookCoverImage.image = image
            }
        let formatter = DateFormatterHelper.getBookClubDateFormatter()
        let eventDate = formatter.string(from: bookClubModel.eventDate)
        dateLabel.text = eventDate
        Service.fetchUser(withUid: bookClubModel.owner) { userModel in
            self.hostLabelName.text = userModel.name
            guard let imageURL = URL(string: userModel.imageURLs.last!) else { return }
            SDWebImageManager.shared().loadImage(with: imageURL, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.hostImageView.image = image
                }
        }
    }
}
