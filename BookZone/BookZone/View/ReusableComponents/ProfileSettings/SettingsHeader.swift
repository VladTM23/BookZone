//
//  SettingsHeader.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 14.11.2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import SDWebImage
import EasyTipView

protocol SettingsHeaderDelegate: class {
    func settingsHeader(_ header: SettingsHeader, didSelect index: Int)
}

class SettingsHeader: UIView {

    // MARK: - Properties

    private let user: User
    var buttons = [UIButton]()
    weak var delegate: SettingsHeaderDelegate?

    lazy var button1 = createButton(0)
    lazy var preferences = createTipPreferences()
    var tipView : EasyTipView!
    var medalButton = 0
    var shieldButton = 0
    var findButton = 0
    var oneIsOpen = 0
    
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        backgroundColor = UIColor(named: K.Colors.kaki)

        let button1 = createButton(0)
        buttons.append(button1)
        
        let screenSize: CGRect = UIScreen.main.bounds
        let width = screenSize.size.width;
        
        let allImages = CGFloat(5 * 50) ;
        let interPadding = CGFloat (40) ;
        let outerPadding = (width - allImages - interPadding) / 3 * 2
            
        print(width)
        
        addSubview(button1)
        button1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        button1.centerX(inView: self)
        button1.anchor(top: topAnchor, bottom: bottomAnchor, paddingTop: 16, paddingBottom: 66)

        let starImage = createAchievementButton(photoName: "stars.png")
        addSubview(starImage)
        starImage.anchor(top:button1.bottomAnchor, left: leftAnchor, paddingTop:10, paddingLeft: outerPadding )
        starImage.alpha = UserDefaults.standard.bool(forKey : "achievement1") ? 1 : 0.3
        
        let medalImage = createAchievementButton(photoName: "medal.png")
        addSubview(medalImage)
        medalImage.anchor(top:button1.bottomAnchor, left: starImage.rightAnchor, paddingTop:10, paddingLeft: 10 )
        medalImage.alpha = UserDefaults.standard.bool(forKey : "achievement2") ? 1 : 0.3
        
        let shieldImage = createAchievementButton(photoName: "shield.png")
        addSubview(shieldImage)
        shieldImage.anchor(top:button1.bottomAnchor, left: medalImage.rightAnchor, paddingTop:10, paddingLeft: 10 )
        shieldImage.alpha = UserDefaults.standard.bool(forKey : "achievement3") ? 1 : 0.3
        
        let findImage = createAchievementButton(photoName: "find.png")
        addSubview(findImage)
        findImage.anchor(top:button1.bottomAnchor, left: shieldImage.rightAnchor, paddingTop:10, paddingLeft: 10 )
        findImage.alpha = UserDefaults.standard.bool(forKey : "achievement4") ? 1 : 0.3
        
        let chatImage = createAchievementButton(photoName: "chat.png")
        addSubview(chatImage)
        chatImage.anchor(top:button1.bottomAnchor, left: findImage.rightAnchor, paddingTop:10, paddingLeft: 10 )
        chatImage.alpha = UserDefaults.standard.bool(forKey : "achievement5") ? 1 : 0.3
        
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
    
    func createUIImageView( photoName : String ) -> UIImageView {
        let imageName = photoName
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return imageView
    }
    
    func createAchievementButton(photoName : String ) -> UIButton {
        let image = UIImage(named: photoName)
        let starImage = UIButton(type: .system)
        starImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        starImage.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        starImage.imageView?.contentMode = .scaleAspectFill
        starImage.addTarget(self, action: #selector(handleStarTouch), for: .touchUpInside)
        starImage.setTitle(photoName, for: .normal)
        starImage.setTitleColor(UIColor.clear, for: .normal)
        starImage.titleLabel?.font =  UIFont(name: "Montserrat", size: 1)
        
        return starImage
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
    
    func createTipPreferences () -> EasyTipView.Preferences {
        var preferences = EasyTipView.Preferences()
        
        preferences.drawing.font = UIFont(name: "Montserrat", size: 13)!
        preferences.drawing.foregroundColor = UIColor.black
        preferences.drawing.backgroundColor = UIColor(named: "grey")!
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        return preferences
    }

    // MARK: - Actions
    @objc func handleSelectPhoto(sender: UIButton) {
        delegate?.settingsHeader(self, didSelect: sender.tag)
    }
    
    @objc func handleStarTouch(sender: UIButton) {
        
        let title = sender.title(for: .normal)
        var text: String
        
        switch title {
        case "stars.png" : text = "Star"
        case "medal.png" :
            text = UserDefaults.standard.bool(forKey : "achievement2") ? "Congrats, you have 5 books on your bookshelf!" :"Collect 5 books on your bookshelf to unlock this achievement!"
           
            if medalButton == 0 && oneIsOpen == 0 {
                tipView = EasyTipView(text: text, preferences: preferences)
                tipView.show(animated: true, forView: sender, withinSuperview: self)
                medalButton = 1
                oneIsOpen = 1
            }
            
            else {
                sender.isUserInteractionEnabled = false
                tipView.dismiss()
                // when spamming the info button, the info view would open and take up the whole screen
                // as a fix, the button is disabled after the second tap (the one which should close the view)
                // the button is enabled after 700ms
                let delayTime = DispatchTime.now() + Double(Int64(0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    sender.isUserInteractionEnabled = true
                }
                medalButton = 0
                oneIsOpen = 0
            }
        case "shield.png":
            text = UserDefaults.standard.bool(forKey : "achievement3") ? "Congrats, you have 25 books on your bookshelf!" :"Collect 25 books on your bookshelf to unlock this achievement!"
           
            if shieldButton == 0 && oneIsOpen == 0 {
                tipView = EasyTipView(text: text, preferences: preferences)
                tipView.show(animated: true, forView: sender, withinSuperview: self)
                shieldButton = 1
                oneIsOpen = 1
            }
            
            else {
                sender.isUserInteractionEnabled = false
                tipView.dismiss()
                // when spamming the info button, the info view would open and take up the whole screen
                // as a fix, the button is disabled after the second tap (the one which should close the view)
                // the button is enabled after 700ms
                let delayTime = DispatchTime.now() + Double(Int64(0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    sender.isUserInteractionEnabled = true
                }
                shieldButton = 0
                oneIsOpen = 0
            }
        case "find.png"  :
            text = UserDefaults.standard.bool(forKey : "achievement4") ? "Congrats, you have 100 books on your bookshelf!" :"Collect 100 books on your bookshelf to unlock this achievement!"
           
            if findButton == 0 && oneIsOpen == 0 {
                tipView = EasyTipView(text: text, preferences: preferences)
                tipView.show(animated: true, forView: sender, withinSuperview: self)
                findButton = 1
                oneIsOpen = 1
            }
            
            else {
                sender.isUserInteractionEnabled = false
                tipView.dismiss()
                // when spamming the info button, the info view would open and take up the whole screen
                // as a fix, the button is disabled after the second tap (the one which should close the view)
                // the button is enabled after 700ms
                let delayTime = DispatchTime.now() + Double(Int64(0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    sender.isUserInteractionEnabled = true
                }
                findButton = 0
                oneIsOpen = 0
            }
        case "chat.png"  : text = "Chat"
        default:
            text = "No achievement found"
        }
  
    }

}




