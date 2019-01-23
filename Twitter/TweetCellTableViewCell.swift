//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Dan on 1/3/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetAuthorLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    weak var delegate:TweetDelegate?
    var tweet:NSDictionary?
    var favorited:Bool  = false {
        didSet {
            if favorited {
                favButton.setImage(UIImage(named:"favor-icon-red"), for:UIControl.State.normal)
            } else {
                favButton.setImage(UIImage(named:"favor-icon"), for:UIControl.State.normal)
            }
        }
    }
    
    var retweeted:Bool = false {
        didSet {
            if retweeted {
                retweetButton.setImage(UIImage(named:"retweet-icon-green"), for:UIControl.State.normal)
            } else {
                retweetButton.setImage(UIImage(named:"retweet-icon"), for:UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func replyTweet(_ sender: Any) {
        if let tweet = tweet {
            delegate?.replyTweet(tweet)
        }
    }
    
    @IBAction func retweet(_ sender: Any) {
        if (!retweeted) {
            retweeted = true
            if let tweet = tweet{
                delegate?.retweet(tweet)
            }
        }
    }
    
    @IBAction func favouriteTweet(_ sender: Any) {
        favorited = !favorited
        if let tweet = tweet {
           delegate?.favoriteTweet(favorite: favorited, tweet: tweet)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
