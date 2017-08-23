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
    
    //MARK: Cell and Id 
    // EventUsersTVC uses userCell, id - user

    
    
    
    //MARK: Properties
    var usersInEventArray = [PFUser]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Users In Event"

        
    }

  
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersInEventArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! UserTableViewCell

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





