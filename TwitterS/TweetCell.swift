//
//  TweetCell.swift
//  TwitterS
//
//  Created by John Law on 27/2/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var posterScreenname: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favorCount: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favorButton: UIButton!

    var tweet: Tweet!
    
    let twitterClient = TwitterClient.sharedInstance

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell() {
        let posterImageUrl = tweet.poster?.profileUrl
        if let posterImageUrl = posterImageUrl {
            self.posterImage.setImageWith(posterImageUrl)
        }
        
        self.posterName.text = tweet.poster?.name
        self.posterScreenname.text = "@\((tweet.poster?.screenname)!)"
        
        self.content.text = tweet.text
        
        if tweet.favorCount > 0 {
            self.favorCount.text = "\(tweet.favorCount)"
        }
        else {
            self.favorCount.text = ""
        }
        
        if tweet.favorited {
            retweetButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            print("IN")
        }
        else {
            retweetButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
        }
        
        if tweet.retweetCount > 0 {
            self.retweetCount.text = "\(tweet.retweetCount)"
        }
        else {
            self.retweetCount.text = ""
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
                    self.updateCell()
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
                    self.updateCell()
                },
                failure: { (error) in
                    print("\(error.localizedDescription)")
                }
            )
        }
    }
    
    
    @IBAction func onFavorButton(_ sender: Any) {
        if (tweet.favorited) {
            twitterClient.unfavor(id: tweet.id!,
                success: {
                    self.tweet.favorited = false
                    self.tweet.favorCount -= 1
                    self.updateCell()
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
                    self.updateCell()
                },
                failure: { (error) in
                    print("\(error.localizedDescription)")
                }
            )
        }
    }
}
