//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Keith Lee on 10/31/16.
//  Copyright © 2016 Keith Lee. All rights reserved.
//

import UIKit
import FTIndicator

enum Timeline {
    case home
    case mentions
}

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets = [Tweet]()
    var timelineState: Timeline! = .home

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        loadTweets()
        FTIndicator.dismissProgress()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TweetsViewController.refreshControlAction), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadTweets(callback: refreshControl.endRefreshing)
    }
    
    func loadTweets(callback: @escaping (() -> ()) = {}) {
        FTIndicator.showProgressWithmessage("")
        if timelineState == Timeline.home {
            User.currentUser!.homeTimeline { (tweets: [Tweet]?, error: Error?) in
                FTIndicator.dismissProgress()
                callback()
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.tweets = tweets!
                }
                self.tableView.reloadData()
            }
        } else if timelineState == Timeline.mentions {
            User.currentUser!.mentionsTimeline { (tweets: [Tweet]?, error: Error?) in
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
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        User.currentUser = nil
        let ivc = self.storyboard?.instantiateInitialViewController()
        present(ivc!, animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.tweet = self.tweets[indexPath.row]
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
        cell.profileImageView.addGestureRecognizer(gestureRecognizer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "TimelineShowTweetSegue", sender: tweets[indexPath.row])
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "TimelineShowTweetSegue" {
            let tweet = sender as! Tweet
            let vc = segue.destination as! TweetViewController
            vc.tweet = tweet
        }
    }

}
