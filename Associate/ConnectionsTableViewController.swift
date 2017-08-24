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
    let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Connections"

        //Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refreshPull), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (connectionsArray.isEmpty) {
            activityIndicator.startAnimating()
            self.tableView.reloadData()
        }
    }
    
    func refreshPull() {
        activityIndicator.startAnimating()
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    //MARK: Datasource/Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectionsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ConnectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "connection", for: indexPath) as! ConnectionTableViewCell
        
        cellUI(cell: cell)
        let connection = connectionsArray[indexPath.row]
        cell.userNameLabel.text = connection["fullname"] as? String
        cell.userDescripLabel.text = connection["profession"] as? String
        if let imageFile = connection["profileImage"] as? PFFile {
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedConnection = connectionsArray[ (indexPath as NSIndexPath).row ]
        self.performSegue(withIdentifier: "showDetail", sender: selectedConnection)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let selected = sender as? PFUser {
            
            let detailVC:DetailUserViewController = (segue.destination as? DetailUserViewController)!
            
            detailVC.selectedConnection = selected
        }
        
    }
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
            self.connectionsArray = [PFUser]()
            for userObject in objects! {
                self.connectionsArray.append(userObject as! PFUser)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func cellUI(cell: ConnectionTableViewCell) {
        
        cell.userPicImageView.layer.cornerRadius = 35
        cell.userPicImageView.layer.borderColor = UIColor.black.cgColor
        cell.userPicImageView.layer.borderWidth = 1
        cell.userPicImageView.clipsToBounds = true
        
        
    }
}
