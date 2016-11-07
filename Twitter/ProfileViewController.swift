//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Keith Lee on 11/4/16.
//  Copyright © 2016 Keith Lee. All rights reserved.
//

import UIKit
import FTIndicator

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var user: User!
    var tweets: [Tweet]! = [Tweet]()

    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerProfileImageView: UIImageView!
    @IBOutlet weak var headerBackgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadTweets()
        followersCountLabel.text = String(user.followersCount)
        followingCountLabel.text = String(user.followingCount)
        tweetCountLabel.text = String(user.tweetCount)
        tableView.register(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        headerProfileImageView.setImageWith(URL(string: user.profileImageUrl)!)
        headerBackgroundImageView.setImageWith(URL(string: user.profileBackgroundImage)!)
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
    
    func handleImageTap(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view
        let cell = imageView?.superview?.superview as! TweetCell
        let pvc = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        pvc.user = cell.tweet?.user
        pvc.navigationItem.leftItemsSupplementBackButton = true
        navigationController?.pushViewController(pvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
        cell.profileImageView.addGestureRecognizer(gestureRecognizer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowTweetSegue", sender: tweets[indexPath.row])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowTweetSegue" {
            let tweet = sender as! Tweet
            let vc = segue.destination as! TweetViewController
            vc.tweet = tweet
        }
    }

}
