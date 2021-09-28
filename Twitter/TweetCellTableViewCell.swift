//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Michael Leo on 9/17/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    var favorited:Bool = false
    var tweetId:Int = -1
    var retweeted: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func onFavorite(_ sender: Any) {
        print(tweetId)
        let toBeFavorited = !favorited
        if (toBeFavorited){
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                print("Success Favorite")
                self.setFavorite(true)

            }, failure: { (Error) in
                print("Favorite  did not work\(Error)")
            })
        }
        else{
            TwitterAPICaller.client?.deleteFavorite(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (Error) in
                print("Failed to unfavorite \(Error)")
            })
        }
    }
    
    
    func setFavorite(_ isFavorited:Bool){
        favorited = isFavorited
        if (favorited){
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else{
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        
        let toBeRetweeted = !retweeted
        if (toBeRetweeted){
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                self.setRetweeted(true)
            }, failure: { (error) in
                print("retweet failed\(error)")
            })
        } else {
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                self.setRetweeted(false)
            }, failure: { (error) in
                print(error)
            })
        }
        
    }
    
    func setRetweeted(_ isRetweeted:Bool){
        retweeted = isRetweeted
        if (retweeted){
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        }
        else{
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
}
