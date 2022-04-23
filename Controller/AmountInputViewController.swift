//
//  amountInputViewController.swift
//  J'sBillSplitterApp
//
//  Created by Joshua on 2016/11/20.
//  Copyright © 2016 Josh_Dog101. All rights reserved.
//

import UIKit
import ChameleonFramework
import GoogleMobileAds
import StoreKit

class AmountInputViewController: UIViewController, UITextFieldDelegate {
    
    // IB_Outlets
    @IBOutlet var myScrollView     : UIScrollView!
    @IBOutlet var txtAmount        : UITextField!
    @IBOutlet weak var hide: UIButton!
    @IBOutlet weak var undo: UIButton!
    @IBOutlet weak var lblUndo: UILabel!
    @IBOutlet weak var lblHide: UILabel!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var everyone: UIButton!
    @IBOutlet weak var lblEveryone: UILabel!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var lblAdd: UILabel!
    @IBOutlet weak var adBanner: GADBannerView!
    
    // private vars
    private var userDataUpdated  : (name: [String], amount: [String])             = ([], [])
            var log              : (name: [String], amount: [String], split: [Int]) = ([], [], [])
    private var indexPath        : Int = 0
    private let buttonHeightAndPadding = 60
    private var shareCancel:Bool       = false
    private var sharingArray           = [Int]()
    private var nextButtonTappedOnce:Int = 0
    private var amount: String {
        get {
            guard let number = Double(txtAmount.text!) else {return "0.0"}
            return String(format: "%.2f", number)
        }
        set {
            txtAmount.text = "\(newValue)"
        }
    }
    private var emojisOnce = ["🤡", "👽", "💀", "👻", "💩", "🤖", "🎃", "💋", "🧠", "🐸", "🦋", "🦆", "🦑", "🐳", "🐫", "🐠", "🦀", "🦖", "🌹"]
    private var emojisReused = [String()]
    
    // vars receiving values from segue
    var tip:Double = 0
    var vat:Double = 0
    
    // device bounds to be defined
    var keyboardHeight:CGFloat = 0
    
    // declare custom next button
    let myNextButton = CustomButton()
    
    var interstitial: GADInterstitial!

