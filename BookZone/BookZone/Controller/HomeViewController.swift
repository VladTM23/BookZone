//
//  HomeViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
     let imagePicker = UIImagePickerController()

    // MARK: - IBOutlets
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            guard let cgImage = image.cgImage else {return}
            
            let textReader = AppleTextRecognizer()
            textReader.textRecognize(cgImage : cgImage)
            
            let textArray = textReader.getStrings()
            var stringFromArray = ""
            for element in textArray {
                stringFromArray = stringFromArray + " " + element
            }
            
            print(stringFromArray)

        }
        
        imagePicker.dismiss(animated: false, completion: nil)
        performSegue(withIdentifier: K.Identifiers.resultsVCIdentifier, sender: self)
        
    }

    //MARK: - User Interface

    func configureUI() {
        configureMainButton()
    }

    func configureMainButton() {
        mainButton.layer.borderColor = UIColor(named: K.Colors.kaki)?.cgColor
        mainButton.layer.borderWidth = 10
    }
    
    // MARK: - IBActions

    @IBAction func mainCameraTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
       
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: K.Identifiers.infoVCIdentifier, sender: self)
    }
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: K.Identifiers.searchVCIdentifier, sender: self)
    }
}

