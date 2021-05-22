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

    private let emailTextField = CustomTextField(placeholder: NSLocalizedString("email", comment: ""), contentType: .emailAddress)
    private let passwordTextField = CustomTextField(placeholder: NSLocalizedString("password", comment: ""), isSecureField: true, contentType: .oneTimeCode)

    private let authButton: AuthButton = {
        let button = AuthButton(title: NSLocalizedString("logIn", comment: ""), type: .system)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.alpha = 0.5
        return button
    }()

    private let goToRegistrationButton: UIButton = {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: NSLocalizedString("noAccount", comment: ""), attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSAttributedString(string: NSLocalizedString("signUp", comment: ""), attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowRegistration), for: .touchUpInside)

        return button
    }()

    @IBOutlet weak var navbarView: NavbarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
        navbarView.titleLabelNavbar.text = NSLocalizedString(K.NavbarTitles.loginTitle, comment: "")
    }

    // MARK: - Helpers

    func checkFormStatus() {
        if viewModel.formIsValid {
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        } else {
            authButton.isEnabled = false
            authButton.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
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

        if !ReachabilityManager.shared.hasConnectivity() {
            let alert = UIAlertController(title: NSLocalizedString(K.ButtonTiles.noInternetTitle, comment: ""), message: NSLocalizedString(K.Errors.internetError, comment: "") , preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            return
        }

        AuthService.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                let e = error.localizedDescription
                var message = ""
                
                if e == "The email address is badly formatted."{
                    message = "Your email seems to be badly formatted. Try using a valid one."
                    let alert = UIAlertController(title: "Problem signing you in!", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else if e == "There is no user record corresponding to this identifier. The user may have been deleted."{
                    message = "It seems that you do not have an account. Create one now!"
                    let alert = UIAlertController(title: "Problem signing you in!", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                                                    self.performSegue(withIdentifier: K.Identifiers.loginToRegister, sender: self)}))
                    self.present(alert, animated: true, completion: nil)
                }
                else if e == "The password is invalid or the user does not have a password."{
                    message = "Your password is incorect. Try harder remembering it. "
                    let alert = UIAlertController(title: "Problem signing you in!", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                print("DEBUG: Error logging user in \(message)")
                return
            }
            self.performNavigation()
        }
    }
    

    @objc func handleShowRegistration() {
        performSegue(withIdentifier: K.Identifiers.loginToRegister, sender: self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
