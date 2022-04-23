//
//  GratuityViewController.swift
//  J'sBillSplitterApp
//
//  Created by Joshua on 2016/11/19.
//  Copyright © 2016 Josh_Dog101. All rights reserved.
//

import UIKit
import GoogleMobileAds
import StoreKit

class GratuityViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var lblScreenTitle: UILabel!
    
    let ten              = CustomButton()
    let fifteen          = CustomButton()
    let twenty           = CustomButton()
    let thirty           = CustomButton()
    let zero             = CustomButton()
    var chosenTip:Double = 0
    var interstitial: GADInterstitial!

    @objc func userSelectionConfirmed(_ sender: CustomButton) {
        
        switch sender.tag {
            case 0 : chosenTip = 0
            case 15: chosenTip = 15
            case 20: chosenTip = 20
            case 30: chosenTip = 30
            default: chosenTip = 10
        }
        
        let myAd = ad()
        
        if !myAd.hasPurchased() {
            // load interstitial ad
            if (interstitial.isReady) {
                interstitial.present(fromRootViewController: self)
                interstitial = myAd.createAd()
            }
        }
        
        performSegue(withIdentifier: "toVAT", sender: self)
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
        
        let myAd = ad()
        
        if myAd.hasPurchased() {
            // remove ads
            
            adBanner.alpha = 0
        } else {
            // show ads
            loadBanner()
            interstitial = myAd.interstitial()
        }
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
            self.zero.setupButton(title: "Zero", buttonY: 270, width: buttonWidth)
            self.zero.addTarget(self, action: #selector(self.userSelectionConfirmed), for: .touchUpInside)
            self.imageView.addSubview(self.zero)
        })
        
        let myAd = ad()
        
        if myAd.hasPurchased() {
            // remove ads
            
            adBanner.alpha = 0
        } else {
            // show ads
            loadBanner()
            interstitial = myAd.interstitial()
        }
    }
    
    // event listener for orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
         super.viewWillTransition(to: size, with: coordinator)
        
        let buttonWidth = Int(size.width) - 20
        
        ten.frame = ten.positionButtonFrame(yCoordinate: 30, width: buttonWidth)
        fifteen.frame = fifteen.positionButtonFrame(yCoordinate: 90, width: buttonWidth)
        twenty.frame = twenty.positionButtonFrame(yCoordinate: 150, width: buttonWidth)
        thirty.frame = thirty.positionButtonFrame(yCoordinate: 210, width: buttonWidth)
        zero.frame = zero.positionButtonFrame(yCoordinate: 270, width: buttonWidth)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ValueAddedTaxViewController
        destinationVC.tip = chosenTip
    }
}

