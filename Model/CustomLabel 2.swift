//
//  CustomLabel.swift
//  J'sBillSplitterApp
//
//  Created by Joshua Van Niekerk on 01/11/2019.
//  Copyright © 2019 Josh_Dog101. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    func setupLabel(text: String = "", labelX: Int = 0, labelY: Int = 0, width: Int = 100, height: Int = 30, font: UIFont = UIFont(name: "Arial", size: 18)!) {
        
        let labelFrame = CGRect(x: labelX, y: labelY, width: width, height: height)
        let aColor     = UIColor(named: "customControlColor")
        
        self.text                   = text
        frame                       = labelFrame
        textColor                   = aColor
        self.font                   = font
        adjustsFontSizeToFitWidth   = true
    }
}
