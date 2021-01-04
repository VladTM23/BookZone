//
//  CustomTextField.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    init(placeholder: String, isSecureField: Bool = false, contentType: UITextContentType) {
        super.init(frame: .zero)

        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always

        borderStyle = .none
        textColor = .white
        self.font = nil
        self.font = UIFont.systemFont(ofSize: 14.0)
        backgroundColor = UIColor(white: 1, alpha: 0.2)
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 5
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        isSecureTextEntry = isSecureField
        textContentType = contentType
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
