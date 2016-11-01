//
//  TweetViewController.swift
//  Twitter
//
//  Created by Keith Lee on 10/31/16.
//  Copyright © 2016 Keith Lee. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    
    var tweet: Tweet!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = tweet.user.name
        screenNameLabel.text = tweet.user.screenName
        tweetLabel.text = tweet.text
        timestampLabel.text = tweet.createdAt
        profileImageView.setImageWith(URL(string: tweet.user.profileImageUrl)!)
        favoriteCountLabel.text = String(tweet.favoriteCount)
        retweetCountLabel.text = String(tweet.retweetCount)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retweet(_ sender: Any) {
        tweet.retweet(onSuccess: {
            print("success retweeting")
        }, onFailure: {(error: Error?) in
            print("error retweeting \(error?.localizedDescription)")
        })
    }

    @IBAction func favorite(_ sender: Any) {
        tweet.favorite(onSuccess: {
            print("success favoriting")
        }, onFailure: {(error: Error?) in
            print("error favoriting \(error?.localizedDescription)")
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
