//
//  launchViewController.swift
//  J'sBillSplitterApp
//
//  Created by Joshua on 2016/12/08.
//  Copyright © 2016 Josh_Dog101. All rights reserved.
//

import UIKit
import StoreKit

class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessGranted()
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
    
    @objc func showNavController() {
        performSegue(withIdentifier: "launchToNav", sender: self)
    }
    
    func accessGranted() {
        perform(#selector(LaunchViewController.showNavController), with: nil, afterDelay: 1.5)
    }
}
