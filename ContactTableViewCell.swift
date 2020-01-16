//
//  ContactTableViewCell.swift
//  Instagram
//
//  Created by Antony Paul on 21/09/2019.
//  Copyright © 2019 Instagram. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var emailTextLabel: UILabel!
    
    var user: User! {
        didSet {
            self.updateUI()
        }
    }
    //changing checkBox
    var added: Bool = false {
        didSet {
            if added == false {
                checkboxImageView.image = UIImage(named: "icon-checkbox")
            } else {
                checkboxImageView.image = UIImage(named: "icon-checkbo-filled")
            }
        }
        
    }
  func updateUI()
  {
    user.downloadProfilePicture { (image, error) in
        self.profileImageView.image = image
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width / 2.0
        self.profileImageView.layer.masksToBounds = true
        
    }
    displayNameLabel.text = user.username
    checkboxImageView.image = UIImage(named: "icon-checkbox")
    emailTextLabel.text = user.fullName
    }
}
