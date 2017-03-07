//
//  TweetView.swift
//  TwitterS
//
//  Created by John Law on 2/3/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

class TweetView: UIView {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterNameLabel: UILabel!
    @IBOutlet weak var posterScreennameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favorCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favorButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var tweet: Tweet!
    let twitterClient = TwitterClient.sharedInstance

    func updateView() {
        let posterImageUrl = tweet.poster?.profileUrl
        if let posterImageUrl = posterImageUrl {
            self.posterImageView.setImageWith(posterImageUrl)
        }
        
        self.posterNameLabel.text = tweet.poster?.name
        self.posterScreennameLabel.text = "@\((tweet.poster?.screenname)!)"
        
        self.contentLabel.text = tweet.text
        
        if tweet.favorCount > 0 {
            self.favorCountLabel.text = "\(tweet.favorCount)"
        }
        else {
            self.favorCountLabel.text = ""
        }
        
        if tweet.favorited {
            favorButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
        }
        else {
            favorButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
        }
        
        if tweet.retweetCount > 0 {
            self.retweetCountLabel.text = "\(tweet.retweetCount)"
        }
        else {
            self.retweetCountLabel.text = ""
        }
        
        if tweet.retweeted {
            retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
        }
        else {
            retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
        }
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        if (tweet.retweeted) {
            twitterClient.unretweet(id: tweet.id!,
                success: {
                    self.tweet.retweeted = false
                    self.tweet.retweetCount -= 1
                    self.updateView()
                },
                failure: { (error) in
                    print("\(error.localizedDescription)")
                }
            )
        }
        else {
            twitterClient.retweet(id: tweet.id!,
                success: {
                    self.tweet.retweeted = true
                    self.tweet.retweetCount += 1
                    self.updateView()
                },
                failure: { (error) in
                    print("\(error.localizedDescription)")
                }
            )
        }
    }
    
    
    /*
    @IBAction func onFavorButton(_ sender: Any) {
        if (tweet.favorited) {
            twitterClient.unfavor(id: tweet.id!,
                success: {
                    self.tweet.favorited = false
                    self.tweet.favorCount -= 1
                    self.updateView()
                },
                failure: { (error) in
                    print("\(error.localizedDescription)")
                }
            )
        }
        else {
            twitterClient.favor(id: tweet.id!,
                success: {
                    self.tweet.favorited = true
                    self.tweet.favorCount += 1
                    self.updateView()
                },
                failure: { (error) in
                    print("\(error.localizedDescription)")
                }
            )
        }
    }
    */

}
