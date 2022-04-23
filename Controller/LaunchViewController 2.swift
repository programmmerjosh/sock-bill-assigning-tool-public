//
//  launchViewController.swift
//  J'sBillSplitterApp
//
//  Created by Joshua on 2016/12/08.
//  Copyright © 2016 Josh_Dog101. All rights reserved.
//

import UIKit
import StoreKit

class LaunchViewController: UIViewController, SKPaymentTransactionObserver {
    
    @IBOutlet weak var restoreAccessIBO: UIButton!
    @IBOutlet weak var infoIBO: UIButton!
    @IBOutlet weak var termsofuseIBO: UIButton!
    @IBOutlet weak var privacypolicyIBO: UIButton!
    
    private let productID = "assignandpay"

    @IBAction func restoreAccessPressed(_ sender: UIButton) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    @IBAction func infoPressed(_ sender: UIButton) {
        displayAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        SKPaymentQueue.default().add(self)
        
        if hasPurchased() {
            restoreAccessIBO.alpha  = 0
            infoIBO.alpha           = 0
            termsofuseIBO.alpha     = 0
            privacypolicyIBO.alpha  = 0
            accessGranted()
        } else {
            restoreAccessIBO.alpha  = 1
            infoIBO.alpha           = 1
            termsofuseIBO.alpha     = 1
            privacypolicyIBO.alpha  = 1
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        displayTempAlert()
//    }
    
    @objc func showNavController() {
        performSegue(withIdentifier: "launchToNav", sender: self)
    }
    
    func displayAlert() {
        
        let accessMessage =  "Use this app for FREE for 3 months!! Still want to use the app after that? You'll need to pay. That's how it works. Even then, it's super cheap! So, don't fret.\n\nThe Full Access subscription can be purchased right here for £0.99 if purchasing from the UK App Store or it's equivalant pricing tier if you are purchasing from another country.\n\nYou can cancel the subscription at anytime in Settings -> AppleID -> Subscriptions. For more information, select 'Nope' and click on the 'Terms Of Use' button or 'Privacy Policy' button."
        
        let alert         = UIAlertController(title: "Access", message: accessMessage, preferredStyle: .alert)
        let yesAction     = UIAlertAction(title: "Yes!", style: .default) { (action) in
            self.buyAccess()
        }
        
        let cancelAction  = UIAlertAction(title: "Nope", style: .default) { (action) in }
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
//    func displayTempAlert() {
//        let alert       = UIAlertController(title: "Info", message: "Enjoy this app for free for now. It won't be free forever, in fact, we're working on implementing a free trial period to go with an annual subscription. It'll still be exceptionally cheap (we're talking £1 (GBP) a year, as this is a relatively simple app, but nevertheless. This is just a notice to inform you that it'll be coming soon. But for now, enjoy the free-ness!", preferredStyle: .alert)
//        let OkAction      = UIAlertAction(title: "Okay", style: .default) { (action) in
//            self.accessGranted()
//        }
//
//        alert.addAction(OkAction)
//        present(alert, animated: true, completion: nil)
//    }
    
    // MARK: - In-App Purchases methods
    
    func buyAccess() {
        if SKPaymentQueue.canMakePayments() {
            // user can make payments
            
            let paymentRequest = SKMutablePayment()
            
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("user can't make payments")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
         
         for transaction in transactions {
             if transaction.transactionState == .purchased {
                 // User payment successful
                 print("Transaction successful")
                 
                 accessGranted()
                 
                 UserDefaults.standard.set(true, forKey: productID)
                 SKPaymentQueue.default().finishTransaction(transaction)
                 
             } else if transaction.transactionState == .failed {
                 // Payment failed
                 if let error = transaction.error {
                     let description = error.localizedDescription
                     print("Transaction failed due to error: \(description)")
                 }
                 SKPaymentQueue.default().finishTransaction(transaction)
             } else if transaction.transactionState == .restored {
                 accessGranted()
                 
                 UserDefaults.standard.set(true, forKey: productID)
                 
                 navigationItem.setRightBarButton(nil, animated: true)
                 
                 print("Transaction restored!")
                 
                 SKPaymentQueue.default().finishTransaction(transaction)
             }
         }
     }
    
    func hasPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        
        if purchaseStatus {
            print("Previously purchased")
            return true
        } else {
            print("Never purchased")
            return false
        }
    }
    
    func accessGranted() {
        perform(#selector(LaunchViewController.showNavController), with: nil, afterDelay: 1.5)
    }
    
    @IBAction func termsOfUsePressed(_ sender: UIButton) {
        if let url = URL(string: "https://www.programmmerjosh.com/terms-of-use/assign-and-pay") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func privacyPolicyPressed(_ sender: UIButton) {
        if let url = URL(string: "https://www.programmmerjosh.com/privacy-policy") {
            UIApplication.shared.open(url)
        }
    }
}

extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            
           self.addAttribute(.link, value: linkURL, range: foundRange)
            
            return true
        }
        return false
    }
}
