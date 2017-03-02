//
//  TweetDetailViewController.swift
//  TwitterS
//
//  Created by John Law on 28/2/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tweetView: UIView!
    @IBOutlet weak var footerView: UIView!
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

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateTweet()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension

        tweetView.setNeedsLayout()
        tweetView.layoutIfNeeded()
        tweetView.frame.size = tweetView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        tableView.tableHeaderView = tweetView
        
        tableView.backgroundColor = footerView.backgroundColor
        tableView.tableFooterView = footerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateTweet() {
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
            self.favorCount.text = "0"
        }
        
        if tweet.favorited {
            favorButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
        }
        else {
            favorButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
        }
        
        if tweet.retweetCount > 0 {
            self.retweetCount.text = "\(tweet.retweetCount)"
        }
        else {
            self.retweetCount.text = "0 "
        }
        
        if tweet.retweeted {
            retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
        }
        else {
            retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath)
        return cell
    }

    @IBAction func onRetweetButton(_ sender: Any) {
        if (tweet.retweeted) {
            twitterClient.unretweet(id: tweet.id!,
                success: {
                    self.tweet.retweeted = false
                    self.tweet.retweetCount -= 1
                    self.updateTweet()
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
                    self.updateTweet()
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
                    self.updateTweet()
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
                    self.updateTweet()
                },
                failure: { (error) in
                    print("\(error.localizedDescription)")
                }
            )
        }
    }

    @IBAction func onReplyButton(_ sender: Any) {
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "ReplyNavigation") as! UINavigationController
        
        //self.present(vc, animated: true, completion: nil)
        
        /*
        window?.rootViewController = vc
        if let replyNVC = storyboard.instantiateViewController(withIdentifier: StorybordIdentifier.ReplyNavigationViewControllerIden) as? ReplyNavigationViewController{
            if let replyVC = replyNVC.viewControllers.first as? ReplyViewController{
                replyVC.tweetToReply = self.tweet
                self.present(replyNVC, animated: true, completion: nil)
            }
        }
         */
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailNavigationViewController = segue.destination as? UINavigationController {
            if let detailViewController = detailNavigationViewController.viewControllers[0] as? NewTweetViewController {
                detailViewController.tweet = self.tweet
            }
        }
        
    }

    
}
