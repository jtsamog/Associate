//
//  EventUser.swift
//  Associate
//
//  Created by Endeavour2 on 8/15/17.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit
import Parse

final class EventUser: PFUser {
  
  //MARK: - Properties
  @NSManaged var userCurrentLoc: PFGeoPoint?
  // We need to add other properties required for the user profile
  // username already exist in PFUser
  // password already exist in PFUser
  // email already exist in PFUser
  @NSManaged var firstname: String?
  @NSManaged var lastname: String?
  @NSManaged var phone: String?
  @NSManaged var profileImage: PFFile?
  var photo : UIImage?
		
  
  
  
  //MARK: - Initializers
  init(userCurrentLoc: PFGeoPoint) {
    super.init()
    
    self.userCurrentLoc = userCurrentLoc
  
  }
  
  override init() {
    super.init()
  }
  
  
  //MARK: - Query user location
  override class func query() -> PFQuery<PFObject>? {
    let query = PFQuery(className: EventUser.parseClassName())
    query.includeKey("userCurrentLoc")
    return query
  }

}


  