    @IBAction func infoButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showTutorialView", sender: self)
    }
    
    // Hide button pressed action
    @IBAction func hideKeyboardPressed(_ sender: UIButton) {
        self.txtAmount.resignFirstResponder()
        UIView.animate(withDuration: 0.5, animations: {
            self.hide.alpha = 0
            self.lblHide.alpha = 0
        })
    }
    @IBAction func textfieldTouchDown(_ sender: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
            self.hide.alpha = 1
            self.lblHide.alpha = 1
        })
    }
    
    @IBAction func textfieldValChanged(_ sender: UITextField) {
        
        var input = txtAmount.text
        
        if input == "" { input = "0" }
        
        guard let num = Double(input!) else {return}
        
        UIView.animate(withDuration: 0.5, animations: {
            if num > 0 && self.userDataUpdated.name.count > 1 {
                self.share.alpha = 1
                self.lblShare.alpha = 1
            } else {
                self.share.alpha = 0
                self.lblShare.alpha = 0
            }
        })
    }
    
    // Add button pressed
    @IBAction func addNamePressed(_ sender: UIButton) {
        var myTextField = UITextField()
        let alert       = UIAlertController(title: "Add Name", message: "If this person needs to pay for something, add their name.", preferredStyle: .alert)
        let addNameAction      = UIAlertAction(title: "Add Name", style: .default) { (action) in
            
            if let newName = myTextField.text {
                if self.userDataUpdated.name.count == 0 || self.allowNewName(newName) {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.addNewNameButton(newName)
                    })
                }
            }
        }
        
        let cancelAction      = UIAlertAction(title: "Cancel", style: .default) { (action) in }
        
        // accept user input from a textfield with the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Name"
            myTextField                = alertTextField
        }
        alert.addAction(addNameAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sharePressed(_ sender: UIButton) {
        
        if !shareCancel {
            UIView.animate(withDuration: 0.5, animations: {
                self.everyone.alpha = 1
                self.lblEveryone.alpha = 1
                self.lblHide.alpha = 0
                self.hide.alpha = 0
                self.lblUndo.alpha = 0
                self.undo.alpha = 0
                self.add.alpha = 0
                self.lblAdd.alpha = 0
            })
            lblShare.text = "Done"
            txtAmount.resignFirstResponder()
        } else {
            
            splitAnItemAmount(itemAmount: Double(amount)!, buttonTags: sharingArray)
            sharingArray.removeAll()
        }
        shareCancel = !shareCancel
        
        let show:CGFloat = shareCancel == true ? 1 : 0
        
        for case let button as CustomButton in self.myScrollView.subviews {
            UIView.animate(withDuration: 0.5, animations: {
                if button.tag > 900 {
                    button.alpha = show
                } else {
                    button.alpha = show == 1 ? 0 : 1
                }
            })
        }
    }
    
    // Undo button pressed action
    @IBAction func undooooo(_ sender: UIButton) {
        if let count = log.split.last {
            for j in (0..<Int(count)).reversed() {
                undoUserAddition()
                print("no need for \(j) var or this print statement.")
            }
        }
    }
    
    @IBAction func splitAmongstAll(_ sender: UIButton) {
        
        for case let button as CustomButton in self.myScrollView.subviews {
            UIView.animate(withDuration: 0.5, animations: {
                if button.tag > 500 {
                    self.sharingArray.append(button.tag)
                    button.alpha = 0
                } else if button.tag == 500 {
                    button.alpha = 1
                } else {
                    button.alpha = 1
                }
            })
        }
        
        splitAnItemAmount(itemAmount: Double(amount)!, buttonTags: sharingArray)
        sharingArray.removeAll()
    }
    
    // Username button pressed action
    @objc func username(_ sender: CustomButton) {
        
        let title = "\(userDataUpdated.name[sender.tag])"
        let userBalance  = userDataUpdated.amount[sender.tag]
        
        // append data to the log Touple to keep track of user input
        log.name.append(title)
        log.amount.append(amount)
        log.split.append(1)
        
        // as values change, so does the button title
        let x = Double(amount)!
        let y = Double(userBalance)!
        
        amount = String(x + y)
        
        userDataUpdated.amount[sender.tag] = amount
        sender.setTitle(title + " \(userDataUpdated.amount[sender.tag])", for: .normal)
        
        showHideUndo()
        
        // reset textfield every time
        txtAmount.text        = ""
        txtAmount.placeholder = "0.0"
        
        UIView.animate(withDuration: 0.5, animations: {
            self.share.alpha = 0
            self.lblShare.alpha = 0
        })
    }
    
    @objc func nextButtonPressed(_ sender: CustomButton) {
        let myAd = ad()
        
        if !myAd.hasPurchased() {
            // load interstitial ad
            if (interstitial.isReady) {
                interstitial.present(fromRootViewController: self)
                interstitial = myAd.createAd()
            }
        }
        
        performSegue(withIdentifier: "toSummary", sender: self)
    }
    
    @objc func shareUserButtonPressed(_ sender: CustomButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.alpha = 0
        })
        sharingArray.append(sender.tag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hide.alpha = 0
        lblHide.alpha = 0
        
        undo.alpha = 0
        lblUndo.alpha = 0
        
        share.alpha = 0
        lblShare.alpha = 0
        
        everyone.alpha = 0
        lblEveryone.alpha = 0
        
        self.txtAmount.delegate = self
        let buttonWidth         = Int(myScrollView.frame.width)
        
        // next button setup here
        myNextButton.setTag = 500
        myNextButton.setupButton(width: buttonWidth)
        myNextButton.makeNextButton()
        myNextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        myScrollView.addSubview(myNextButton)
        
        // hide them initially
        txtAmount.alpha     = 0
        myNextButton.alpha  = 0
        
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
    
    // this method to observe for when the keyboard appears
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // event listener for orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
         super.viewWillTransition(to: size, with: coordinator)
        
        if (size.width > 414) {
            let buttonWidth = Int(size.width) - 120
            
            for case let button as CustomButton in self.myScrollView.subviews {
                let thisButtonY = Int(button.frame.minY)
                
                print(thisButtonY)
                
                button.frame = button.positionButtonFrame(xCoordinate: 60,yCoordinate: thisButtonY, width: buttonWidth)
            }
        } else {
            let buttonWidth = Int(size.width) - 20
            
            for case let button as CustomButton in self.myScrollView.subviews {
                let thisButtonY = Int(button.frame.minY)
                
                print(thisButtonY)
                
                button.frame = button.positionButtonFrame(yCoordinate: thisButtonY, width: buttonWidth)
            }
        }
    }

    //MARK: - getKeyboardHeight
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle     = keyboardFrame.cgRectValue
        let keyboardHeight        = keyboardRectangle.height
        // get keyboard height so that we can know how much to adjust vertical button constraints
        self.keyboardHeight       = keyboardHeight
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        // keyboard is dismissed/hidden from the screen
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
        NotificationCenter.default.removeObserver(self)
    }
   
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtAmount.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier != "showTutorialView") {
            let destinationVC = segue.destination as! SummaryViewController
            
            // send data to next view controller
            destinationVC.displayData = self.userDataUpdated
            destinationVC.tip         = self.tip
            destinationVC.vat         = self.vat
        }
    }
    
    // user cannot insert a name that has already been used
    func allowNewName(_ newName: String) -> Bool {
        for name in userDataUpdated.name {
            if name == newName {
                return false
            }
        }
        return true
    }
    
    func showHideUndo() {
        // don't show undo button unless there are values to undo
        var anyAmount:Bool = false
        for amount in userDataUpdated.amount {
            if Double(amount)! > 0 { anyAmount = true }
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.undo.alpha    = anyAmount ? 1 : 0
            self.lblUndo.alpha = anyAmount ? 1 : 0
        })
    }
    
    func addNewNameButton(_ title: String) {
        
        let newUsernameButton = CustomButton()
        let userShareButton   = CustomButton()
//        let topMarginHeight   = 116
        var randomInt         = 0
        var newTitle          = ""
        var buttonY           = 0
        let buttonWidth       = Int(myScrollView.frame.width)
        let backColor         = UIColor(hexString: "#16a085")
        
        // Just to spice up the animation a little - add emoji to name,
        // but avoid duplicte emoji's to some extent
        
        if emojisOnce.count > 0 {
            randomInt = Int(arc4random_uniform(UInt32(emojisOnce.count)))
            newTitle  = title + " \(emojisOnce[randomInt])"
            
            emojisReused.append(emojisOnce[randomInt])
            emojisOnce.remove(at: randomInt)
        } else {
            randomInt = Int(arc4random_uniform(UInt32(emojisReused.count)))
            newTitle  = title + " \(emojisReused[randomInt])"
        }
        
        // button setup
        buttonY                  = userDataUpdated.name.count * buttonHeightAndPadding
        newUsernameButton.setTag = indexPath
        newUsernameButton.setupButton(title: newTitle, buttonY: buttonY, width: buttonWidth)
        newUsernameButton.addTarget(self, action: #selector(username), for: .touchUpInside)
        myScrollView.addSubview(newUsernameButton)
        
        userShareButton.setTag = indexPath + 901
        userShareButton.setupButton(title: title, buttonY: buttonY, width: buttonWidth)
        userShareButton.addTarget(self, action: #selector(shareUserButtonPressed), for: .touchUpInside)
        userShareButton.backgroundColor = backColor
        myScrollView.addSubview(userShareButton)
        userShareButton.alpha = 0
        
        shiftNextButtonDown()
        userDataUpdated.name.append(newTitle)
        userDataUpdated.amount.append("0.0")
        indexPath += 1
        
        // user won't need next button until there is more than one name
        txtAmount.alpha     = 1
        if indexPath > 1 {
            myNextButton.alpha  = 1
        }
        
        let end = myNextButton.frame.maxY
        
        // reset scrollView if the number of buttons exceeds the view area
        if (end > self.view.frame.width - 100) {
            myScrollView.contentSize = CGSize(width: self.view.frame.width, height: end + 185)
        }
    }
    
    func shiftNextButtonDown() {
        let y = (userDataUpdated.name.count * buttonHeightAndPadding) + buttonHeightAndPadding
        let buttonWidth = Int(myScrollView.frame.width)
        myNextButton.frame  =  myNextButton.positionButtonFrame(yCoordinate: y, width: buttonWidth)
    }
    
    func splitAnItemAmount(itemAmount: Double, buttonTags: [Int] = [0]) {
        
        if itemAmount > 0 && buttonTags.count > 0 {
            let splitAmount = itemAmount / Double(buttonTags.count)
            
            for case let button as CustomButton in self.myScrollView.subviews {
                
                for tag in buttonTags {
                    if button.tag == tag - 901 {
                        let title = "\(userDataUpdated.name[button.tag])"
                        let userBalance  = userDataUpdated.amount[button.tag]
                        let y = Double(userBalance)!
                        
                        userDataUpdated.amount[button.tag] = String(format: "%.2f", (splitAmount + y))
                        button.setTitle(title + " \(userDataUpdated.amount[button.tag])", for: .normal)
                        
                        log.name.append(title)
                        log.amount.append(String(format: "%.2f", splitAmount))
                        log.split.append(buttonTags.count)
                    }
                }
            }
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.everyone.alpha = 0
            self.lblEveryone.alpha = 0
            self.showHideUndo()
            self.add.alpha = 1
            self.lblAdd.alpha = 1
            
            self.lblShare.alpha = 0
            self.share.alpha = 0
        })
        self.lblShare.text         = "Share"
        self.txtAmount.text        = ""
        self.txtAmount.placeholder = "0.0"
    }
    
    func undoUserAddition() {
        
        
        var once:Bool = false
        var i:Int = 0
        for name in userDataUpdated.name {
            
            if name == log.name.last {
                
                let oldTitle = "\(userDataUpdated.name[i]) \(userDataUpdated.amount[i])"
                
                for case let button as CustomButton in self.myScrollView.subviews {
                    
                    if !once && button.currentTitle == oldTitle {
                        // update userData
                        let x = Double(userDataUpdated.amount[i])!
                        let y = Double(log.amount[log.amount.count - 1])!
                        let userBalance = String(format: "%.2f", (x - y))
                        
                        userDataUpdated.amount[i] = userBalance
                        
                        // remove the last item from log
                        log.name.remove(at: log.name.count - 1)
                        log.amount.remove(at: log.amount.count - 1)
                        log.split.remove(at: log.split.count - 1)
                        
                        let userName    = userDataUpdated.name[i]
                        
                        // update button title
                        button.setTitle("\(userName) \(userBalance)", for: .normal)
                        once = true
                    }
                }
            }
            i += 1
        }
        showHideUndo()
    }
}
