//
//  HomeViewController.swift
//  Twitter
//
//  Created by Dan on 1/3/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit


protocol TweetDelegate: class {
    func favoriteTweet(favorite:Bool,tweet:NSDictionary)
    func retweet(_ tweet:NSDictionary)
    func replyTweet(_ tweet:NSDictionary)
}

class HomeTableViewController: UITableViewController, TweetDelegate {
    var tweetArray = [NSDictionary]()
    var refresher = UIRefreshControl()
    var numberofTweets: Int!
    var selectedTweet:NSDictionary?
    
    @IBOutlet var tweetTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        numberofTweets = 10
        refresher.addTarget(self, action: #selector(loadTweetTable), for: .valueChanged)
        tweetTable.refreshControl = refresher
        tweetTable.rowHeight = UITableView.automaticDimension
        tweetTable.estimatedRowHeight = 160
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweetTable()
    }
    
    @objc func loadTweetTable(){
        numberofTweets = 10
        APICaller.twitterSettings?.homeTimeLine(count: numberofTweets, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tweetTable.reloadData()
            self.refresher.endRefreshing()

        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    @objc func loadMoreTweet(){
        numberofTweets = numberofTweets + 10
        APICaller.twitterSettings?.homeTimeLine(count: numberofTweets, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tweetTable.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tweetTable.dequeueReusableCell(withIdentifier: "tweetcell", for: indexPath) as! TweetCellTableViewCell
        cell.tweet =  tweetArray[indexPath.row] as NSDictionary
        cell.tweetTextLabel.text = tweetArray[indexPath.row]["text"] as? String
        cell.favorited = tweetArray[indexPath.row]["favorited"] as? Bool ?? false
        cell.retweeted = tweetArray[indexPath.row]["retweeted"] as? Bool ?? false
        cell.timeLabel.text = getRelativeTime(timeString: (tweetArray[indexPath.row]["created_at"] as? String)!)
        
        let user = tweetArray[indexPath.row]["user"] as? NSDictionary
        cell.tweetAuthorLabel.text = user?["name"] as? String

        let imageUrl = URL(string: (user?["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.tweetImage.image = UIImage(data: imageData)
        }
        cell.delegate = self
        
        return cell
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        APICaller.twitterSettings?.logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweet()
        }
    }
    
    func getRelativeTime(timeString: String) -> String{
        let time: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        time = dateFormatter.date(from: timeString)!
        return time.timeAgoDisplay()
    }
    
    func favoriteTweet(favorite:Bool,tweet: NSDictionary) {
        guard let tweetId = tweet["id"] as? Int else { return}
        if (favorite) {
            APICaller.twitterSettings?.favoriteTweet(tweetId: tweetId, success: {
            
            }, failure: { (error) in
                let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            })
        } else {
            APICaller.twitterSettings?.unfavoriteTweet(tweetId: tweetId, success: {
                
            }, failure: { (error) in
                let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            })
        }
    }
    
    func retweet(_ tweet: NSDictionary) {
        guard let tweetId = tweet["id"] as? Int else { return}
        APICaller.twitterSettings?.retTweet(tweetId: tweetId, success: {
            
        }, failure: { (error) in
            let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        })
    }
    
    func replyTweet(_ tweet: NSDictionary) {
        selectedTweet = tweet
        performSegue(withIdentifier: "replySegue", sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier != nil && segue.identifier! == "replySegue") {
            if let vc = segue.destination as? UINavigationController {
                if let replyController = vc.topViewController as? ReplyTweetController {
                    replyController.tweet = selectedTweet
                }
            }
        }
    }
    
  
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        if secondsAgo < minute {
            return "\(secondsAgo) sec ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) min ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hr ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) day(s) ago"
        }
        return "\(secondsAgo / week) week(s) ago"
    }
}
