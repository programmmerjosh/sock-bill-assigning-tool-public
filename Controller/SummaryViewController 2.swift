//
//  SummaryViewController.swift
//  J'sBillSplitterApp
//
//  Created by Joshua on 2016/11/21.
//  Copyright © 2016 Josh_Dog101. All rights reserved.
//
// * Implement scrollview: still to be done.

import UIKit

class SummaryViewController: UIViewController {
    
    // vars that will receive data from segue
    var displayData  : (name: [String], amount: [String]) = ([], [])
    var tip:Double = 0
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // need to do get the label height and scrollview width after content has been loaded and assigned.
        // otherwise this could have been done in viewDidLoad
        let buttonWidth         = myScrollView.bounds.width
        let labelWidth          = Int(buttonWidth / 3) - 16
        let labelHeight         = Int(buttonWidth / 10)
        let fontSize            = view.frame.width > 414 ? CGFloat(32) : CGFloat(16)
        let topMargin           = 20
        let userDataFont        = UIFont(name: "ChalkboardSE-Regular", size: fontSize)!
        let totalsFont          = UIFont(name: "ChalkboardSE-Bold", size: fontSize)!
        let topTierLabelsFont   = UIFont(name: "ChalkboardSE-Regular", size: fontSize - 5)!
        var incTipTotal :Double = 0
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
            let dblAmount:Double = Double(displayData.amount[i])!
            
            nameLabel.setupLabel(text: name, labelX: 0, labelY: rowY, width: labelWidth, height: labelHeight, font: userDataFont)
            
            exclTipAmountsLabel.setupLabel(
                text: String(format: "%.2f", dblAmount),
                labelX: column2X, labelY: rowY,
                width: labelWidth, height: labelHeight,
                font: userDataFont)
            
            inclTipAmountsLabel.setupLabel(
                text: String(format: "%.2f", dblAmount + dblAmount * (tip / 100)),
                labelX: column3X, labelY: rowY,
                width: labelWidth, height: labelHeight,
                font: userDataFont)
            
            myScrollView.addSubview(nameLabel)
            myScrollView.addSubview(exclTipAmountsLabel)
            myScrollView.addSubview(inclTipAmountsLabel)
            
            excTipTotal += dblAmount
            incTipTotal += dblAmount + (dblAmount * (tip / 100))
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
            text: String(format: "%.2f", incTipTotal),
            labelX: column3X, labelY: finalRowY,
            width: labelWidth, height: labelHeight,
            font: totalsFont)
        
        xTipLabel.setupLabel(
            text: "Exc Tip",
            labelX: column2X, labelY: topMargin,
            width: labelWidth, height: labelHeight,
            font: topTierLabelsFont)
        
        iTipLabel.setupLabel(
            text: "Inc Tip (\(Int(tip))%)",
            labelX: column3X, labelY: topMargin,
            width: labelWidth, height: labelHeight,
            font: topTierLabelsFont)
        
        // Setup done button so the user can go back to the start
        let doneButton  = CustomButton()
        let doneButtonY = topMargin + (i + 2) * labelHeight
        doneButton.setupButton(title: "Done", buttonY: doneButtonY, width: Int(buttonWidth))
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        
        myScrollView.addSubview(totalLabel)
        myScrollView.addSubview(totalAmountLabel)
        myScrollView.addSubview(totalwithTipLabel)
        myScrollView.addSubview(xTipLabel)
        myScrollView.addSubview(iTipLabel)
        myScrollView.addSubview(doneButton)
        
        
        UIView.animate(withDuration: 0.5, animations: {

            // think about hiding labels above this closure and then unhidding them here??

        })
    }
    
    @objc func doneButtonPressed(_ sender: CustomButton) {
        let alert       = UIAlertController(title: "This info will now be discarded.", message: "Only press yes if you are not going to need this information again, otherwise be sure to take a screenshot beforehand.", preferredStyle: .alert)
        let actionYes   = UIAlertAction(title: "Yes. I'm done here.", style: .default) { (action) in
            self.performSegue(withIdentifier: "backToStart", sender: self)
        }
        let actionNo    = UIAlertAction(title: "Cancel", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        present(alert, animated: true, completion: nil)
    }
}
