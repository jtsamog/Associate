//
//  ProfileViewController.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-11.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
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
        
        niceUI()
        
       
    }
    
    
    @IBAction func editTapped(_ sender: Any) {
        
        self.title = "Edit Mode"
        
        editButton.isHidden = true
        displayStack.isHidden = true
        profilePicImageView.isHidden = true
        
        editingImageView.image = userProfile?.photo
        nameTextField.text = userProfile?.fullname
        occupationTextField.text = userProfile?.profession
        emailTextField.text = userProfile?.emailAddr
        phoneTextField.text = userProfile?.phone
        
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        self.title = "Profile"
        
        editButton.isHidden = false
        displayStack.isHidden = false
        profilePicImageView.isHidden = false
        
        //Setting updated values
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
