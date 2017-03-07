//
//  TweetViewControllerDelegate.swift
//  TwitterS
//
//  Created by John Law on 2/3/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

protocol TweetViewControllerDelegate: class {
    func updateTweet(tweet: Tweet)
    func newTweet(tweet: Tweet)
}
