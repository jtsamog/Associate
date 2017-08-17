//
//  Event.swift
//  Associate
//
//  Created by Endeavour2 on 8/14/17.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit
import Foundation
import Parse

final class Event: PFObject {

  // MARK: - Properties
    @NSManaged var title: String?
    @NSManaged var eventDescription: String?
    @NSManaged var address: String?
    @NSManaged var addressGeoLoc: PFGeoPoint?
    @NSManaged var image: PFFile
    @NSManaged var user : PFUser
  
    var photo: UIImage?
  
  // MARK: - Initializers
  init(title: String?, image: PFFile, user: PFUser, descrip: String?, addressGeoLoc: PFGeoPoint?) {
        super.init()
        
        self.title = title
        self.eventDescription = descrip
        self.image = image
        self.user = user
        self.addressGeoLoc = addressGeoLoc
  
    }
  
    
    
    
    
//  init(title: String?, eventDescription: String?, address: String?, addressGeoLoc: PFGeoPoint, image: PFFile, user: PFUser) {
//    super.init()
//    self.title = title
//    self.eventDescription = eventDescription
//    self.address = address
//    self.addressGeoLoc = addressGeoLoc
//    self.image = image
//    self.user = user
//  }
  
  override init() {
    super.init()
  }
  
  //MARK: - Overriden
  override class func query() -> PFQuery<PFObject>? {
    let query = PFQuery(className: Event.parseClassName())
    query.includeKey("user")
    query.order(byDescending: "createdAt")
    return query
  }
  
}

//MARK: - PFSubclassing
extension Event: PFSubclassing {
  // required protocol method
  static func parseClassName() -> String {
    return "Event"
  }
}


