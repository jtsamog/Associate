//
//  LoginViewController.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-10.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: Properties
    let warningAlert = UIAlertController(title: "Invalid", message: "Username or password is invalid. Please try again.", preferredStyle: .alert)
    let okAlert = UIAlertAction(title: "OK", style: .default, handler: nil)
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningAlert.addAction(okAlert)
        
        guard let user = PFUser.current(), user.isAuthenticated else {
            
            print ("Not current user")
            return
        }
        self.performSegue(withIdentifier: "login", sender: nil)
    }


    @IBAction func loginTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            
            //someProblem
            
            return
        }
        
        DataManager.login(with: username, and: password) { (success: Bool, error: Error?) in
            
            guard error == nil, success == true else {
                
                self.present(self.warningAlert, animated: true, completion: nil)
                print(#line, "not logged in")
                return
                
            }
            print("Successfully Logged In")
            self.performSegue(withIdentifier: "login", sender: nil)
        }
    }
}
