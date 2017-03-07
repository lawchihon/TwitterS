//
//  swift
//  TwitterS
//
//  Created by John Law on 1/3/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var user: User!

    func updateView() {
        if let profileUrl = user.profileUrl {
            profileImageView.setImageWith(profileUrl)
        }
        
        if let backgroundUrl = user.backgroundUrl {
            backgroundImageView.setImageWith(backgroundUrl)
        }
        
        nameLabel.text = user.name
        screennameLabel.text = "@\(user.screenname!)"
        followerCountLabel.text = "\(user.followerCount!)"
        followingCountLabel.text = "\(user.followingCount!)"
        descriptionLabel.text = user.tagline
    }

}
