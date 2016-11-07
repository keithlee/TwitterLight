//
//  MenuCell.swift
//  Twitter
//
//  Created by Keith Lee on 11/4/16.
//  Copyright © 2016 Keith Lee. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    var viewController: UIViewController! {
        didSet {
            titleLabel.text = viewController.title
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
