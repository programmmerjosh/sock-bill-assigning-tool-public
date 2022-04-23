//
//  TutorialViewController.swift
//  JsBillSplitterApp
//
//  Created by Joshua Van Niekerk on 01/03/2022.
//  Copyright © 2022 Josh_Dog101. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
   
    @IBOutlet weak var imgTutorialGif: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var constraintImageWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintImageHeight: NSLayoutConstraint!
    var switchValue:Int = 0
    
    @IBAction func btnSwitch(_ sender: UIButton) {
        switchValue+=1
        if (switchValue % 2 == 0) {
            imgTutorialGif.loadGif(name: "socks-bill-assigning-tool-add-names")
            lblInstructions.text = "Step 1: Add all the names of the people that need to pay their portion of the bill/check"
            lblTitle.text = "Add Names"
            btnSwitch.setTitle("Step 2", for: .normal)
        } else {
            imgTutorialGif.loadGif(name: "socks-bill-assigning-tool-divide-amounts")
            lblInstructions.text = "Step 2: Enter each item amount followed by tapping on the name of the person paying for that item.\nFor shared items, enter the price followed by the share button followed by each person sharing."
            lblTitle.text = "Assign Item Prices"
            btnSwitch.setTitle("Step 1", for: .normal)
        }
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       AppUtility.lockOrientation(.portrait)
       // Or to rotate and lock
       // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       
       // Don't forget to reset when view is being removed
       AppUtility.lockOrientation(.all)
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
//        let width = safeFrame.width
        let height = safeFrame.height
        
        imgTutorialGif.layer.cornerRadius = 10
        imgTutorialGif.clipsToBounds = true
        imgTutorialGif.backgroundColor = .black
        
//        gif dimensions = 314x640
//        ratio = 1:2.038
        
        let imageViewHeight = height - 20 - 25 - 20 - 80 - 30 - 30 - 20 - 40
        let imageViewWidth = imageViewHeight / 2.038
        let widthConstraint = NSLayoutConstraint(item: imgTutorialGif as Any, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: imageViewWidth)
        let heightConstraint = NSLayoutConstraint(item: imgTutorialGif as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: imageViewHeight)
        
        view.addConstraints([widthConstraint, heightConstraint])
        
//        TODO: Try fix compiler warnings
        
        lblInstructions.text = "Step 1: Add all the names of the people that need to pay their portion of the bill/check"
        lblTitle.text = "Add Names"
        imgTutorialGif.loadGif(name: "socks-bill-assigning-tool-add-names")
        btnSwitch.setTitle("Step 2", for: .normal)
        btnDone.setTitle("Done", for: .normal)
    }
}
