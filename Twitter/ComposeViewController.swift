//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Keith Lee on 10/31/16.
//  Copyright © 2016 Keith Lee. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let user = User.currentUser!
        nameLabel.text = user.name
        screenNameLabel.text = user.screenName
        profileImage.setImageWith(URL(string: user.profileImageUrl)!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var statusTextView: UITextView!
    
    @IBAction func tweet(_ sender: UIBarButtonItem) {
        User.currentUser!.updateStatus(status: statusTextView.text,onSuccess: {
            //Unwind and refresh
            self.dismiss(animated: true, completion: nil)
        }, onFailure: { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
