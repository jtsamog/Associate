//
//  NewEventTableViewCell.swift
//  Associate
//
//  Created by Alex Wymer  on 2017-08-11.
//  Copyright © 2017 Sav Inc. All rights reserved.
//

import UIKit

class NewEventTableViewCell: UITableViewCell {
    
    
    //MARK: Outlets
    
    @IBOutlet weak var createEventLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: Actions 
    
    @IBAction func addEventTapped(_ sender: UIButton) {
        
        
        
    }
    
    
}
