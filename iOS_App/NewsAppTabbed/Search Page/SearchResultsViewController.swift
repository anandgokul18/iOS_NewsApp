//
//  SearchResultsViewController.swift
//  NewsAppTabbed
//
//  Created by Anand Gokul on 5/3/20.
//  Copyright © 2020 Anand Gokul. All rights reserved.
//

import UIKit
import Foundation
import XLPagerTabStrip
import SwiftSpinner

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Table View
    @IBOutlet weak var tableView: UITableView!
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 10
    
    var articles: [Article]? = []
       
       lazy var refreshControl: UIRefreshControl = {
           let refreshControl = UIRefreshControl()
           refreshControl.addTarget(self, action:
                        #selector(ChildViewController.handleRefresh(_:)),
                                    for: UIControl.Event.valueChanged)
           refreshControl.tintColor = UIColor.systemBlue
           
           return refreshControl
       }()
    
    var toSearchFor: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SwiftSpinner.show("Loading Search Results...")
        
        fetchArticles()
        
        //SwiftSpinner.hide()

        self.tableView.addSubview(self.refreshControl)

        // Do any additional setup after loading the view.
        SwiftSpinner.show("Loading Search Results...")
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func fetchArticles(){
        let searchquery = toSearchFor.replacingOccurrences(of: " ", with: "+")
        
            let urlRequest = URLRequest(url: URL(string: "http://newswebsite.us-east-1.elasticbeanstalk.com/guardianIOSSearch?searchstring=\(searchquery)")!)
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                self.articles = [Article]()
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                    
                    if let articlesFromJson = json["articles"] as? [[String : AnyObject]] {
                        for articleFromJson in articlesFromJson {
                            let article = Article()
                            if let headline = articleFromJson["headline"] as? String,
                                let category = articleFromJson["category"] as? String,
                                let originalDate = articleFromJson["originalDate"] as? String,
                                let des = articleFromJson["description"] as? String,
                                let url = articleFromJson["url"] as? String,
                                let imageUrl = articleFromJson["imageUrl"] as? String,
                                let expandedDate = articleFromJson["expandedDate"] as? String,
                                let agoDate = articleFromJson["agoDate"] as? String
                            {
                        
                                article.des = des
                                article.headline = headline
                                article.category = category
                                article.originalDate = originalDate
                                article.url = url
                                article.imageUrl = imageUrl
                                article.expandedDate = expandedDate
                                article.agoDate = agoDate
                            }
                            self.articles?.append(article)
                        }
                        SwiftSpinner.hide()
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                } catch let error {
                    print(error)
                }
                
                
            }
            
            task.resume()
            
        }
        
        @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
            // Do some reloading of data and update the table view's data source
            // Fetch more objects from a web service, for example...
            
            // Simply adding an object to the data source for this example
            self.fetchArticles()
            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "articleCellSearch", for: indexPath) as! ArticleCellSearch
                    
            cell.title.text = self.articles?[indexPath.section].headline
            cell.time.text = self.articles?[indexPath.section].agoDate
            cell.category.text = self.articles?[indexPath.section].category
            cell.imgView.downloadImage(from: (self.articles?[indexPath.section].imageUrl!)!)
            
            //Bookmarks Class
            cell.bookmarkIcon.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
            //cell.bookmarkIcon.urlString = "hello there"
            cell.bookmarkIcon.des =  self.articles?[indexPath.section].des
            cell.bookmarkIcon.headline = self.articles?[indexPath.section].headline
            cell.bookmarkIcon.category = self.articles?[indexPath.section].category
            cell.bookmarkIcon.originalDate = self.articles?[indexPath.section].originalDate
            cell.bookmarkIcon.url =  self.articles?[indexPath.section].url
            cell.bookmarkIcon.imageUrl = self.articles?[indexPath.section].imageUrl
            cell.bookmarkIcon.expandedDate = self.articles?[indexPath.section].expandedDate
            cell.bookmarkIcon.agoDate = self.articles?[indexPath.section].agoDate
            
            //Coloring existing bookmarks
            let currentKeys = Array(UserDefaults.standard.dictionaryRepresentation().keys)
            if currentKeys.contains(String(cell.bookmarkIcon.url!)){
                cell.bookmarkIcon.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
            
            return cell
        }
        
    @objc func buttonClicked(sender:BookmarksButtonClass) {
        //print("button tapped at index:\(String(sender.urlString!))")
        //print("button tapped at index:\(String(sender.url!))")
        
        let dataDict:[String:String] = ["des":sender.des!, "headline":sender.headline!, "category":sender.category!, "originalDate":sender.originalDate!, "url":sender.url!, "imageUrl":sender.imageUrl!,  "expandedDate":sender.expandedDate!, "agoDate":sender.agoDate!]
        
        let currentKeys = Array(UserDefaults.standard.dictionaryRepresentation().keys)
        //print(currentKeys)
        if currentKeys.contains(String(sender.url!)){
            //print("Bookmark already exists...Removing!")
            UserDefaults.standard.removeObject(forKey: String(sender.url!))
            UserDefaults.standard.removeObject(forKey: String(sender.url!))
            UserDefaults.standard.removeObject(forKey: String(sender.url!))
            self.view.makeToast("Article Removed from Bookmarks", duration: 3.0, position: .bottom)
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadBookmarks"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHeadlinesPage"), object: nil)

        } else{
            //print("Bookmark to be added...Added!")
            UserDefaults.standard.set(dataDict, forKey: String(sender.url!))
            UserDefaults.standard.set(dataDict, forKey: String(sender.url!))
            self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 3.0, position: .bottom)
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadBookmarks"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHeadlinesPage"), object: nil)

        }
        
        
        
    }
    
    
        func numberOfSections(in tableView: UITableView) -> Int {
            //return 1
            return self.articles?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //return self.articles?.count ?? 0
            return 1
        }
        
        //This function will be called whenever a row is selected
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailedVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailed") as! DetailedViewController
            
            detailedVC.headline = self.articles?[indexPath.section].headline
            detailedVC.category = self.articles?[indexPath.section].category
            detailedVC.expandedDate = self.articles?[indexPath.section].expandedDate
            detailedVC.des = self.articles?[indexPath.section].des
            detailedVC.url = self.articles?[indexPath.section].url
            detailedVC.imageUrl = self.articles?[indexPath.section].imageUrl
            detailedVC.originalDate = (self.articles?[indexPath.section].originalDate)!
            detailedVC.agoDate = (self.articles?[indexPath.section].agoDate)!
            
            detailedVC.modalPresentationStyle = .fullScreen
            //self.present(detailedVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(detailedVC, animated: true)
        }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through...For spacing
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    //Context Menu
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = articles![indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

            // Create an action for sharing
            let share = UIAction(title: "Share with Twitter", image: UIImage(named: "twitter")) { action in
                
                print("Sharing \(item)")
                
                let url = self.articles?[indexPath.section].url
                
                let twitterLink = "http://twitter.com/share?url=\(url ?? "http://theguardian.com/pagenotfound")&text=Check+out+this+article&hashtag=CSCI_571_NewsApp"
                if let targetUrl = NSURL(string: twitterLink){
                    UIApplication.shared.openURL(targetUrl as URL)
                }
                
            }

            // Create other actions...
            let bookmark = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { action in
                
                print("Bookmarking \(item)")
                
                let url = self.articles?[indexPath.section].url
                
                let dataDict:[String:String] = ["des":(self.articles?[indexPath.section].des!)!, "headline":(self.articles?[indexPath.section].headline!)!, "category":(self.articles?[indexPath.section].category!)!, "originalDate":(self.articles?[indexPath.section].originalDate!)!, "url":(self.articles?[indexPath.section].url!)!, "imageUrl":(self.articles?[indexPath.section].imageUrl!)!,  "expandedDate":(self.articles?[indexPath.section].expandedDate!)!, "agoDate":(self.articles?[indexPath.section].agoDate!)!]
                
                let currentKeys = Array(UserDefaults.standard.dictionaryRepresentation().keys)
                //print(currentKeys)
                if currentKeys.contains(String(url!)){
                    //print("Bookmark already exists...Removing!")
                    UserDefaults.standard.removeObject(forKey: String(url!))
                    UserDefaults.standard.removeObject(forKey: String(url!))
                    UserDefaults.standard.removeObject(forKey: String(url!))
                    self.view.makeToast("Article Removed from Bookmarks", duration: 3.0, position: .bottom)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadBookmarks"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHeadlinesPage"), object: nil)
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "articleCellSearch", for: indexPath) as! ArticleCellSearch
                    cell.bookmarkIcon.setImage(UIImage(systemName: "bookmark"), for: .normal)
                    self.fetchArticles()
                    self.tableView.reloadData()

                } else{
                    //print("Bookmark to be added...Added!")
                    UserDefaults.standard.set(dataDict, forKey: String(url!))
                    UserDefaults.standard.set(dataDict, forKey: String(url!))
                    self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 3.0, position: .bottom)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadBookmarks"), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHeadlinesPage"), object: nil)
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "articleCellSearch", for: indexPath) as! ArticleCellSearch
                    cell.bookmarkIcon.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                    self.fetchArticles()
                    self.tableView.reloadData()

                }
                
                
            }

            return UIMenu(title: "Menu", children: [share, bookmark])
        }
    }

    }

