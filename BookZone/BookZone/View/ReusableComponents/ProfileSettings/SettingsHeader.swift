//
//  SettingsHeader.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import SDWebImage

protocol SettingsHeaderDelegate: class {
    func settingsHeader(_ header: SettingsHeader, didSelect index: Int)
}

class SettingsHeader: UIView {

    // MARK: - Properties

    private let user: User
    var buttons = [UIButton]()
    weak var delegate: SettingsHeaderDelegate?

    lazy var button1 = createButton(0)

    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        backgroundColor = UIColor(named: K.Colors.kaki)

        let button1 = createButton(0)

        buttons.append(button1)

        addSubview(button1)
        button1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        button1.centerX(inView: self)
        button1.anchor(top: topAnchor, bottom: bottomAnchor, paddingTop: 16, paddingBottom: 16)

        loadUserPhoto()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    func loadUserPhoto() {

        guard let imageURL = URL(string: user.imageURLs.last!) else { return }
        SDWebImageManager.shared().loadImage(with: imageURL, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.buttons[0].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
    }

    func createButton(_ index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = index
        return button
    }

    // MARK: - Actions
    @objc func handleSelectPhoto(sender: UIButton) {
        delegate?.settingsHeader(self, didSelect: sender.tag)
    }
}

