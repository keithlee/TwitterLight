//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Keith Lee on 10/31/16.
//  Copyright © 2016 Keith Lee. All rights reserved.
//

import UIKit
import FTIndicator

class TweetsViewController: UIViewController, UITableViewDataSource {
    
    var tweets = [Tweet]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        loadTweets()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TweetsViewController.refreshControlAction), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
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
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        User.currentUser = nil
        let ivc = self.storyboard?.instantiateInitialViewController()
        present(ivc!, animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.tweet = self.tweets[indexPath.row]
        return cell
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "TweetSegue" {
            let tweetCell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: tweetCell)
            let tweet = tweets[indexPath!.row]
            
            let vc = segue.destination as! TweetViewController
            vc.tweet = tweet
        }
    }

}
