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
    static func signup(with userName: String, and password: String, completion: @escaping (Bool, Error?)-> Void) {
        let user = PFUser()
        user.username = userName
        user.password = password
        user.signUpInBackground { success, error in
            completion(success, error)
        }
    }

    
    
}
