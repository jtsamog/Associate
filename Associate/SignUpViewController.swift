//
//  SignUpViewController.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-10.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    //MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
  
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    var profilePageShowing = false
    
    
  
  //added these 3 outlets
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var professionTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!

 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prettyUI()
        
        textFieldSetUp()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repasswordTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        professionTextField.resignFirstResponder()
        return true
    }
    
    //MARK: Actions 
    
    @IBAction func nextTapped(_ sender: UIButton) {
        
        if (profilePageShowing) {
            trailingConstraint.constant = -400
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            trailingConstraint.constant = -16
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        profilePageShowing = !profilePageShowing
    }
    
    @IBAction func goBackTapped(_ sender: UIButton) {
        
        if (profilePageShowing) {
            trailingConstraint.constant = -400
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            trailingConstraint.constant = -16
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        profilePageShowing = !profilePageShowing
}

    
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        
        print("Profile Pic Tapped")
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedPic = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            
            fatalError("Didnt get photo")
        }
        
        profileImageView.image = selectedPic
        dismiss(animated: true, completion: nil)
    }


    @IBAction func signupTapped(_ sender: UIButton) {
        
        guard let uploadPhoto = profileImageView.image, let pictureData = UIImagePNGRepresentation(uploadPhoto), let file = PFFile(name: "profilePic", data: pictureData) else {
            
            print("Error converting image to data")
            return
        }

        
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
                         andPhoto: photo,
                         andProfilePic: file
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
        
        backButton.layer.cornerRadius = 4
        nextButton.layer.cornerRadius = 4
        signupButton.layer.cornerRadius = 4
        cancelButton.layer.cornerRadius = 4
    }
    
    func textFieldSetUp() {
        
        emailTextField.delegate = self
        nameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        repasswordTextField.delegate = self
        phoneTextField.delegate = self
        professionTextField.delegate = self
        
        emailTextField.autocorrectionType = .no
        nameTextField.autocorrectionType = .no
        usernameTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        repasswordTextField.autocorrectionType = .no
        phoneTextField.autocorrectionType = .no
        professionTextField.autocorrectionType = .no
    
    }
}
