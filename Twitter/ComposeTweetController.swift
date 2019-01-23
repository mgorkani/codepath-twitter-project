//
//  ComposeTweetController.swift
//  Twitter
//
//  Created by Monika Gorkani on 1/22/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class ComposeTweetController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var tweetView: UITextView!
    
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweetText(_ sender: Any) {
        if let status = tweetView.text {
            APICaller.twitterSettings?.postTweet(status: status, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                // we should display some error
                let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            })
        }
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetButton.isEnabled = false
        tweetView.delegate = self
        tweetView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (!textView.text.isEmpty) {
            tweetButton.isEnabled = true
        }else {
            tweetButton.isEnabled = false
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
