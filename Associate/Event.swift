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
//    @NSManaged var eventMessage: String?
  
    var photo: UIImage?
  
  // MARK: - Initializers
    init(title: String?,
         image: PFFile,
         user: PFUser,
         descrip: String?,
         addressGeoLoc: PFGeoPoint?,
         address: String?
        )
    {
        super.init()
        
        self.title = title
        self.eventDescription = descrip
        self.image = image
        self.user = user
        self.addressGeoLoc = addressGeoLoc
        self.address = address
        
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
  
//  MARK: - Overriden
//  override class func query() -> PFQuery<PFObject>? {
//    let query = PFQuery(className: Event.parseClassName())
//    query.includeKey("user")
//    query.order(byDescending: "createdAt")
//    return query
//  }
  
     override class func query()-> PFQuery<PFObject>? {
      guard let userGeoPoint = EventUser.current()?.userCurrentLoc else {
        print("User location not available")
        return nil
      }
      let query = PFQuery(className: Event.parseClassName())
      query.whereKey("addressGeoLoc", nearGeoPoint: userGeoPoint, withinMiles: 500.00)
      query.limit = 7
      query.includeKey("user")
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


