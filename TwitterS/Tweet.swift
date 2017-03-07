//
//  Tweet.swift
//  TwitterS
//
//  Created by John Law on 27/2/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favorCount: Int = 0
    var poster: User?
    var id: String?
    var retweeted: Bool = false
    var favorited: Bool = false
    var reply_id: String?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        let timestampString = dictionary["created_at"] as? String
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM d HH:mm:ss Z y"
        if let timestampString = timestampString {
            timestamp = formatter.date(from: timestampString)
        }
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favorCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let posterDictionary = dictionary["user"] as? NSDictionary
        if let posterDictionary = posterDictionary {
            poster = User(dictionary: posterDictionary)
        }
        
        id = dictionary["id_str"] as? String
        retweeted = dictionary["retweeted"] as! Bool
        favorited = dictionary["favorited"] as! Bool
        reply_id = dictionary["in_reply_to_status_id_str"] as? String
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }
}
