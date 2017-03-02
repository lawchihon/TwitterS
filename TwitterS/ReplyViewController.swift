//
//  ReplyViewController.swift
//  TwitterS
//
//  Created by John Law on 1/3/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit
import AFNetworking

class ReplyViewController: UIViewController {

    @IBOutlet var replyToLabel: UILabel!
    @IBOutlet var replyTextView: UITextView!

    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = User.currentUser?.profileUrl
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch

        //create a new button
        let profileButton = UIButton()
        profileButton.setImage(UIImage(data: data!), for: UIControlState.normal)
        profileButton.layer.cornerRadius = 5
        profileButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileButton)
        
        
        let tweetButton = UIButton()
        tweetButton.setTitle("Tweet", for: .normal)
        tweetButton.setTitleColor(UIColor.white, for: .normal)
        tweetButton.backgroundColor = UIColor(red: 29/255.0, green: 141/255.0, blue: 238/255.0, alpha: 1.00)
        tweetButton.frame = CGRect(x: 0, y: 0, width: 70, height: 25)
        tweetButton.layer.cornerRadius = 5
        tweetButton.addTarget(self, action: #selector(postTweet(_:)), for: .touchUpInside)
        
        let tweetToolbar = UIToolbar(frame: CGRect())
        tweetToolbar.barStyle = UIBarStyle.default
        tweetToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: tweetButton)
        ]
        tweetToolbar.sizeToFit()
        replyTextView.inputAccessoryView = tweetToolbar
        
        replyTextView.text = "@\((tweet.poster?.screenname)!) "
        replyToLabel.text = "In reply to \((tweet.poster?.name)!)"
        
        replyTextView.becomeFirstResponder()
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
    @IBAction func onCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func postTweet(_ sender: UIButton) {
        
        TwitterClient.sharedInstance.sendTweet(text: replyTextView.text, id: tweet.id,
            success: {
                //print("Updated")
                self.dismiss(animated: true, completion: nil)
            },
            failure: { (error) in
                print("\(error.localizedDescription)")
            }
        )
    }
}
