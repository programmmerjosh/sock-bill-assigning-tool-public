//
//  SummaryViewController.swift
//  J'sBillSplitterApp
//
//  Created by Joshua on 2016/11/21.
//  Copyright © 2016 Josh_Dog101. All rights reserved.
//
// my BANNER ad unit ID: ca-app-pub-4641419831043271/6856571141
// my INTERSTITIAL ad unit ID: ca-app-pub-4641419831043271/8859621042

import UIKit
import GoogleMobileAds
import StoreKit

class SummaryViewController: UIViewController, SKPaymentTransactionObserver {
    
    // vars that will receive data from segue
    var displayData  : (name: [String], amount: [String]) = ([], [])
    var tip:Double = 0
    var vat:Double = 0
    
    let productID = "adfreeversion"
    
    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var btnRemoveAds: UIButton!
    
    @IBAction func removeAds(_ sender: UIButton) {
        displayAlert()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
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
        
        myScrollView.isDirectionalLockEnabled = true

        SKPaymentQueue.default().add(self)
        
        let myAd = ad()
        
        if myAd.hasPurchased() {
            // remove ads
            btnRemoveAds.alpha = 0
            adBanner.alpha = 0
        } else {
            // show ads
            loadBanner()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let buttonWidth         = myScrollView.bounds.width
        let labelWidth          = Int(buttonWidth / 3) - 16
        let labelHeight         = Int(buttonWidth / 10)
        let fontSize            = view.frame.width > 414 ? CGFloat(32) : CGFloat(16)
        let topMargin           = 60
        let userDataFont        = UIFont(name: "ChalkboardSE-Regular", size: fontSize)!
        let totalsFont          = UIFont(name: "ChalkboardSE-Bold", size: fontSize)!
        let topTierLabelsFont   = UIFont(name: "ChalkboardSE-Regular", size: fontSize - 5)!
        var incTipAndVatTotal :Double = 0
        var excTipTotal :Double = 0
        
        let column2X = Int(buttonWidth / 2) - (labelWidth / 2) + 8
        let column3X = Int(buttonWidth / 1.5) + 8
        
        // append all necessary data to each appropriate variable
        var i:Int = 0
        
        for name in displayData.name {
            
            let nameLabel           = CustomLabel()
            let exclTipAmountsLabel = CustomLabel()
            let inclTipAmountsLabel = CustomLabel()
    
            let rowY = topMargin + (i + 1) * labelHeight
            
            let dblAmountPlusVAT:Double = Double(displayData.amount[i])! + (Double(displayData.amount[i])! * (vat / 100))
            
            nameLabel.setupLabel(text: name, labelX: 0, labelY: rowY, width: labelWidth, height: labelHeight, font: userDataFont)
            
            exclTipAmountsLabel.setupLabel(
                text: String(format: "%.2f", dblAmountPlusVAT),
                labelX: column2X, labelY: rowY,
                width: labelWidth, height: labelHeight,
                font: userDataFont)
            
            inclTipAmountsLabel.setupLabel(
                text: String(format: "%.2f", dblAmountPlusVAT + dblAmountPlusVAT * (tip / 100)),
                labelX: column3X, labelY: rowY,
                width: labelWidth, height: labelHeight,
                font: userDataFont)
            
            myScrollView.addSubview(nameLabel)
            myScrollView.addSubview(exclTipAmountsLabel)
            myScrollView.addSubview(inclTipAmountsLabel)
            
            excTipTotal += dblAmountPlusVAT
            incTipAndVatTotal += dblAmountPlusVAT + (dblAmountPlusVAT * (tip / 100))
            
            i += 1
        }
        
        let totalLabel          = CustomLabel()
        let totalAmountLabel    = CustomLabel()
        let totalwithTipLabel   = CustomLabel()
        let xTipLabel           = CustomLabel()
        let iTipLabel           = CustomLabel()
        
        let finalRowY = topMargin + (i + 1) * labelHeight
        
        totalLabel.setupLabel(
            text: "TOTAL",
            labelX: 0, labelY: finalRowY,
            width: labelWidth, height: labelHeight,
            font: totalsFont)
        
        totalAmountLabel.setupLabel(
            text: String(format: "%.2f", excTipTotal),
            labelX: column2X, labelY: finalRowY,
            width: labelWidth, height: labelHeight,
            font: totalsFont)
        
        totalwithTipLabel.setupLabel(
            text: String(format: "%.2f", incTipAndVatTotal),
            labelX: column3X, labelY: finalRowY,
            width: labelWidth, height: labelHeight,
            font: totalsFont)
        
        xTipLabel.setupLabel(
            text: vat > 0 ? "Added VAT (\(Int(vat))%)" : "No VAT",
            labelX: column2X, labelY: topMargin,
            width: labelWidth, height: labelHeight,
            font: topTierLabelsFont)
        
        iTipLabel.setupLabel(
            text: "Added Tip (\(Int(tip))%)",
            labelX: column3X, labelY: topMargin,
            width: labelWidth, height: labelHeight,
            font: topTierLabelsFont)
        
        // Setup done button so the user can go back to the start
        let doneButton  = CustomButton()
        let doneButtonY = topMargin + (i + 2) * labelHeight
        doneButton.setupButton(title: "Done", buttonY: doneButtonY, width: Int(buttonWidth))
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        
        let end = doneButton.frame.maxY
        
        // reset scrollView if the number of buttons exceeds the view area
        if (end > self.view.frame.height - 140) {
            myScrollView.contentSize = CGSize(width: self.view.frame.width, height: end + 50)
        }
        
        myScrollView.addSubview(totalLabel)
        myScrollView.addSubview(totalAmountLabel)
        myScrollView.addSubview(totalwithTipLabel)
        myScrollView.addSubview(xTipLabel)
        myScrollView.addSubview(iTipLabel)
        myScrollView.addSubview(doneButton)
        
    }
    
    @objc func doneButtonPressed(_ sender: CustomButton) {
        let alert       = UIAlertController(title: "This info will now be discarded.", message: "Only press yes if you are not going to need this information again, otherwise be sure to take a screenshot beforehand.", preferredStyle: .alert)
        let actionYes   = UIAlertAction(title: "Yes. I'm done here.", style: .default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        let actionNo    = UIAlertAction(title: "Cancel", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        present(alert, animated: true, completion: nil)
    }
}
