//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Keith Lee on 11/4/16.
//  Copyright © 2016 Keith Lee. All rights reserved.
//

import UIKit
import FTIndicator

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: User!
    var tweets: [Tweet]! = [Tweet]()

    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadTweets()
        followersCountLabel.text = "\(user.followersCount)"
        followingCountLabel.text = "\(user.followingCount)"
        tweetCountLabel.text = "\(user.tweetCount)"
    }
   
    func loadTweets(callback: @escaping (() -> ()) = {}) {
        FTIndicator.showProgressWithmessage("")
        user.homeTimeline { (tweets: [Tweet]?, error: Error?) in
            FTIndicator.dismissProgress()
            callback()
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.tweets = tweets!
            }
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
