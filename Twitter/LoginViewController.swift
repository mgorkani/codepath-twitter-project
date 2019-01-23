//
//  LoginViewController.swift
//  Twitter
//
//  Created by Dan on 1/4/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.bool(forKey: "alreadyLoggedIn") == true){
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }

    @IBAction func onLoginButton(_ sender: Any) {
        APICaller.twitterSettings?.login(success: {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        

    }
}
