//
//  Tweet.swift
//  Twitter
//
//  Created by Keith Lee on 10/31/16.
//  Copyright © 2016 Keith Lee. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    var createdAt: String!
    var favoriteCount: Int
    var retweetCount: Int
    var user: User
    var text: String?
    var id: Int
    
    init(dictionary: NSDictionary) {
        createdAt = dictionary["created_at"] as! String
        createdAt = Utils.convert(date: createdAt)
        favoriteCount = dictionary["favorite_count"] as! Int
        retweetCount = dictionary["retweet_count"] as! Int
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        id = dictionary["id"] as! Int
    }
    
    class func tweetsAsArray(dictionaryArray: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaryArray {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    
    func retweet(onSuccess: @escaping () -> (), onFailure: @escaping (_ error: Error?) -> ()) {
        TwitterClient.sharedInstance.post("https://api.twitter.com/1.1/statuses/retweet/\(self.id).json", parameters: nil, progress: nil,
                                          success: { (task: URLSessionDataTask, response: Any?) in
            onSuccess()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            onFailure(error)
        })
    }
    
    func favorite(onSuccess: @escaping () -> (), onFailure: @escaping (_ error: Error?) -> ()) {
        TwitterClient.sharedInstance.post("https://api.twitter.com/1.1/favorites/create.json", parameters: ["id":self.id], progress: nil,
                                          success: { (task: URLSessionDataTask, response: Any?) in
            onSuccess()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            onFailure(error)
        })
    }
}
