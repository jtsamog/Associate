//
//  CurrentEventViewController.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-15.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit

class CurrentEventViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var sideMenu: UIView!
    @IBOutlet weak var leadingContraint: NSLayoutConstraint!
    
    @IBOutlet weak var leaveEventButton: UIButton!
    
    @IBOutlet var blueButtons: [UIButton]!
    
    @IBOutlet weak var blurView: UIView!
    
    
    //MARK: Properties
    var menuShowing = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        blurView.isHidden = true
        
        sideMenu.layer.shadowOpacity = 1
        
        prettyUI()
    }
    
    
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        
        if(menuShowing) {
            leadingContraint.constant = -200
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                
                self.blurView.isHidden = true
            })
        } else {
            leadingContraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                
                self.blurView.isHidden = false
            })
        }
        menuShowing = !menuShowing
    }
    
    @IBAction func leaveEventTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: UICode 

private extension CurrentEventViewController {
    
    func prettyUI() {
        
        leaveEventButton.layer.backgroundColor = UIColor.white.cgColor
        leaveEventButton.layer.borderColor = UIColor.red.cgColor
        leaveEventButton.layer.borderWidth = 3
        leaveEventButton.layer.cornerRadius = 10
        
        for button in blueButtons {

            button.layer.backgroundColor = UIColor.white.cgColor
            button.layer.borderColor = UIColor.blue.cgColor
            button.layer.borderWidth = 3
            button.layer.cornerRadius = 10
        }
        
    }
    
}


    
  

