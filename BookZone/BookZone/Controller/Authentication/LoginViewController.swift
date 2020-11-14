//
//  LoginViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14/10/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties

    private var viewModel = LoginViewModel()

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "BookZone").withRenderingMode(.alwaysOriginal)
        iv.tintColor = .white
        return iv
    }()

    private let emailTextField = CustomTextField(placeholder: "Email", contentType: .emailAddress)
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureField: true, contentType: .oneTimeCode)

    private let authButton: AuthButton = {
        let button = AuthButton(title: "Log In", type: .system)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()

    private let goToRegistrationButton: UIButton = {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowRegistration), for: .touchUpInside)

        return button
    }()

    @IBOutlet weak var navbarView: NavbarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTextFieldObservers()
    }

    // MARK: - User interface

    func configureUI() {
        configureNavbar()
        view.addSubview(iconImageView)
        iconImageView.centerX(inView: view)
        iconImageView.setDimensions(height: 100, width: 150)
        iconImageView.anchor(top: navbarView.bottomAnchor, paddingTop: 32)

        let stack = UIStackView(arrangedSubviews: [emailTextField,passwordTextField, authButton])
        stack.axis = .vertical
        stack.spacing = 16

        view.addSubview(stack)
        stack.anchor(top: iconImageView.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)

        view.addSubview(goToRegistrationButton)
        goToRegistrationButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                      right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    }

    func configureNavbar() {
        navbarView.titleLabelNavbar.text = K.NavbarTitles.loginTitle
    }

    // MARK: - Helpers

    func checkFormStatus() {
        if viewModel.formIsValid {
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        } else {
            authButton.isEnabled = false
            authButton.backgroundColor = UIColor(named: K.Colors.pink)
        }
    }

    func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    func performNavigation() {
        let didDoTutorial = UserDefaults.standard.bool(forKey: K.UserKeys.tutorialCompleted)
        didDoTutorial ? performSegue(withIdentifier: K.Identifiers.loginSuccess, sender: self) :
                    performSegue(withIdentifier: K.Identifiers.loginToTutorial, sender: self)
    }

    // MARK: - Actions

    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }

        checkFormStatus()
    }

    @objc func handleLogin() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }

        AuthService.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Error logging user in \(error.localizedDescription)")
                return
            }

            self.performNavigation()
        }
    }

    @objc func handleShowRegistration() {
        performSegue(withIdentifier: K.Identifiers.loginToRegister, sender: self)
    }
}
