//
//  R.swift
//  Associate
//
//  Created by Endeavour2 on 8/14/17.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import Foundation

// MARK: - Resouces

class R {
  static let eventsTableViewController = "EventsTableViewController"
  
  static func error(with message: String) -> Error {
    let error = NSError(domain: "Custom", code: 100, userInfo: ["error" : message]) as Error
    return error
  }
  
  static let eventPost = "Event"
}
