//
//  ProfileViewController.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-11.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    //MARK: Outlets
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileOccupationLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    @IBOutlet weak var profileNumberLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    //Editing
    @IBOutlet weak var editingStack: UIStackView!
    @IBOutlet weak var editingImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    //Display
    @IBOutlet weak var displayStack: UIStackView!
    
    
    var userProfile = EventUser.current()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        getPic()
        
        setValues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "Profile"
        
        nameTextField.delegate = self
        occupationTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self

        
        niceUI()
        
        editingStack.isHidden = true
        editingImageView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameTextField.resignFirstResponder()
        occupationTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        
        return true
    }
    
    //MARK: Actions
    
    
    
    
    @IBAction func editTapped(_ sender: Any) {
        
        self.title = "Edit Mode"
        
        editingStack.isHidden = false
        editingImageView.isHidden = false
        
        editButton.isHidden = true
        displayStack.isHidden = true
        profilePicImageView.isHidden = true
        
        editingImageView.image = userProfile?.photo
        nameTextField.text = userProfile?.fullname
        occupationTextField.text = userProfile?.profession
        emailTextField.text = userProfile?.emailAddr
        phoneTextField.text = userProfile?.phone
    }
    
    @IBAction func editImageTapped(_ sender: UITapGestureRecognizer) {
        
        print("Edit Image Tapped")
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedEditPic = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            
            fatalError("Wasnt able to get new photo")
        }
        
        editingImageView.image = selectedEditPic
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        self.title = "Profile"
        
        //Hiding Views
        editButton.isHidden = false
        displayStack.isHidden = false
        profilePicImageView.isHidden = false
        
        editingImageView.isHidden = true
        editingStack.isHidden = true
        
        
        //Converting image to pffile 
        guard let uploadPhoto = editingImageView.image, let pictureData = UIImagePNGRepresentation(uploadPhoto), let file = PFFile(name: "newProfilePic", data: pictureData) else {
            
            
            print("Error converting image to data")
            return
        }
        
        //Setting updated values
        userProfile?.profileImage = file
        userProfile?.photo = editingImageView.image
        userProfile?.fullname = nameTextField.text
        userProfile?.profession = occupationTextField.text
        userProfile?.emailAddr = emailTextField.text
        userProfile?.phone = phoneTextField.text
        
        userProfile?.saveInBackground()
        
        setValues()
        
    }
}

//MARK: Picture Pull

private extension ProfileViewController {
    
    
    func setValues() {
        
        profilePicImageView.image = userProfile?.photo
        profileNameLabel.text = userProfile?.fullname
        profileOccupationLabel.text = userProfile?.profession
        profileEmailLabel.text = userProfile?.emailAddr
        profileNumberLabel.text = userProfile?.phone
    }
    
    func  niceUI() {
        
        profilePicImageView.layer.cornerRadius = 16
        profilePicImageView.clipsToBounds = true
        
        profileNumberLabel.layer.cornerRadius = 16
        profileNumberLabel.clipsToBounds = true
        
        profileNameLabel.layer.cornerRadius = 16
        profileNameLabel.clipsToBounds = true
        
        profileOccupationLabel.layer.cornerRadius = 16
        profileOccupationLabel.clipsToBounds = true
        
        profileEmailLabel.layer.cornerRadius = 16
        profileEmailLabel.clipsToBounds = true
        
        editButton.layer.cornerRadius = 16
        saveButton.layer.cornerRadius = 16
        
        editingImageView.layer.cornerRadius = 16
        editingImageView.layer.borderColor = UIColor.orange.cgColor
        editingImageView.layer.borderWidth = 5
        editingImageView.clipsToBounds = true
        
        nameTextField.layer.borderWidth = 5
        nameTextField.layer.borderColor = UIColor.orange.cgColor
        
        occupationTextField.layer.borderWidth = 5
        occupationTextField.layer.borderColor = UIColor.orange.cgColor

        
        emailTextField.layer.borderWidth = 5
        emailTextField.layer.borderColor = UIColor.orange.cgColor

        phoneTextField.layer.borderWidth = 5
        phoneTextField.layer.borderColor = UIColor.orange.cgColor
    }

    func getPic() {
        
        userProfile?.profileImage?.getDataInBackground { [unowned self] data, error in
            
            if let error = error {
                
                print(#line, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                
                print(#line, "No photo to retrieve")
                return
            }
            
            self.userProfile?.photo = UIImage(data: data)
            self.profilePicImageView.image = self.userProfile?.photo

        }
    }
}
