//
//  EventMessage.swift
//  Associate
//
//  Created by Endeavour2 on 8/18/17.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit
import Parse

class EventMessage: PFObject {
  
  // MARK: - Properties
  @NSManaged var msgText: String?
  @NSManaged var creator: EventUser?
    @NSManaged var event: Event
  

  
  // MARK: - Initializers
    init(msgText: String?, creator: EventUser?, event: Event) {
    super.init()

    self.msgText = msgText
    self.creator = creator
    self.event = event

  }
  
  
  
  
  override init() {
    super.init()
  }
  
  //MARK: - Overriden
  //  override class func query() -> PFQuery<PFObject>? {
  //    let query = PFQuery(className: EventMessage.parseClassName())
  //    query.includeKey("user")
  //    query.order(byDescending: "createdAt")
  //    return query
  //  }
  
//  override class func query()-> PFQuery<PFObject>? {
//    guard let userGeoPoint = EventUser.current()?.userCurrentLoc else {
//      print("User location not available")
//      return nil
//    }
//    let query = PFQuery(className: Event.parseClassName())
//    query.whereKey("addressGeoLoc", nearGeoPoint: userGeoPoint, withinMiles: 500.00)
//    query.limit = 7
//    query.includeKey("user")
//    return query
//  }
//  
//}

}
  
//MARK: - PFSubclassing
extension EventMessage: PFSubclassing {
  // required protocol method
  static func parseClassName() -> String {
    return "EventMessage"
  }

}
