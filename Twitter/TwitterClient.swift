//
//  TwitterClient.swift
//  Twitter
//
//  Created by Keith Lee on 10/29/16.
//  Copyright © 2016 Keith Lee. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    private static let baseUrl = "https://api.twitter.com"
    var onLoginSuccess: (() -> ())!
    var onLoginFailure: ((_ error: Error?) -> ())!

    static let sharedInstance = TwitterClient(baseURL: URL(string: TwitterClient.baseUrl)!, consumerKey: "IhzZe8NUZRrSUY28KRNWAM61p", consumerSecret: "yaw3cNMEfzd6iUsZSKXrfi1yxc820SuD4xGg7IEXBxKxxTeJXE")!
    
    func login(onSuccess: @escaping () -> (), onFailure: @escaping (_ error: Error?) -> ()) {
        onLoginSuccess = onSuccess
        onLoginFailure = onFailure
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterLight://")!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            let url = URL(string: TwitterClient.baseUrl+"/oauth/authorize?oauth_token="+requestToken!.token)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }, failure: { (error: Error?) in
            self.onLoginFailure?(error)
        })
    }
    
    func handle(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)!
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accesstoken: BDBOAuth1Credential?) in
            self.current_account(completionHandler: { (user: User?, error: Error?) in
                if let user = user {
                    User.currentUser = user
                } else {
                    self.onLoginFailure(error)
                }
            })
            self.onLoginSuccess?()
        }) { (error: Error?) in
            self.onLoginFailure?(error)
        }
    }

    func current_account(completionHandler: @escaping (_ user: User?, _ error: Error?) -> ()) {
        TwitterClient.sharedInstance.get("https://api.twitter.com/1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            completionHandler(User(dictionary: response as! NSDictionary), nil)
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            completionHandler(nil, error)
        })
    }
}
