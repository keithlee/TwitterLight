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
private let kFollowersCount = "followersCount"
private let kFollowingCount = "followingCount"
private let kFavoritesCount = "favoritesCount"
private let kProfileBackgroundImage = "profileBackgroundImage"
private let kTweetCount = "tweetCount"
private let kId = "userId"

class User: NSObject, NSCoding {
    var name: String!
    var profileImageUrl: String!
    var screenName: String!
    var profileBackgroundImage: String!
    var followersCount: Int!
    var followingCount: Int!
    var favoritesCount: Int!
    var tweetCount: Int!
    var id: Int!
    
    static var _currentUser: User?
    
    static let kUser = "currentUser"

    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        screenName = "@\((dictionary["screen_name"] as! String))"
        profileBackgroundImage = dictionary["profile_background_image_url_https"] as? String
        followersCount = dictionary["followers_count"] as! Int
        favoritesCount = dictionary["favourites_count"] as! Int
        followingCount = dictionary["friends_count"] as! Int
        tweetCount = dictionary["statuses_count"] as! Int
        id = dictionary["id"] as! Int
    }
    
    class var currentUser: User? {
        get {
            if let _currentUser = _currentUser {
                return _currentUser
            }
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
        aCoder.encode(id, forKey: kId)
        aCoder.encode(name, forKey: kName)
        aCoder.encode(profileImageUrl, forKey: kProfileImage)
        aCoder.encode(screenName, forKey: kScreenName)
        aCoder.encode(followingCount, forKey: kFollowingCount)
        aCoder.encode(followersCount, forKey: kFollowersCount)
        aCoder.encode(favoritesCount, forKey: kFavoritesCount)
        aCoder.encode(tweetCount, forKey: kTweetCount)
        aCoder.encode(profileBackgroundImage, forKey: kProfileBackgroundImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: kId) as! Int
        name = aDecoder.decodeObject(forKey: kName) as! String
        profileImageUrl = aDecoder.decodeObject(forKey: kProfileImage) as! String
        screenName = aDecoder.decodeObject(forKey: kScreenName) as! String
        followingCount = aDecoder.decodeObject(forKey: kFollowingCount) as! Int
        followersCount = aDecoder.decodeObject(forKey: kFollowersCount) as! Int
        favoritesCount = aDecoder.decodeObject(forKey: kFavoritesCount) as! Int
        tweetCount = aDecoder.decodeObject(forKey: kTweetCount) as! Int
        profileBackgroundImage = aDecoder.decodeObject(forKey: kProfileBackgroundImage) as! String
    }
    
    func timeline(completionHandler: @escaping (_ tweets: [Tweet]?, _ error: Error?) -> ()){
        TwitterClient.sharedInstance.get("https://api.twitter.com/1.1/statuses/user_timeline.json", parameters: ["user_id": id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsAsArray(dictionaryArray: dictionaries)
            completionHandler(tweets, nil)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            completionHandler(nil, error)
            print(error.localizedDescription)
        })
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
    
    func mentionsTimeline(completionHandler: @escaping (_ tweets: [Tweet]?, _ error: Error?) -> ()){
        TwitterClient.sharedInstance.get("https://api.twitter.com/1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
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
