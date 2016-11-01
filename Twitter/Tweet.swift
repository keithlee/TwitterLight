//
//  Tweet.swift
//  Twitter
//
//  Created by Keith Lee on 10/31/16.
//  Copyright © 2016 Keith Lee. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    var createdAt: String?
    var favoriteCount: Int? = 0
    var retweetCount: Int? = 0 
    var user: User?
    var text: String?
    
    init(dictionary: NSDictionary) {
        createdAt = dictionary["created_at"] as? String
        favoriteCount = dictionary["favorite_count"] as? Int
        retweetCount = dictionary["retweet_count"] as? Int
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
    }
    
    class func tweetsAsArray(dictionaryArray: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaryArray {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
