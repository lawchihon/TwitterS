//
//  NewTweetViewController.swift
//  TwitterS
//
//  Created by John Law on 1/3/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet var replyToLabel: UILabel!
    @IBOutlet var replyTextView: UITextView!
    @IBOutlet var placeHolderLabel: UILabel!

    var tweet: Tweet?
    var count = 140
    weak var delegate: TweetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        let url = User.currentUser?.profileUrl
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
        //create a new button
        let profileButton = UIButton()
        profileButton.setImage(UIImage(data: data!), for: UIControlState.normal)
        profileButton.layer.cornerRadius = 5
        profileButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileButton)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        if let tweet = tweet {
            replyTextView.text = "@\((tweet.poster?.screenname)!) "
            replyToLabel.text = "In reply to \((tweet.poster?.name)!)"
            self.placeHolderLabel.isHidden = true
        }
        else {
            replyTextView.text = ""
            replyToLabel.text = ""
            replyToLabel.isHidden = true
            self.placeHolderLabel.isHidden = false
        }
        replyTextView.delegate = self
        replyTextView.becomeFirstResponder()

        
        let tweetButton = UIButton()
        tweetButton.setTitle("Tweet", for: .normal)
        tweetButton.frame = CGRect(x: 0, y: 0, width: 70, height: 25)
        tweetButton.layer.cornerRadius = 5
        tweetButton.addTarget(self, action: #selector(postTweet(_:)), for: .touchUpInside)
        
        let tweetToolbar = UIToolbar(frame: CGRect())
        tweetToolbar.barStyle = UIBarStyle.default
        tweetToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "", style: .plain, target: nil, action: nil),
            UIBarButtonItem(customView: tweetButton)
        ]
        tweetToolbar.backgroundColor = UIColor.white
        tweetToolbar.sizeToFit()
        replyTextView.inputAccessoryView = tweetToolbar

        updateToolBar()
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
        
        TwitterClient.sharedInstance.sendTweet(text: replyTextView.text, id: tweet?.id,
            success: { (tweet) in
                self.delegate?.newTweet(tweet: tweet)
                self.exitReply()
            },
            failure: { (error) in
                print("\(error.localizedDescription)")
            }
        )
    }
    
    func exitReply() {
        print("HERE?")
        self.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateToolBar() {
        let tweetToolbar = replyTextView.inputAccessoryView as! UIToolbar
        let textCount = replyTextView.text.characters.count
        let textLimit = count - textCount
        tweetToolbar.items?[1].title = "\(textLimit)"
        tweetToolbar.items?[1].tintColor = UIColor.gray
        

        if textCount == 0 {
            tweetToolbar.items?[2].isEnabled = false
            setInvalidTweetButton(tweetButton: tweetToolbar.items?[2].customView as! UIButton)
        }
        else {
            tweetToolbar.items?[2].isEnabled = true
            setValidTweetButton(tweetButton: tweetToolbar.items?[2].customView as! UIButton)
        }

        if textLimit < 20 {
            tweetToolbar.items?[1].tintColor = UIColor.red
            if textLimit < 0 {
                tweetToolbar.items?[2].isEnabled = false
                setInvalidTweetButton(tweetButton: tweetToolbar.items?[2].customView as! UIButton)
            }
        }
    }
    
    func setValidTweetButton(tweetButton: UIButton) {
        tweetButton.setTitleColor(UIColor.white, for: .normal)
        tweetButton.layer.borderWidth = 0
        tweetButton.backgroundColor = UIColor(red: 29/255.0, green: 141/255.0, blue: 238/255.0, alpha: 1.00)
    }
    
    func setInvalidTweetButton(tweetButton: UIButton) {
        tweetButton.backgroundColor = UIColor.white
        tweetButton.layer.borderWidth = 1
        tweetButton.layer.borderColor = UIColor.lightGray.cgColor
        tweetButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
}



extension NewTweetViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateToolBar()
        if self.replyTextView.hasText {
            self.placeHolderLabel.isHidden = true
        }
        else {
            self.placeHolderLabel.isHidden = false
        }
    }
}
