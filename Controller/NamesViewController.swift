//
//  NamesViewController.swift
//  J'sBillSplitterApp
//
//  Created by Joshua on 2016/11/20.
//  Copyright © 2016 Josh_Dog101. All rights reserved.
//

import UIKit

class NamesViewController: UIViewController, UITextFieldDelegate {
    
    var numberToSplit:Int = 0
    var percentage:Float = 0.0
//    var ready:Bool = false
    var currency:String = ""
    @IBOutlet var l1: UILabel!
    @IBOutlet var l2: UILabel!
    @IBOutlet var l3: UILabel!
    @IBOutlet var l4: UILabel!
    @IBOutlet var l5: UILabel!
    @IBOutlet var l6: UILabel!
    @IBOutlet var l7: UILabel!
    @IBOutlet var l8: UILabel!
    @IBOutlet var txtName1: UITextField!
    @IBOutlet var txtName2: UITextField!
    @IBOutlet var txtName3: UITextField!
    @IBOutlet var txtName4: UITextField!
    @IBOutlet var txtName5: UITextField!
    @IBOutlet var txtName6: UITextField!
    @IBOutlet var txtName7: UITextField!
    @IBOutlet var txtName8: UITextField!
    @IBOutlet var goButtonOutlet: UIButton!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var nextButtonTopConstraint: NSLayoutConstraint!
    
    let limitLength = 10
    
