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
    let myRefreshControl = UIRefreshControl()
    
    @objc func loadTweets(){
        numOfTweets = 20
        let params = ["count": numOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: apiURL, parameters: params as [String : Any], success: {
            (tweets: [NSDictionary]) in 
           self.tweetArray.removeAll()
            
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Can't retrieve tweets :(")
        })
        
    }
    
    func loadMoreTweets(){
        numOfTweets = numOfTweets + 10
        let params = ["count": numOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: apiURL, parameters: params as [String : Any], success: {
            (tweets: [NSDictionary]) in
            
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("Can't retrieve tweets :(")
        })
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == tweetArray.count{
            loadMoreTweets()
        }
    }
    
    
    
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userName.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageURL = URL(string: ((user["profile_image_url_https"]as? String)!))
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            cell.profileImage.image = UIImage(data:imageData)
        }
        
        return cell
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    

    
}
