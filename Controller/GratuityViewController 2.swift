//
//  GratuityViewController.swift
//  J'sBillSplitterApp
//
//  Created by Joshua on 2016/11/19.
//  Copyright © 2016 Josh_Dog101. All rights reserved.
//

import UIKit

class GratuityViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    
    let ten              = CustomButton()
    let fifteen          = CustomButton()
    let twenty           = CustomButton()
    let thirty           = CustomButton()
    let zero             = CustomButton()
    var chosenTip:Double = 0

    @objc func userSelectionConfirmed(_ sender: CustomButton) {
        
        switch sender.tag {
            case 0 : chosenTip = 0
            case 15: chosenTip = 15
            case 20: chosenTip = 20
            case 30: chosenTip = 30
            default: chosenTip = 10
        }
        performSegue(withIdentifier: "toAmounts", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.5, animations: {
            let buttonWidth = Int(self.imageView.frame.width)
            
            self.ten.setTag = 10
            self.ten.setupButton(title: "10%", buttonY: 30, width: buttonWidth)
            self.ten.addTarget(self, action: #selector(self.userSelectionConfirmed), for: .touchUpInside)
            self.imageView.addSubview(self.ten)
            
            self.fifteen.setTag = 15
            self.fifteen.setupButton(title: "15%", buttonY: 90, width: buttonWidth)
            self.fifteen.addTarget(self, action: #selector(self.userSelectionConfirmed), for: .touchUpInside)
            self.imageView.addSubview(self.fifteen)
            
            self.twenty.setTag = 20
            self.twenty.setupButton(title: "20%", buttonY: 150, width: buttonWidth)
            self.twenty.addTarget(self, action: #selector(self.userSelectionConfirmed), for: .touchUpInside)
            self.imageView.addSubview(self.twenty)
            
            self.thirty.setTag = 30
            self.thirty.setupButton(title: "30%", buttonY: 210, width: buttonWidth)
            self.thirty.addTarget(self, action: #selector(self.userSelectionConfirmed), for: .touchUpInside)
            self.imageView.addSubview(self.thirty)
            
            self.zero.setTag = 0
            self.zero.setupButton(title: "Waitron deserves nothing!", buttonY: 270, width: buttonWidth)
            self.zero.addTarget(self, action: #selector(self.userSelectionConfirmed), for: .touchUpInside)
            self.imageView.addSubview(self.zero)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AmountInputViewController
        destinationVC.tip = chosenTip
    }
}