    @IBAction func goButtonAction(_ sender: UIButton) {
        
        if (numberToSplit == 2)
        {
            if (txtName1.text != "" && txtName2.text != "")
            {
                fields.ready = true
            }
            else
            {
                fields.ready = false
            }
        }
        else if (numberToSplit == 3)
        {
            if (txtName1.text != "" && txtName2.text != "" && txtName3.text != "")
            {
                fields.ready = true
            }
            else
            {
                fields.ready = false
            }
        }
        else if (numberToSplit == 4)
        {
            if (txtName1.text != "" && txtName2.text != "" && txtName3.text != "" && txtName4.text != "")
            {
                fields.ready = true
            }
            else
            {
                fields.ready = false
            }
        }
        else if (numberToSplit == 5)
        {
            if (txtName1.text != "" && txtName2.text != "" && txtName3.text != "" && txtName4.text != "" && txtName5.text != "")
            {
                fields.ready = true
            }
            else
            {
                fields.ready = false
            }
        }
        else if (numberToSplit == 6)
        {
            if (txtName1.text != "" && txtName2.text != "" && txtName3.text != "" && txtName4.text != "" && txtName5.text != "" && txtName6.text != "")
            {
                fields.ready = true
            }
            else
            {
                fields.ready = false
            }
        }
        else if (numberToSplit == 7)
        {
            if (txtName1.text != "" && txtName2.text != "" && txtName3.text != "" && txtName4.text != "" && txtName5.text != "" && txtName6.text != "" && txtName7.text != "")
            {
                fields.ready = true
            }
            else
            {
                fields.ready = false
            }
        }
        else if (numberToSplit == 8)
        {
            if (txtName1.text != "" && txtName2.text != "" && txtName3.text != "" && txtName4.text != "" && txtName5.text != "" && txtName6.text != "" && txtName7.text != "" && txtName8.text != "")
            {
                fields.ready = true
            }
            else
            {
                fields.ready = false
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= limitLength
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nextButtonTopConstraint = NSLayoutConstraint(item: goButtonOutlet, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.topMargin, multiplier: 1.0, constant: -116)
        
        NSLayoutConstraint.activate([nextButtonTopConstraint])
        
        initialSetUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.8, animations: {
            self.prepareForLoad()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if (fields.ready == true)
//        {
//            let Dest: AmountInputViewController = segue.destination as! amountInputViewController
//            
//            Dest.numberOfSplits = numberToSplit
//            Dest.tipPercentage = percentage
//            Dest.currency = currency
//            //Dest.goodtogo = ready
//
//            if (numberToSplit == 2)
//            {
//                Dest.button1NewName = txtName1.text!
//                Dest.button2NewName = txtName2.text!
//            }
//            else if (numberToSplit == 3)
//            {
//                Dest.button1NewName = txtName1.text!
//                Dest.button2NewName = txtName2.text!
//                Dest.button3NewName = txtName3.text!
//            }
//            else if (numberToSplit == 4)
//            {
//                Dest.button1NewName = txtName1.text!
//                Dest.button2NewName = txtName2.text!
//                Dest.button3NewName = txtName3.text!
//                Dest.button4NewName = txtName4.text!
//            }
//            else if (numberToSplit == 5)
//            {
//                Dest.button1NewName = txtName1.text!
//                Dest.button2NewName = txtName2.text!
//                Dest.button3NewName = txtName3.text!
//                Dest.button4NewName = txtName4.text!
//                Dest.button5NewName = txtName5.text!
//            }
//            else if (numberToSplit == 6)
//            {
//                Dest.button1NewName = txtName1.text!
//                Dest.button2NewName = txtName2.text!
//                Dest.button3NewName = txtName3.text!
//                Dest.button4NewName = txtName4.text!
//                Dest.button5NewName = txtName5.text!
//                Dest.button6NewName = txtName6.text!
//            }
//            else if (numberToSplit == 7)
//            {
//                Dest.button1NewName = txtName1.text!
//                Dest.button2NewName = txtName2.text!
//                Dest.button3NewName = txtName3.text!
//                Dest.button4NewName = txtName4.text!
//                Dest.button5NewName = txtName5.text!
//                Dest.button6NewName = txtName6.text!
//                Dest.button7NewName = txtName7.text!
//            }
//            else if (numberToSplit == 8)
//            {
//                Dest.button1NewName = txtName1.text!
//                Dest.button2NewName = txtName2.text!
//                Dest.button3NewName = txtName3.text!
//                Dest.button4NewName = txtName4.text!
//                Dest.button5NewName = txtName5.text!
//                Dest.button6NewName = txtName6.text!
//                Dest.button7NewName = txtName7.text!
//                Dest.button8NewName = txtName8.text!
//            }
//        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        txtName1.resignFirstResponder()
        txtName2.resignFirstResponder()
        txtName3.resignFirstResponder()
        txtName4.resignFirstResponder()
        txtName5.resignFirstResponder()
        txtName6.resignFirstResponder()
        txtName7.resignFirstResponder()
        txtName8.resignFirstResponder()
        
        return true
    }
    
    public func prepareForLoad() {
        
        var start:Float = 0.0
        var jump:Float = 0.0
        
        if (txtName1.bounds.height < 35)
        {
            start = 160.0
            jump = 42.0
        }
        else
        {
            start = 260.0
            jump = 76.0
        }
        
        if (numberToSplit == 2)
        {
            self.nextButtonTopConstraint.constant = CGFloat(start)
        }
        else if (numberToSplit == 3)
        {
            self.nextButtonTopConstraint.constant = CGFloat(start + jump)
        }
        else if (numberToSplit == 4)
        {
            self.nextButtonTopConstraint.constant = CGFloat(start + jump * 2)
        }
        else if (numberToSplit == 5)
        {
            self.nextButtonTopConstraint.constant = CGFloat(start + jump * 3)
        }
        else if (numberToSplit == 6)
        {
            self.nextButtonTopConstraint.constant = CGFloat(start + jump * 4)
        }
        else if (numberToSplit == 7)
        {
            self.nextButtonTopConstraint.constant = CGFloat(start + jump * 5)
        }
        else if (numberToSplit == 8)
        {
            self.nextButtonTopConstraint.constant = CGFloat(start + jump * 6)
        }
        self.view.layoutIfNeeded()
    }
    
    func initialSetUp() {
        
        messageLabel.isHidden = true
        
        if (numberToSplit == 2)
        {
            l3.isHidden = true
            l4.isHidden = true
            l5.isHidden = true
            l6.isHidden = true
            l7.isHidden = true
            l8.isHidden = true
            
            txtName3.isHidden = true
            txtName4.isHidden = true
            txtName5.isHidden = true
            txtName6.isHidden = true
            txtName7.isHidden = true
            txtName8.isHidden = true
        }
        else if (numberToSplit == 3)
        {
            l4.isHidden = true
            l5.isHidden = true
            l6.isHidden = true
            l7.isHidden = true
            l8.isHidden = true
            
            txtName4.isHidden = true
            txtName5.isHidden = true
            txtName6.isHidden = true
            txtName7.isHidden = true
            txtName8.isHidden = true
        }
        else if (numberToSplit == 4)
        {
            l5.isHidden = true
            l6.isHidden = true
            l7.isHidden = true
            l8.isHidden = true
            
            txtName5.isHidden = true
            txtName6.isHidden = true
            txtName7.isHidden = true
            txtName8.isHidden = true
        }
        else if (numberToSplit == 5)
        {
            l6.isHidden = true
            l7.isHidden = true
            l8.isHidden = true
            
            txtName6.isHidden = true
            txtName7.isHidden = true
            txtName8.isHidden = true
        }
        else if (numberToSplit == 6)
        {
            l7.isHidden = true
            l8.isHidden = true
            
            txtName7.isHidden = true
            txtName8.isHidden = true
        }
        else if (numberToSplit == 7)
        {
            l8.isHidden = true
            
            txtName8.isHidden = true
        }
        else if (numberToSplit == 8)
        {
            // nothing to hide apart from message
            messageLabel.isHidden = true
        }
        else
        {
            l1.isHidden = true
            l2.isHidden = true
            l3.isHidden = true
            l4.isHidden = true
            l5.isHidden = true
            l6.isHidden = true
            l7.isHidden = true
            l8.isHidden = true
            
            txtName1.isHidden = true
            txtName2.isHidden = true
            txtName3.isHidden = true
            txtName4.isHidden = true
            txtName5.isHidden = true
            txtName6.isHidden = true
            txtName7.isHidden = true
            txtName8.isHidden = true
            
            goButtonOutlet.isHidden = true
            messageLabel.isHidden = false
        }
        
        if (txtName1.alpha == 1.0)
        {
            self.txtName1.becomeFirstResponder()
        }
        
        self.txtName1.delegate = self
        self.txtName2.delegate = self
        self.txtName3.delegate = self
        self.txtName4.delegate = self
        self.txtName5.delegate = self
        self.txtName6.delegate = self
        self.txtName7.delegate = self
        self.txtName8.delegate = self
    }
    
    struct fields {
        static var ready:Bool = false
    }

}
