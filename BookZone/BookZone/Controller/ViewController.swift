//
//  ViewController.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 11/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel1: UILabel!
    @IBOutlet weak var infoLabel2: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
         
        //SendGoodreadsAPI().getByISBN(isbn: "0441172717")
        //SendGoodreadsAPI().getByTitle(titleArray: ["The","shining"], authorArray: [])
        
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
               
            titleLabel.text = stringFromArray
            
            let goodreads = SendGoodreadsAPI()
           
             goodreads.getByTitle(titleArray: textArray, authorArray: [])
               
            let labelArray = goodreads.getlabelArray()
            
            print(labelArray)
            
            
         
            
            
            
            
            
        }
        
      
        
        imagePicker.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
  
}

