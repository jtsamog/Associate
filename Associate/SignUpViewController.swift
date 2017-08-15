//
//  SignUpViewController.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-10.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    
    //MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func signupTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            
            //some error, display alert
            return
        }
        
        DataManager.signup(with: username, and: password) { (success: Bool, error: Error?) in
            
            guard success == true else {
                
                
                return
            }
                
        }
        
    }

}
