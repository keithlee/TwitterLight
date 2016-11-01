//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Keith Lee on 10/31/16.
//  Copyright © 2016 Keith Lee. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            if let profileImageUrl = tweet?.user?.profileImageUrl {
                profilePictureView.setImageWith(URL(string: profileImageUrl)!)
            }
            nameLabel.text = tweet?.user?.name
            screenNameLabel.text = tweet?.user?.screenName
            tweetLabel.text = tweet?.text
            timestampLabel.text = tweet?.createdAt
        }
    }

    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
