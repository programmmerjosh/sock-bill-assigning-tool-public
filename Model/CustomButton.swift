//
//  UsernameButton.swift
//  J'sBillSplitterApp
//
//  Created by admin on 01/10/2019.
//  Copyright © 2019 Josh_Dog101. All rights reserved.
//
// Next button wallpaper link: http://wallpapersexpert.com/dark-backgrounds.html

import UIKit

class CustomButton: UIButton {
    
    var setTag: Int?
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton(title: String = "", buttonY: Int = 0, width: Int = Int(UIViewController().view.frame.width)) {
        
        let buttonFrame = positionButtonFrame(yCoordinate: buttonY, width: width)
        let aColor          = UIColor(named: "customControlColor")
        
        setTitleColor(aColor, for: .normal)
        setTitle(title, for: .normal)
        
        titleLabel?.font    = UIFont(name: "AvenirNext-DemiBold", size: 18)
        layer.cornerRadius  = 25
        layer.borderWidth   = 3.0
        layer.borderColor   = UIColor.darkGray.cgColor
        frame               = buttonFrame
        
        if let buttonTag = setTag {
            tag = buttonTag
        }
    }
    
    func makeNextButton() {
        setTitle("Next", for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        
        let backgroundImage = UIImage.init(named: "3288700-dark-backgrounds.jpg")
        setBackgroundImage(backgroundImage, for: .normal)
        clipsToBounds       = true
    }
    
    func positionButtonFrame(xCoordinate:Int = 10, yCoordinate: Int, width: Int = Int(UIViewController().view.frame.width)) -> CGRect {
        
        let buttonFrame  = CGRect(x: xCoordinate, y: yCoordinate, width: width - 20, height: 50)
        
        return buttonFrame
    }
}
