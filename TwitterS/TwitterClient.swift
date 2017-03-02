//
//  TwitterClient.swift
//  TwitterS
//
//  Created by John Law on 27/2/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    //static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "2yJe5l2o2XLTpVfuiA4sHKp4L", consumerSecret: "PtxN1VSKhD8Mo9lzGI5fbHFzY4q2HZ18GEohVpNXZaTStCBDOF")!
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "nmhiqaGusZzzHB65sToh5BIyg", consumerSecret: "fk0RVOSp3uF0M3dFjO1XStaByYKJw50aqKzKjX4wu5mqXDYNlM")!
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?

    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure

        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitters://oauth"), scope: nil,
            success: { (requestToken) in
                print("Success")
            
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
                UIApplication.shared.open(url!)
            },
            failure: { (error) in
                self.loginFailure?(error!)
            }
        )
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
            success: { (task, response) in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                success(user)
            },
            failure: { (task, error) in
                failure(error)
            }
        )
    }
    
    func hometimeline(max_id: String?, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        var hometimelineUrl = "1.1/statuses/home_timeline.json"
        if max_id != nil {
            hometimelineUrl += "?max_id=\(max_id!)"
        }

        get(hometimelineUrl, parameters: nil, progress: nil,
            success: { (task, response) in
                let dictionaries = response as! [NSDictionary]

                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)

                success(tweets)
            },
            failure: { (task, error) in
                failure(error)
            }
        )
    }

    func userTimeline(id: String?, max_id: String?, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        var timelineUrl = "1.1/statuses/user_timeline.json"
        if id != nil {
            timelineUrl += "?user_id=\(id!)"
        }
        if max_id != nil {
            timelineUrl += "?max_id=\(max_id!)"
        }
        
        get(timelineUrl, parameters: nil, progress: nil,
            success: { (task, response) in
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
    
                success(tweets)
            },
            failure: { (task, error) in
                failure(error)
            }
        )
    }

    
    func retweet(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil,
            success: { (task, response) in
                success()
            },
            failure: { (task, error) in
                failure(error)
            }
        )
    }

    func unretweet(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil,
             success: { (task, response) in
                success()
            },
             failure: { (task, error) in
                failure(error)
            }
        )
    }

    func favor(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil,
             success: { (task, response) in
                success()
            },
             failure: { (task, error) in
                failure(error)
            }
        )
    }

    func unfavor(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/destroy.json?id=\(id)", parameters: nil, progress: nil,
             success: { (task, response) in
                success()
            },
             failure: { (task, error) in
                failure(error)
            }
        )
    }

    func sendTweet(text: String, id: String?, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        if var text = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            if let id = id {
                text =  text + "&in_reply_to_status_id=\(id)"
            }
            print(text)
            post("1.1/statuses/update.json?status=\(text)", parameters: nil, progress: nil,
                 success: { (task, response) in
                    success()
                },
                 failure: { (task, error) in
                    failure(error)
                }
            )
        }
        else{
            failure("cannot encode" as! Error)
            
        }
    }

    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }

    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        //let twitterClient = TwitterClient.sharedInstance
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken,
            success: { (accessToken) in
                print("Got access token")
                //self.loginSuccess?()
                
                self.currentAccount(success: { (user) in
                    User.currentUser = user
                    self.loginSuccess?()
                }, failure: { (error) in
                    self.loginFailure?(error)
                })
            },
            failure: { (error) in
                self.loginFailure?(error!)
                //print("Error: \(error?.localizedDescription)")
            }
        )
    }
}
