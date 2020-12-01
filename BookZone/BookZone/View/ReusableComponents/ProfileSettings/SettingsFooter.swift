//
//  SettingsFooter.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

protocol SettingsFooterDelegate: class {
    func handleLogout()
    func handleDone()
}

class SettingsFooter: UIView {

    // MARK: - Properties

    weak var delegate: SettingsFooterDelegate?

    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("logout", comment: ""), for: .normal)
        button.setTitleColor(UIColor(named: K.Colors.pink), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("saveChanges", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: K.Colors.pink)
        button.addTarget(self, action: #selector(handleDonePressed), for: .touchUpInside)
        return button
    }()


    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        let spacer = UIView()
        spacer.backgroundColor = .systemGroupedBackground

        addSubview(spacer)
        spacer.setDimensions(height: 32, width: frame.width)

        addSubview(doneButton)
        doneButton.anchor(top: spacer.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, height: 50)

        addSubview(logoutButton)
        logoutButton.anchor(top: doneButton.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 50)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc func handleLogout() {
        delegate?.handleLogout()
    }

    @objc func handleDonePressed() {
        delegate?.handleDone()
    }
}

