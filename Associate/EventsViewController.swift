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
    @IBOutlet weak var newEventView: UIView!
    @IBOutlet weak var blurView: UIView!
    
    //MARK: Properties
    
    var eventsArray = [Event]()
    var menuShowing = false
    let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ASSOCIATE"
        
        blurView.isHidden = true
        
        menuView.layer.shadowOpacity = 1
        
        prettyUI()
        
        //Refresh Control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshPull), for: UIControlEvents.valueChanged)
        eventTableView.addSubview(refreshControl)
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
        
       // cellUI(cell: cell)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedEvent = eventsArray[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: "joinEvent", sender: selectedEvent)
        
        print("\(selectedEvent)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let inEvent = sender as? Event {
            let navVC = segue.destination as? UINavigationController
            let currentVC = navVC?.viewControllers.first as? CurrentEventViewController
            
            currentVC?.event = inEvent
            //currentVC?.joinImageView.image = inEvent.photo
            
            //currentVC?.joinImageView.image = inEvent.photo
            
        }
        
    }
    
    //MARK: Actions
    
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
    
    
       
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        PFUser.logOut()

        _ = PFUser.current()
        
        self.performSegue(withIdentifier:"logoutPop", sender: nil)
    }
    
    
    @IBAction func newEventTapped(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3, animations: { self.newEventView.backgroundColor = UIColor.blue }, completion: { ( value :Bool) in
            
            self.newEventView.backgroundColor = UIColor.white
        })

        self.performSegue(withIdentifier: "newEvent", sender: nil)
    }
    
}


//MARK: Lifecycle

extension EventsViewController {
    override func viewWillAppear(_ animated: Bool) {
        if (eventsArray.isEmpty) {
            activityIndicator.startAnimating()
            getEvents()
        }
    }
    
    func refreshPull() {
        activityIndicator.startAnimating()
        getEvents()
    }
}


//MARK: Event Pull

private extension EventsViewController {
    
    
    func prettyUI() {
        
        for button in blueButtons {
            button.layer.backgroundColor = UIColor.blue.cgColor
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 3
            button.layer.cornerRadius = 10
        }
        newEventView.layer.borderColor = UIColor.blue.cgColor
        newEventView.layer.borderWidth = 3
        newEventView.layer.cornerRadius = 14
    }
    
//    func cellUI(cell: EventTableViewCell) {
//        
//        
//        cell.eventJoinButton.layer.cornerRadius = 14
//    }
    
    
//    func userJoined() -> PFRelation<EventUser> {
//        
//        let joinedEvent = PFObject(className:"Event")
//        
//        joinedEvent["membersInEvent"] =  PFRelation<EventUser>
//        
//        joinedEvent.saveInBackground()
//
//    }
    
    
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
                    if let error = error {
                        print(#line, error.localizedDescription)
                        return
                    }
                    guard let data = data else {
                        print(#line, "No data help!")
                        return
                    }
                    self.eventsArray[index].photo = UIImage(data: data)
                    //          DispatchQueue.main.async {
                    self.eventTableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                    //          }
                }
            }
        }
    }
    
    
    
    
    
}
