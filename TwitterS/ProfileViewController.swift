//
//  ProfileViewController.swift
//  TwitterS
//
//  Created by John Law on 1/3/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var user: User!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var max_id: String?
    var tweets: [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.navigationController?.isNavigationBarHidden = true;
        if user == nil {
            user = User.currentUser!
            self.navigationItem.leftBarButtonItem = nil
        }
        
        profileView.user = user
        profileView.updateView()
        
        tableView.dataSource = self
        tableView.delegate = self
        profileView.setNeedsLayout()
        profileView.layoutIfNeeded()
        profileView.frame.size = profileView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)

        refreshControlAction(UIRefreshControl())
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableHeaderView = profileView
        tableView.backgroundColor = footerView.backgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        for subview in (self.navigationController?.navigationBar.subviews)! {
            subview.removeFromSuperview()
        }
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
        TwitterClient.sharedInstance.userTimeline(id: user.id, max_id: max_id,
            success: { (tweets) in
                self.tweets = tweets
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            },
            failure: { (error) in
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            }
        )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailViewController = segue.destination as? TweetDetailViewController {
            let cell = sender as! TweetCell
            detailViewController.tweet = cell.tweet
        }
        
    }
    @IBAction func onBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        let _ = self.navigationController?.popViewController(animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let tweet = tweets![indexPath.row]
        
        cell.tweet = tweet
        cell.updateCell()

        return cell
    }
}
