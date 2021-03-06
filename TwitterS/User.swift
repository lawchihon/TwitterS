//
//  User.swift
//  TwitterS
//
//  Created by John Law on 27/2/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    var backgroundUrl: URL?
    var dictionary: NSDictionary?
    var followingCount: Int?
    var followerCount: Int?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary

        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        if let backgroundUrlString = dictionary["profile_background_image_url_https"] as? String {
            backgroundUrl = URL(string: backgroundUrlString)
        }
        
        followingCount = dictionary["friends_count"] as? Int
        followerCount = dictionary["followers_count"] as? Int
        id = dictionary["id_str"] as? String
        tagline = dictionary["description"] as? String
    }
    
    static let userDidLogoutNotification = "UserDidLogout"

    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                
                let userData = defaults.object(forKey: "currentUser") as? Data

                if let userData = userData {
                    
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: [])
                    
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user

            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUser")
            }
            else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
