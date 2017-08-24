//
//  DetailUserViewController.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-22.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit
import Parse

class DetailUserViewController: UIViewController {
    
    //MARK: Outlets 
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailFullName: UILabel!
    @IBOutlet weak var detailOccupationLabel: UILabel!
    @IBOutlet weak var detailPhoneLabel: UILabel!
    @IBOutlet weak var detailEmailLabel: UILabel!

    var selectedConnection: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = self.selectedConnection?["fullname"] as? String
        
        getPhotos()
        
        prettyUI()
        
        detailFullName.text = self.selectedConnection?["fullname"] as? String
        detailOccupationLabel.text = self.selectedConnection?["profession"] as? String
        detailPhoneLabel.text = self.selectedConnection?["phone"] as? String
        detailEmailLabel.text = self.selectedConnection?["emailAddr"] as? String
        
        
    }
}
//MARK: Profile Pic 

private extension DetailUserViewController {
    
    func getPhotos() {
        
        if let imageFile = selectedConnection?["profileImage"] as? PFFile {
            
            imageFile.getDataInBackground { data, error in
                
                if let error = error {
                    
                    print(#line, error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    
                    print(#line, "No Photo Retrieved")
                    return
                }
                
                self.detailImageView.image = UIImage(data: data)
            }
        }
    }
    
    func prettyUI() {
        
        self.detailImageView.layer.cornerRadius = 90
        self.detailImageView.layer.borderColor = UIColor.gray.cgColor
        self.detailImageView.layer.borderWidth = 2
        self.detailImageView.clipsToBounds = true
        
        detailFullName.layer.cornerRadius = 4
        detailFullName.layer.borderWidth = 2
        detailFullName.layer.borderColor = UIColor.gray.cgColor
        
        detailOccupationLabel.layer.cornerRadius = 4
        detailOccupationLabel.layer.borderWidth = 2
        detailOccupationLabel.layer.borderColor = UIColor.gray.cgColor
        
        detailPhoneLabel.layer.cornerRadius = 4
        detailPhoneLabel.layer.borderWidth = 2
        detailPhoneLabel.layer.borderColor = UIColor.gray.cgColor
        
        detailEmailLabel.layer.cornerRadius = 4
        detailEmailLabel.layer.borderWidth = 2
        detailEmailLabel.layer.borderColor = UIColor.gray.cgColor
    }
}
