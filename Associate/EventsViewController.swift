//
//  EventsViewController.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-11.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {
    
    //MARK: Cells and Id
    //EventsVC uses newEventCell, id- newEvent, and eventCell, id - event
    
    //MARK: Outlets
    
    @IBOutlet weak var newEventTableView: UITableView!
    @IBOutlet weak var eventTableView: UITableView!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingContraint: NSLayoutConstraint!
    
    //MARK: Properties
    
    var menuShowing = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        menuView.layer.shadowOpacity = 1
        
    }
    
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        
        if(menuShowing) {
            leadingContraint.constant = -200
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            leadingContraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuShowing = !menuShowing
    }
}
