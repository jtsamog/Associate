//
//  EventsViewController.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-11.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit
import Parse


class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Cells and Id
    //EventsVC uses newEventCell, id- newEvent, and eventCell, id - event
    
    //MARK: Outlets
    
    @IBOutlet weak var eventTableView: UITableView!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingContraint: NSLayoutConstraint!
    
    @IBOutlet var blueButtons: [UIButton]!
    
    
    //MARK: Properties
    var eventsArray = [Event]()
    var menuShowing = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Events Nearby"
        
        menuView.layer.shadowOpacity = 1
        
        prettyUI()
    }
    
    //MARK: TableView Methods
    //New Event
    
    
    //All Nearby events
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            
            print("\(eventsArray.count) print 1")
            return eventsArray.count
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell:EventTableViewCell = eventTableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as! EventTableViewCell
        
        let event = eventsArray[indexPath.row]
        cell.eventNameLabel.text = event["title"] as? String
        cell.eventDetailsLabel.text = event["eventDescription"] as? String
        cell.eventImageView.image = event.photo
        
        return cell
        
    }
    
    //MARK: Actions
    
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
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        PFUser.logOut()

        _ = PFUser.current()
        
        self.performSegue(withIdentifier:"logoutPop", sender: nil)
    }
}


//MARK: Lifecycle

extension EventsViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Reload wall
        
        getEvents()
    }
    
}


//MARK: Event Pull

private extension EventsViewController {
    
    
    func prettyUI() {
        
        for button in blueButtons {
            
            button.layer.backgroundColor = UIColor.white.cgColor
            button.layer.borderColor = UIColor.blue.cgColor
            button.layer.borderWidth = 3
            button.layer.cornerRadius = 10
            
            
        }
        
        
    }
    
    
    
    func getEvents() {
        
        guard let query = Event.query() else {
            
            print("Unable to query events")
            return
        }
        
        query.findObjectsInBackground { [unowned self] objects, error in
            
            guard let objects = objects as? [Event] else {
                
                print("some problem getting objects")
                return
            }
            self.eventsArray = objects
            //self.eventTableView.reloadData()
            for (index, event)  in objects.enumerated() {
                event.image.getDataInBackground { [unowned self] data, error in
                    if error == nil {
                        if let data = data {
                            self.eventsArray[index].photo = UIImage(data: data)
                        }
                        DispatchQueue.main.async {
                            self.eventTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}







