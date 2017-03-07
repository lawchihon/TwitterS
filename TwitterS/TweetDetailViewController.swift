//
//  TweetDetailViewController.swift
//  TwitterS
//
//  Created by John Law on 28/2/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController  {

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
    var replies: [Tweet]?
    let twitterClient = TwitterClient.sharedInstance

    @IBOutlet var tableView: UITableView!
    weak var delegate: TweetViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        //self.navigationController?.navigationBar.
        //self.navigationController?.navigationBar.shadowImage = UIColor.black
        let navigationBar = navigationController?.navigationBar
        
        let navBorder: UIView = UIView(frame: CGRect(x: 0, y: navigationBar!.frame.size.height, width: navigationBar!.frame.size.width, height: 1))
        // Set the color you want here
        navBorder.backgroundColor = UIColor(red: 0.19, green: 0.19, blue: 0.2, alpha: 1)
        navBorder.isOpaque = true
        self.navigationController?.navigationBar.addSubview(navBorder)
        updateTweet()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension

        tweetView.setNeedsLayout()
        tweetView.layoutIfNeeded()
        tweetView.frame.size = tweetView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        tableView.tableHeaderView = tweetView
        tableView.tableFooterView = footerView

        //tableView.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.00)
        
        //footerView.frame.origin.y = 100
        //footerView.setNeedsLayout()
        //footerView.layoutIfNeeded()
        //footerView.frame.size = footerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        //replyView.text = "@lawchihon"
        
        refreshControlAction(UIRefreshControl())
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
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
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        // ... Create the URLRequest `myRequest` ...
        TwitterClient.sharedInstance.replyTweets(id: (tweet.poster?.id)!, reply_id: tweet.id!, max_id: nil,
            success: { (replies) in
                self.replies = replies
                self.tableView.reloadData()
                refreshControl.endRefreshing()
                
                print(replies.count)
            },
            failure: { (error) in
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            }
        )
    }

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
        self.delegate?.updateTweet(tweet: tweet)
        let _ = self.navigationController?.popViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailNavigationViewController = segue.destination as? UINavigationController {
            if let detailViewController = detailNavigationViewController.viewControllers[0] as? NewTweetViewController {
                detailViewController.tweet = self.tweet
            }
            if let detailViewController = detailNavigationViewController.viewControllers[0] as? ProfileViewController {
                detailViewController.user = tweet.poster
            }
        }
        
    }
    
    func adjustSizeForReplyView(replyTextView: UIView) {
        let fixedWidth = replyTextView.frame.size.width
        replyTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = replyTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = replyTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        replyTextView.frame = newFrame;
    }
}


extension TweetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let replies = replies {
            return replies.count
        }
        return 0
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as! TweetCell
        cell.tweet = replies?[indexPath.row]
        cell.updateCell()
        return cell
    }

}
