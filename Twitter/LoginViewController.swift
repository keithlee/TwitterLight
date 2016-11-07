//
//  ViewController.swift
//  Twitter
//
//  Created by Keith Lee on 10/29/16.
//  Copyright © 2016 Keith Lee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: UIButton) {
        let twitterClient = TwitterClient.sharedInstance
        twitterClient.login(onSuccess: { () -> Void in
            print("Success")
            self.performSegue(withIdentifier: "ShowHamburgerSegue", sender: self)
        }, onFailure: { (error: Error?) -> Void in
            print("error")
        })
    }

}

