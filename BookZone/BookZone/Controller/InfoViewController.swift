//
//  InfoViewController.swift
//  BookZone
//
//  Created by Alexandra-Gabriela Laicu-Hausberger on 14/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var navBarView: NavbarView!
    @IBOutlet weak var resultCardView: ResultCardView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - User interface

    func configureUI() {
        configureNavBar()
       
        
//        let image = UIImage(systemName: "multiply.circle.fill")
    
    }

    func configureNavBar() {
        navBarView.titleLabelNavbar.text = K.NavbarTitles.infoTitle
    }
    
}
