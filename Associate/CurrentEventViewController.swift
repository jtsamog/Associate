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

    @IBOutlet weak var joinLabel: UILabel!
    
    @IBOutlet weak var usersInEventBarButton: UIBarButtonItem!
    @IBOutlet weak var backOrMenuBarButton: UIBarButtonItem!
    
    var event: Event!
    
    //MARK: Harrisons Outlets
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var dockViewHeightConstaint: NSLayoutConstraint!
    
    //MARK: Properties
    var menuShowing = false
    var messagesObjArray:[PFObject] = [PFObject]()
    
    var joined = false
    
    //MARK: User Array
    var usersArray:[PFUser] = [PFUser]()
    
    let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersInEventBarButton.isEnabled = false
        
        self.title = event?.title
        
        //joinLabel.text = event?.title
        joinImageView.image = event?.photo
        blurView.isHidden = true
        sideMenu.layer.shadowOpacity = 1
        prettyUI()
        
        self.messageTableView.dataSource = self
        self.messageTableView.delegate = self
        self.messageTextField.delegate = self
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        self.messageTableView.addGestureRecognizer(tapGesture)
        self.retrieveMessages()
        
        //Refresh Control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshPull), for: UIControlEvents.valueChanged)
        messageTableView.addSubview(refreshControl)
     }
    
    override func viewDidAppear(_ animated: Bool) {
        if (messagesObjArray.isEmpty) {
            activityIndicator.startAnimating()
            retrieveMessages()
        }
    }
    
    func refreshPull() {
        activityIndicator.startAnimating()
        retrieveMessages()
    }
    
    //MARK: PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "usersInEvent") {
            let tvc: EventUsersTableViewController = (segue.destination as? EventUsersTableViewController)!
            tvc.usersInEventArray = usersArray
        }
    }
    
    //MARK: Actions
    @IBAction func logoutTapped(_ sender: UIButton) {
        PFUser.logOut()
        _ = PFUser.current()
        self.performSegue(withIdentifier: "logoutPOP", sender: nil)
    }
    
    @IBAction func joinTapped(_ sender: Any) {
        let joinedEvent = event
        let member = PFUser.current()
        let relation:PFRelation = joinedEvent!.relation(forKey: "membersInEvent")
        relation.add(member!)
        joinedEvent!.saveInBackground(block: { (success, error) -> Void in
            if error == nil {
                self.retrieveUsers()
                print("User added to event")
            } else {
                print(error!)
            }
        })
        joinView.isHidden = true
        usersInEventBarButton.isEnabled = true
        joined = true
        backOrMenuBarButton.image = UIImage(named: "Table")
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        self.messageTextField.endEditing(true)
        self.messageTextField.isEnabled = false
        self.sendButton.isEnabled = false
        let joinedEvent = event!
        let newMessage = EventMessage(msgText: messageTextField.text, creator: PFUser.current() as? EventUser, event: joinedEvent)
        newMessage.saveInBackground(block: { (success, error) -> Void in
            if error == nil {
                self.retrieveMessages()
                let relation = joinedEvent.relation(forKey: "messageInEvent") as! PFRelation<EventMessage>
                relation.add(newMessage)
                print("Saved in server")
                joinedEvent.saveInBackground()
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
  
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        if (joined == false) {
            self.dismiss(animated: true, completion: nil)
        } else {
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
    }
    
    @IBAction func leaveEventTapped(_ sender: UIButton) {
        let joinedEvent = event
        let member = PFUser.current()
        let relation:PFRelation = joinedEvent!.relation(forKey: "membersInEvent")
        relation.remove(member!)
        joinedEvent?.saveInBackground(block: { (success, error) -> Void in
            if error == nil {
                
                self.dismiss(animated: true, completion: nil)
                print("User removed from event")
                
            } else {
                print(error!)
            }
        })
    }
    
    //MARK: Retrievals
    func retrieveMessages() {
        let joinedEvent = event!
        let query = PFQuery(className: "EventMessage")
        query.whereKey("event", equalTo: joinedEvent)
        query.includeKey("creator")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) -> Void in
            self.messagesObjArray = [PFObject]()
            for messageObject in objects! {
                if (messageObject["msgText"] != nil) && (messageObject["creator"] != nil) {
                    self.messagesObjArray.append(messageObject)
                    print(self.messagesObjArray)
                }
            }
            DispatchQueue.main.async {
                self.messageTableView.reloadData()
                let offset = CGPoint(x: 0, y: self.messageTableView.contentSize.height - self.messageTableView.frame.size.height)
                self.messageTableView.contentOffset = offset
                self.messageTableView.separatorStyle = .none
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
            }
            })
    }

    func retrieveUsers() {
        let joinedEvent = event!
        let relation = joinedEvent.relation(forKey: "membersInEvent")
        relation.query().findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) -> Void in
            print("Query complete")
            self.usersArray = [PFUser]()
            for userObject in objects! {
                self.usersArray.append(userObject as! PFUser)
                print("User added to array")
            }
            print(self.usersArray)
        })
    }
 

    //MARK: Textfield Delegate
    func tableViewTapped() {
        self.messageTextField.endEditing(true)
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
        let cell: UserPostTableViewCell = messageTableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! UserPostTableViewCell
        cellUI(cell: cell)
        
        let message = self.messagesObjArray[indexPath.row]
        debugPrint(message)
        let creator = message["creator"] as! PFUser
        cell.messageLabel?.text = message["msgText"] as? String
        cell.postNameLabel?.text = creator["fullname"] as? String
        if let imageFile = creator["profileImage"] as? PFFile {
            imageFile.getDataInBackground { data, error in
                if let error = error {
                    print( #line, error.localizedDescription)
                    return
                }
                guard let data = data else {
                    print(#line, "No Photo to retrieve")
                    return
                }
                cell.postImageView.image = UIImage(data: data)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesObjArray.count
    }
    
}

//MARK: UICode
private extension CurrentEventViewController {
    func prettyUI() {
        leaveEventButton.layer.backgroundColor = UIColor.red.cgColor
        leaveEventButton.layer.borderColor = UIColor.white.cgColor
        leaveEventButton.layer.borderWidth = 3
        leaveEventButton.layer.cornerRadius = 10
        
        joinButtn.layer.cornerRadius = 4
        sendButton.layer.cornerRadius = 4 
        
        for button in blueButtons {
            button.layer.backgroundColor = UIColor.blue.cgColor
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 3
            button.layer.cornerRadius = 10
        }
    }
    
    func cellUI(cell: UserPostTableViewCell) {
        
        cell.borderView.layer.borderWidth = 2
        cell.borderView.layer.borderColor = UIColor.init(colorLiteralRed: 59/255, green: 155/255, blue: 236/255, alpha: 1.0).cgColor
        cell.borderView.layer.cornerRadius = 20

        cell.postImageView.layer.cornerRadius = 20
        cell.postImageView.layer.borderColor = UIColor.black.cgColor
        cell.postImageView.layer.borderWidth = 1
        cell.postImageView.clipsToBounds = true
        
    }
}






