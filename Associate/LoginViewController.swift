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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func loginTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            
            //someProblem
            
            return
        }
        
        DataManager.login(with: username, and: password) { (success: Bool, error: Error?) in
            
            guard error == nil, success == true else {
                
                print(#line, "not logged in")
                return
                
            }
            
            
        }
    }
}
