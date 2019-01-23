//
//  ReplyTweetController.swift
//  Twitter
//
//  Created by Monika Gorkani on 1/23/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class ReplyTweetController: UIViewController {

    
    @IBOutlet weak var replyTextView: UITextView!
    var tweet:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tweet = tweet {
            if let user = tweet["user"] as? NSDictionary, let screenName = user["screen_name"] as? String {
                
                replyTextView.text = "@\(screenName)"
            }
        }

        // Do any additional setup after loading the view.
    }
    

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func replyTweet(_ sender: Any) {
        if let tweetId = tweet?["id"] as? Int, !replyTextView.text.isEmpty {
            APICaller.twitterSettings?.replyTweet(tweetId: tweetId, status: replyTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            })
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
