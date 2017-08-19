//
//  DataManager.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-10.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import Foundation
import Parse

class DataManager  {
    
    //This is a comment to test stuff
    
  
    //MARK: Login
    static func login(with userName: String, and password: String, completion:@escaping (Bool, Error?)-> Void) {
        PFUser.logInWithUsername(inBackground: userName, password: password) { user, error in
            guard let _ = user else {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }

    
    //MARK: SignUp
//    static func signup(with userName: String, and password: String, completion: @escaping (Bool, Error?)-> Void) {
//        let user = PFUser()
//        user.username = userName
//        user.password = password
//        user.signUpInBackground { success, error in
//            completion(success, error)
//        }
//    }

    
  static func signup(with userName: String,
                     andPwd password: String,
                     andFname fullname: String,
                     andEmail emailAddr: String,
                     andPhone phone: String,
                     andProf profession: String,
                     andPhoto photo: UIImage,
                     completion: @escaping (Bool, Error?)-> Void) {
        
        //get user current location
        PFGeoPoint.geoPointForCurrentLocation() {(geopoint: PFGeoPoint?, error: Error?) -> Void in
            if let error = error {
                print(#line, error)
                return
            }
          let user = EventUser(userCurrentLoc:geopoint)
          
            user.username = userName
            user.password = password
            user.fullname = fullname
            user.emailAddr = emailAddr
            user.phone = phone
            user.profession = profession
            user.photo = photo
            user.signUpInBackground { success, error in
                completion(success, error)
            }
        }
    }
    
    
}
