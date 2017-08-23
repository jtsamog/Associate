//
//  NewEventViewController.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-14.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit
import Parse

class NewEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: Outlets

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextField: UITextField!
    @IBOutlet weak var eventAddressTextField: UITextField!
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    

  
    //MARK: Properties
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        prettyUI()
        
        textFieldSetUp()
    }
    
    //MARK: UIImagePicker

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        eventAddressTextField.resignFirstResponder()
        eventDescriptionTextField.resignFirstResponder()
        eventTitleTextField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        
        print("Tapped")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            
            fatalError("Didnt get photo")
        }
        
        eventImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            
            print("Dismissed")
        }
    }

  
    @IBAction func addTapped(_ sender: UIButton) {
        
        guard let uploadImage = eventImageView.image, let pictureData = UIImagePNGRepresentation(uploadImage), let file = PFFile(name: "image", data: pictureData ) else {
         return
            
        }
        
        file.saveInBackground( { [unowned self] succeeded, error in
            
            guard succeeded == true else {
                
                print("\(String(describing: error))")
                return
            }
            
            self.saveEvent(file)
            }, progressBlock: { percent in
                print("Upload: \(percent)%")
                
        })
    }
}


//MARK: Extensions 

private extension NewEventViewController {
    
    func saveEvent(_ file: PFFile) {
        
      guard let currentUser = PFUser.current() else {
            print("Not current user")
            return
        }
      guard let loc = EventUser.current()?.userCurrentLoc else {
        print("User location not available")
        return
      }
      
      
        let newEvent = Event(title: eventTitleTextField.text, image: file, user: currentUser, descrip: eventDescriptionTextField.text, addressGeoLoc: loc, address: eventAddressTextField.text)
      
        newEvent.saveInBackground { [unowned self] succeeded, error in
            
            if succeeded {
                
                self.dismiss(animated: true, completion: nil)
            }
                
            else if let error = error {
                
                print("\(error)Problem saving newEvent")
            }
            
        }
    }
    
    func prettyUI() {
        
        addButton.layer.cornerRadius = 4
        cancelButton.layer.cornerRadius = 4
    }
    
    func textFieldSetUp () {
        
        eventTitleTextField.delegate = self
        eventDescriptionTextField.delegate = self
        eventAddressTextField.delegate = self
        
        eventTitleTextField.autocorrectionType = .no
        eventDescriptionTextField.autocorrectionType = .no
        eventAddressTextField.autocorrectionType = .no
    }
    
}
