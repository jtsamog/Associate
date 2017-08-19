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
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
  
  
  //added these 3 outlets
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var professionTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!

 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prettyUI()

        // Do any additional setup after loading the view.
    }


    @IBAction func signupTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text ,
          let password = passwordTextField.text,
          let fullname = nameTextField.text,
          let emailAddr = emailTextField.text,
          let phone = phoneTextField.text,
          let profession = professionTextField.text,
          let photo = profileImageView.image
      else {
            
            //some error, display alert
            return
        }
        
      DataManager.signup(with: username,
                         andPwd: password,
                         andFname: fullname,
                         andEmail: emailAddr,
                         andPhone: phone,
                         andProf: profession,
                         andPhoto: photo
      ) { (success: Bool, error: Error?) in
            
            guard success == true else {
                return
            }
            print("User successfully created")
            self.performSegue(withIdentifier: "login", sender: nil)
        }
        
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: UI

private extension SignUpViewController {
    
    func prettyUI() {
        
        emailTextField.layer.cornerRadius = 16
        nameTextField.layer.cornerRadius = 16
        usernameTextField.layer.cornerRadius = 16
        passwordTextField.layer.cornerRadius = 16
        repasswordTextField.layer.cornerRadius = 16
        signupButton.layer.cornerRadius = 16
        cancelButton.layer.cornerRadius = 16
    }
    
    
}
