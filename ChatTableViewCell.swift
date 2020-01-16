//
//  ChatTableViewCell.swift
//  Instagram
//
//  Created by Antony Paul on 21/09/2019.
//  Copyright © 2019 Instagram. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var featuredImagedView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    var chat: Chat! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        titleLabel.text = chat.title
        lastMessageLabel.text = chat.lastMessage
        chat.downloadFeaturedImage { (image, error) in
            self.featuredImagedView.image = image
            self.featuredImagedView.layer.cornerRadius = self.featuredImagedView.bounds.width / 2.0
            self.featuredImagedView.layer.masksToBounds = true
        }
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}















