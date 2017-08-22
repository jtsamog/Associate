//
//  ConnectionsTableViewController.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-11.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit
import Parse

class ConnectionsTableViewController: UITableViewController {
    
    var connectionsArray:[PFUser] = [PFUser]()
    
    //MARK: Cell and Id
    //ConnectionsTVC uses connectionCell, id - connection

    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("loaded")
    }

    //MARK: Datasource/Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        print("No content")
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectionsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ConnectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "connection", for: indexPath) as! ConnectionTableViewCell
        
        let connection = connectionsArray[indexPath.row]
        cell.userNameLabel.text = connection["fullname"] as? String
        cell.userDescripLabel.text = connection["profession"] as? String
        //cell.userPicImageView.image = connection.photo
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedConnection = connectionsArray[ (indexPath as NSIndexPath).row ]
        self.performSegue(withIdentifier: "showDetail", sender: selectedConnection)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        
//        if let inConnection = sender as? PFUser {
//            let navVC = segue.destination as? UINavigationController
//            let currentVC = navVC?.viewControllers.first as? ConnectionsTableViewController
//            
//            //currentVC?.connection = inConnection
//        }
//    }
    
    
}

extension ConnectionsTableViewController {

    override func viewWillAppear(_ animated: Bool) {
        retrieveConnections()
    }
}

private extension ConnectionsTableViewController {
    
    func retrieveConnections() {
        
        let member = PFUser.current()
        let relation = member?.relation(forKey: "connections")
        relation?.query().findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) -> Void in
            print("Query complete")
            self.connectionsArray = [PFUser]()
            for userObject in objects! {
                self.connectionsArray.append(userObject as! PFUser)
                print("User added to array")
            }
            print(self.connectionsArray)
        })
    }
}
