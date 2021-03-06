//
//  TimelineViewController.swift
//  TwitterS
//
//  Created by John Law on 27/2/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    let twitterClient = TwitterClient.sharedInstance
    var loading = false
    var max_id: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        //self.navigationController?.navigationBar.shadowImage = UIColor.black
        let navigationBar = navigationController?.navigationBar
        
        let navBorder: UIView = UIView(frame: CGRect(x: 0, y: navigationBar!.frame.size.height, width: navigationBar!.frame.size.width, height: 1))
        // Set the color you want here
        navBorder.backgroundColor = UIColor(red: 0.19, green: 0.19, blue: 0.2, alpha: 1)
        navBorder.isOpaque = true
        self.navigationController?.navigationBar.addSubview(navBorder)

        /*
        twitterClient.hometimeline(max_id: max_id,
            success: { (tweets) in
                self.tweets = tweets
                self.tableView.reloadData()
            },
            failure: { (error) in
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            }
        )
        */
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshControlAction(UIRefreshControl())
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
        twitterClient.hometimeline(max_id: nil,
            success: { (tweets) in
                self.tweets = tweets
                self.tableView.reloadData()
                refreshControl.endRefreshing()
                self.max_id = tweets[tweets.count-1].id
            },
            failure: { (error) in
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            }
        )
    }

    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        else {
            return 0
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        let tweet = tweets![indexPath.row]
    
        cell.tweet = tweet
        
        cell.updateCell()
        
        cell.selectionStyle = .none
        
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!self.loading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                self.loading = true
                twitterClient.hometimeline(max_id: max_id,
                    success: { (tweets) in
                        self.tweets?.append(contentsOf: tweets)
                        self.tableView.reloadData()
                        self.loading = false
                    },
                    failure: { (error) in
                        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default)
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true)
                    }
                )
            }
        }
        
    }    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let detailViewController = segue.destination as? TweetDetailViewController {
            let cell = sender as! TweetCell
            detailViewController.tweet = cell.tweet
            detailViewController.delegate = cell
        }
        
        if let detailNavigationViewController = segue.destination as? UINavigationController {
            if let detailViewController = detailNavigationViewController.viewControllers[0] as? NewTweetViewController {
                detailViewController.delegate = self
            }
            if let detailViewController = detailNavigationViewController.viewControllers[0] as? ProfileViewController {
                if let sender = sender as? UIButton {
                    if let cell = sender.superview?.superview as? TweetCell {
                        detailViewController.user = cell.tweet.poster
                    }
                }
                
            }
        }
    }
}

extension TimelineViewController: TweetViewControllerDelegate {
    func updateTweet(tweet: Tweet) {
    }
    
    //new tweet in time line
    func newTweet(tweet: Tweet) {
        refreshControlAction(UIRefreshControl())
    }
}
