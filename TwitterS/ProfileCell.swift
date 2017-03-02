//
//  ProfileCell.swift
//  TwitterS
//
//  Created by John Law on 2/3/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var view: TweetView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
