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
    @NSManaged var fullname: String?
    @NSManaged var emailAddr: String?
    @NSManaged var phone: String?
    @NSManaged var profession: String?
    @NSManaged var profileImage: PFFile?
    var photo : UIImage?
  // We need to add other properties required for the user profile
  // username already exist in PFUser
  // password already exist in PFUser
  // email already exist in PFUser
		
  
  
  
  //MARK: - Initializers
  init(
    userCurrentLoc: PFGeoPoint?,
    fullname: String? = nil,
    emailAddr: String? = nil,
    phone: String? = nil,
    profession: String? = nil,
    photo: UIImage? = nil
    
      ) {
    
    super.init()
    
    self.userCurrentLoc = userCurrentLoc
    self.fullname = fullname
    self.emailAddr = emailAddr
    self.phone = phone
    self.profession = profession
    self.photo = photo
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


  

