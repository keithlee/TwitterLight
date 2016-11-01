//
//  User.swift
//  Twitter
//
//  Created by Keith Lee on 10/30/16.
//  Copyright © 2016 Keith Lee. All rights reserved.
//

import Foundation

private let kName = "name"
private let kProfileImage = "profileImageUrl"
private let kScreenName = "screenName"

class User: NSObject, NSCoding {
    var name: String!
    var profileImageUrl: String!
    var screenName: String!
    
    static var _currentUser: User?
    
    static let kUser = "currentUser"

    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        screenName = "@\((dictionary["screen_name"] as! String))"
    }
    
    class var currentUser: User? {
        get {
            let userDefaults = UserDefaults.standard
            if let userData = userDefaults.object(forKey: kUser) {
                let user = NSKeyedUnarchiver.unarchiveObject(with: userData as! Data) as! User
                return user
            } else {
                return nil
            }
        }
        set {
            _currentUser = newValue
            let userDefaults = UserDefaults.standard
            if let _currentUser = _currentUser {
                let userData = NSKeyedArchiver.archivedData(withRootObject: _currentUser)
                userDefaults.set(userData, forKey: kUser)
            } else {
               userDefaults.removeObject(forKey: kUser)
            }
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: kName)
        aCoder.encode(profileImageUrl, forKey: kProfileImage)
        aCoder.encode(screenName, forKey: kScreenName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: kName) as! String!
        profileImageUrl = aDecoder.decodeObject(forKey: kProfileImage) as! String!
        screenName = aDecoder.decodeObject(forKey: kScreenName) as! String!
    }
    
    
    func homeTimeline(completionHandler: @escaping (_ tweets: [Tweet]?, _ error: Error?) -> ()){
        TwitterClient.sharedInstance.get("https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsAsArray(dictionaryArray: dictionaries)
            completionHandler(tweets, nil)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            completionHandler(nil, error)
            print(error.localizedDescription)
        })
    }
    
    func updateStatus(status: String, onSuccess: @escaping () -> (), onFailure: @escaping (_ error: Error?) -> ()) -> () {
        TwitterClient.sharedInstance.post("https://api.twitter.com/1.1/statuses/update.json", parameters: ["status":status], progress: nil,
           success: { (task: URLSessionDataTask, response: Any?) in
            onSuccess()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            onFailure(error)
        })
    }
    
}