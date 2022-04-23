//
//  NextButton.swift
//  J'sBillSplitterApp
//
//  Created by admin on 03/10/2019.
//  Copyright © 2019 Josh_Dog101. All rights reserved.
//
// Next button wallpaper link: http://wallpapersexpert.com/dark-backgrounds.html

import UIKit

class NextButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        
        setShadow()
        setTitleColor(UIColor.white, for: .normal)
        setTitle("Next", for: .normal)
        
        titleLabel?.font    = UIFont(name: "AvenirNext-DemiBold", size: 25)
        setBackgroundImage("3288700-dark-backgrounds.jpg", for: .normal)
        layer.cornerRadius  = 25
        layer.borderWidth   = 3.0
        layer.borderColor   = UIColor.darkGray.cgColor
    }
    
    private func setShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius  = 8
        layer.shadowOpacity = 0.5
        clipsToBounds       = true
        layer.masksToBounds = false
    }
}
