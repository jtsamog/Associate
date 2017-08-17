//
//  CurrentEventViewController.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-15.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit
import Parse

class CurrentEventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var sideMenu: UIView!
    @IBOutlet weak var leadingContraint: NSLayoutConstraint!
    @IBOutlet weak var leaveEventButton: UIButton!
    @IBOutlet var blueButtons: [UIButton]!
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var joinView: UIView!
    @IBOutlet weak var joinImageView: UIImageView!
    @IBOutlet weak var joinButtn: UIButton!

    var event: Event?
    
    //MARK: Harrisons Outlets
    
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var dockViewHeightConstaint: NSLayoutConstraint!
    
    
    
    
    
    //MARK: Properties
    var menuShowing = false
    
    var messagesArray:[String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        joinImageView.image = event?.photo
    
        blurView.isHidden = true
        
        sideMenu.layer.shadowOpacity = 1
        
        prettyUI()
        
        // Chat Start
        self.messageTableView.dataSource = self
        self.messageTableView.delegate = self
        
        self.messageTextField.delegate = self
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        self.messageTableView.addGestureRecognizer(tapGesture)
        
        self.retrieveMessages()
        // Chat End

    }
    
    //MARK: Actions 
    
    @IBAction func joinTapped(_ sender: Any) {
        
        let joinedEvent = event
        
        let member = PFUser.current()
        
        let relation:PFRelation = joinedEvent!.relation(forKey: "membersInEvent")
        
        relation.add(member!)
        
        joinedEvent?.saveInBackground()

        
    }
    
    
    // Chat start
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        
        self.messageTextField.endEditing(true)
        self.messageTextField.isEnabled = false
        self.sendButton.isEnabled = false
        
        let newMessageObject = PFObject(className:"Messages")
        newMessageObject["Text"] = self.messageTextField.text
        newMessageObject.saveInBackground(block: { (success, error) -> Void in
            if error == nil {
                self.retrieveMessages()
                print("Saved in server")
            } else {
                print(error!)
            }
        })
        
        DispatchQueue.main.async {
            
            self.messageTextField.isEnabled = true
            self.sendButton.isEnabled = true
            self.messageTextField.text = ""
            
        }
    }
    // Chat End
  
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
    
    // Chat Start
    //MARK: Textfield Delegate
    func tableViewTapped() {
        
        self.messageTextField.endEditing(true)
        
    }
    
    func retrieveMessages() {
        
        let query = PFQuery(className: "Messages")
        
        query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) -> Void in
            
            self.messagesArray = [String]()
            
            for messageObject in objects! {
                
                let messageText:String? = (messageObject as PFObject)["Text"] as? String
                
                if messageText != nil {
                    self.messagesArray.append(messageText!)
                }
            }
            
            DispatchQueue.main.async {
                
                self.messageTableView.reloadData()
                
            }
            
            
            
        })
    }


    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.21, animations: {
            self.dockViewHeightConstaint.constant = 335
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.4, animations: {
            self.dockViewHeightConstaint.constant = 60
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    //MARK: Datasource/Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.messageTableView.dequeueReusableCell(withIdentifier: "post", for: indexPath)
        cell.textLabel?.text = self.messagesArray[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messagesArray.count
        
    }

    // Chat End
}

//MARK: UICode 

private extension CurrentEventViewController {
    
    func prettyUI() {
        
        leaveEventButton.layer.backgroundColor = UIColor.red.cgColor
        leaveEventButton.layer.borderColor = UIColor.white.cgColor
        leaveEventButton.layer.borderWidth = 3
        leaveEventButton.layer.cornerRadius = 10
        
        for button in blueButtons {

            button.layer.backgroundColor = UIColor.blue.cgColor
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 3
            button.layer.cornerRadius = 10
        }
        
    }
    
}






