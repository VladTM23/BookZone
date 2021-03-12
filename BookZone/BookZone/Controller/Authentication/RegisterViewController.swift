//
//  RegisterViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14/10/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var navbarView: NavbarView!

    private var viewModel = RegistrationViewModel()

    private let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()

    private let emailTextField = CustomTextField(placeholder: NSLocalizedString("email", comment: ""), contentType: .emailAddress)
    private let fullNameTextField = CustomTextField(placeholder: NSLocalizedString("fullname", comment: ""), contentType: .name)
    private let passwordTextField = CustomTextField(placeholder: NSLocalizedString("password", comment: ""), isSecureField: true, contentType: .oneTimeCode)

    private var profileImage: UIImage?

    private let authButton: AuthButton = {
        let button = AuthButton(title: NSLocalizedString("signUp", comment: ""), type: .system)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.alpha = 0.5
        return button
    }()

    private let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: NSLocalizedString("haveAnAccount", comment: ""), attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSAttributedString(string: NSLocalizedString("signIn", comment: ""), attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        passwordTextField.delegate = self
        configureTextFieldObservers()
    }

    // MARK: - User interface

    func configureUI() {
        configureNavbar()

        view.addSubview(selectPhotoButton)
        selectPhotoButton.setDimensions(height: 225, width: 225)
        selectPhotoButton.centerX(inView: view)
        selectPhotoButton.anchor(top: navbarView.bottomAnchor, paddingTop: 15)

        let stack = UIStackView(arrangedSubviews: [emailTextField, fullNameTextField, passwordTextField, authButton])
        stack.axis = .vertical
        stack.spacing = 16

        view.addSubview(stack)
        stack.anchor(top: selectPhotoButton.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)

        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                      right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    }

    func configureNavbar() {
        navbarView.titleLabelNavbar.text = NSLocalizedString(K.NavbarTitles.registerTitle, comment: "")
    }

    // MARK: - Helpers

    func checkFormStatus() {
        if viewModel.formIsValid {
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        } else {
            authButton.isEnabled = false
            authButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }

    func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    func performNavigation() {
        let didDoTutorial = UserDefaults.standard.bool(forKey: K.UserKeys.tutorialCompleted)
        didDoTutorial ? performSegue(withIdentifier: K.Identifiers.registerSuccess, sender: self) :
                    performSegue(withIdentifier: K.Identifiers.registerToTutorial, sender: self)
    }

    // MARK: - Actions

    @objc func handleSelectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else {
            viewModel.fullName = sender.text
        }

        checkFormStatus()
    }

    @objc func handleRegister() {
        
        let alert = UIAlertController(title: "Missing information!", message: "You must complete all the fields in order to register.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        guard let email = emailTextField.text else { self.present(alert, animated: true, completion: nil);return }
        guard let fullName = fullNameTextField.text else { self.present(alert, animated: true, completion: nil)
            return }
        guard let password = passwordTextField.text else { self.present(alert, animated: true, completion: nil)
            return }
        
        
        guard let profileImage = self.profileImage else {
            
            let alert = UIAlertController(title: "Your profile photo!", message: "You must upload a profile photo to proceed.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }

        if !ReachabilityManager.shared.hasConnectivity() {
            let alert = UIAlertController(title: "No internet connection", message: NSLocalizedString(K.Errors.internetError, comment: "") , preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            return
        }

        let credentials = AuthCredentials(email: email, password: password,
                                          fullName: fullName, profileImage: profileImage)

        AuthService.registerUser(withCredentials: credentials) { error in
            if let error = error {
                
                let e = error.localizedDescription
                var message = ""
                
                if e == "The email address is badly formatted."{
                    message = "Your email seems to be badly formatted. Try using a valid one."
                    let alert = UIAlertController(title: "Problem registering you!", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else if e == "The password must be 6 characters long or more." {
                    message = "Your password must be at least 6 characters long."
                    let alert = UIAlertController(title: "Problem registering you!", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else if e == "No photo." {
                    message = "You must upload a profile photo to proceed."
                    let alert = UIAlertController(title: "Problem registering you!", message: message, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                return
            }

            self.performNavigation()
        }
    }

    @objc func handleShowLogin() {
        performSegue(withIdentifier: K.Identifiers.registerToLogin, sender: self)
    }
}

//MARK: - ImagePickerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        selectPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        selectPhotoButton.layer.borderWidth = 3
        selectPhotoButton.layer.cornerRadius = 10
        selectPhotoButton.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
