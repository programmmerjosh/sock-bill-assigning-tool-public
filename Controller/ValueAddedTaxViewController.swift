//
//  ValueAddedTaxViewController.swift
//  JsBillSplitterApp
//
//  Created by Joshua Van Niekerk on 02/03/2022.
//  Copyright © 2022 Josh_Dog101. All rights reserved.
//

import UIKit
import GoogleMobileAds
import StoreKit

class ValueAddedTaxViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var lblInfo: PaddingLabel!
    @IBOutlet weak var txtVATamount: UITextField!
    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var lblHide: UILabel!
    @IBOutlet weak var btnHide: UIButton!
    @IBAction func btnHide(_ sender: UIButton) {
        self.txtVATamount.resignFirstResponder()
        UIView.animate(withDuration: 0.5, animations: {
            self.btnHide.alpha = 0
            self.lblHide.alpha = 0
        })
    }
    
    @IBAction func textfieldTouchDown(_ sender: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
            self.btnHide.alpha = 1
            self.lblHide.alpha = 1
        })
    }
    
    // vars receiving values from segue
    var tip:Double = 0
    var interstitial: GADInterstitial!
    let nextButton              = CustomButton()
    private var vat: Double {
        get {
            guard let number = Double(txtVATamount.text!) else {return 0}
            if (number >= 0) {
                return number
            }
            return 0
        }
        set {
            txtVATamount.text = "\(newValue)"
        }
    }
    
    @objc func nextButtonTapped(_ sender: CustomButton) {
        
        let myAd = ad()
        
        if !myAd.hasPurchased() {
            // load interstitial ad
            if (interstitial.isReady) {
                interstitial.present(fromRootViewController: self)
                interstitial = myAd.createAd()
            }
        }
        
        performSegue(withIdentifier: "toAmounts", sender: self)
    }
    
//    //MARK: - getKeyboardHeight
//    @objc func keyboardWillShow(notification: Notification) {
//        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
//        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
//        let keyboardRectangle     = keyboardFrame.cgRectValue
//        let keyboardHeight        = keyboardRectangle.height
//        // get keyboard height so that we can know how much to adjust vertical button constraints
//        self.keyboardHeight       = keyboardHeight
//    }
//
//    @objc func keyboardWillHide(notification: Notification) {
//        // keyboard is dismissed/hidden from the screen
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnHide.alpha = 0
        lblHide.alpha = 0
        lblInfo.layer.cornerRadius = 10
        lblInfo.clipsToBounds = true
        lblInfo.backgroundColor = UIColor.init(hexString: "fff", withAlpha: 0.5)
        lblInfo.paddingLeft = 15
        lblInfo.paddingRight = 15
        lblInfo.paddingTop = 8
        lblInfo.paddingBottom = 8
        
//        TODO: FIX CONSTRAINTS AND AUTO-LAYOUTS
//        TODO: RESTRICT ORIENTATION TO PORTRAIT WHERE APPLICABLE
        
        lblInfo.text = "Enter value added tax (VAT) here ONLY if it was NOT included in the item prices AND was added to your bill/check total.\nIf VAT is 20%, type in 20.\nIf this is not applicable, leave it blank and tap next."
        
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
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       AppUtility.lockOrientation(.portrait)
       // Or to rotate and lock
       // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       
       // Don't forget to reset when view is being removed
       AppUtility.lockOrientation(.all)
   }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            let buttonWidth = Int(self.view.frame.width)
            let buttonY = Int(self.view.frame.height / 1.25)
            
            self.nextButton.setTag = 10
            self.nextButton.setupButton(title: "Next", buttonY: buttonY, width: buttonWidth)
            self.nextButton.setTitle("Next", for: .normal)
            self.nextButton.setTitleColor(UIColor.white, for: .normal)
            
            let backgroundImage = UIImage.init(named: "3288700-dark-backgrounds.jpg")
            self.nextButton.setBackgroundImage(backgroundImage, for: .normal)
            self.nextButton.clipsToBounds       = true
            self.nextButton.addTarget(self, action: #selector(self.nextButtonTapped), for: .touchUpInside)
            self.view.addSubview(self.nextButton)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AmountInputViewController
        destinationVC.tip = tip
        destinationVC.vat = vat
    }
}
