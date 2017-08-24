//
//  EventUsersTableViewController.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-11.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit
import Parse

class EventUsersTableViewController: UITableViewController {
    
    //MARK: Properties
    var usersInEventArray = [PFUser]()
    let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Users In Event"

        //Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refreshPull), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (usersInEventArray.isEmpty) {
            activityIndicator.startAnimating()
            self.tableView.reloadData()
        }
    }
    
    func refreshPull() {
        activityIndicator.startAnimating()
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    // MARK: Datasource/Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersInEventArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! UserTableViewCell
        cellUI(cell: cell)
        let user = usersInEventArray[indexPath.row]
        
        cell.userNameLabel.text = user["fullname"] as? String
        cell.userDescriptonLabel.text = user["profession"] as? String
       
        if let imageFile = user["profileImage"] as? PFFile {
            imageFile.getDataInBackground { data, error in
                
                if let error = error {
                    
                    print( #line, error.localizedDescription)
                    return
                }
                guard let data = data else {
                    print(#line, "No Photo to retrieve")
                    return
                }
                cell.userPicImageView.image = UIImage(data: data)
            }
        }
        cell.connectImageView.image = UIImage(named: "Unchecked2")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let member = PFUser.current()
        let connection = usersInEventArray[ (indexPath as NSIndexPath).row ]
        
        let relation:PFRelation = member!.relation(forKey: "connections")
        relation.add(connection)
        member!.saveInBackground(block: { (success, error) -> Void in
            if error == nil {
                print("Connection added to user")
            } else {
                print(error!)
            }
        })
        
        let cell = tableView.cellForRow(at: indexPath) as! UserTableViewCell
        cell.connectImageView.image = UIImage(named: "Checked2")
    }
}


//MARK: Extensions
private extension EventUsersTableViewController {
    
    func cellUI(cell: UserTableViewCell) {
        
        cell.userPicImageView.clipsToBounds = true
        cell.userPicImageView.layer.cornerRadius = 32
        cell.userPicImageView.layer.borderWidth = 1
        cell.userPicImageView.layer.borderColor = UIColor.black.cgColor
        
        
        
    }
    
    
}




