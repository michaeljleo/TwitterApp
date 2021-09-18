//
//  HomeTableViewControler.swift
//  Twitter
//
//  Created by Michael Leo on 9/17/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewControler: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numOfTweets: Int!
    let apiURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    let params = ["count": 5]
    
    
    func loadTweets(){
        TwitterAPICaller.client?.getDictionariesRequest(url: apiURL, parameters: params, success: {
            (tweets: [NSDictionary]) in 
           self.tweetArray.removeAll()
            
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("Can't retrieve tweets :(")
        })
        
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadTweets()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        cell.userName.text = tweetArray[indexPath.row]["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        return cell
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    

    
}
