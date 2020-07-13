//
//  DetailedViewController.swift
//  NewsAppTabbed
//
//  Created by Anand Gokul on 4/29/20.
//  Copyright © 2020 Anand Gokul. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    
    //These are the UI elements
    @IBOutlet weak var detailedImage: UIImageView!
    
    @IBOutlet weak var detailedTitle: UILabel!
    
    @IBOutlet weak var detailedCategory: UILabel!
    
    @IBOutlet weak var detailedDate: UILabel!
    
    @IBOutlet weak var detailedContent: UILabel!
    
    @IBOutlet weak var bookmarkIcon: UIButton!
    
    var agoDate: String = ""
    
    var originalDate: String = ""
    
    @IBAction func onBMButtonClick(_ sender: Any) {
    
        let dataDict:[String:String] = ["des":des!, "headline":headline!, "category":category!, "originalDate":originalDate, "url":url!, "imageUrl":imageUrl!,  "expandedDate":expandedDate!, "agoDate":agoDate]
         
         let currentKeys = Array(UserDefaults.standard.dictionaryRepresentation().keys)
         //print(currentKeys)
         if currentKeys.contains(String(url!)){
             //print("Bookmark already exists...Removing!")
             UserDefaults.standard.removeObject(forKey: String(url!))
             UserDefaults.standard.removeObject(forKey: String(url!))
             UserDefaults.standard.removeObject(forKey: String(url!))
             self.view.makeToast("Article Removed from Bookmarks", duration: 3.0, position: .bottom)
             bookmarkIcon.setImage(UIImage(systemName: "bookmark"), for: .normal)
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadBookmarks"), object: nil)
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHeadlinesPage"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomePage"), object: nil)

         } else{
             //print("Bookmark to be added...Added!")
             UserDefaults.standard.set(dataDict, forKey: String(url!))
             UserDefaults.standard.set(dataDict, forKey: String(url!))
             self.view.makeToast("Article Bookmarked. Check out the Bookmarks tab to view", duration: 3.0, position: .bottom)
             bookmarkIcon.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadBookmarks"), object: nil)
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHeadlinesPage"), object: nil)
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomePage"), object: nil)
         }
        
        
    }
    
    
    @IBAction func detailedFullArticleLinkButton(_ sender: Any) {
        if let targetUrl = NSURL(string: url!){
            UIApplication.shared.openURL(targetUrl as URL)
        }    }
    
    @IBOutlet weak var topHeading: UINavigationItem!
    
    @IBAction func detailedDoTwitterShare(_ sender: Any) {
        let twitterLink = "http://twitter.com/share?url=\(url ?? "http://theguardian.com/pagenotfound")&text=Check+out+this+article&hashtag=CSCI_571_NewsApp"
        if let targetUrl = NSURL(string: twitterLink){
            UIApplication.shared.openURL(targetUrl as URL)
        }
    }
    
    @IBAction func detailedDoAddBookmark(_ sender: Any) {
    }
    
    
    
    //These are the variables needed for this view which will be passed
    var headline: String?
    var category: String?
    var expandedDate: String?
    var des: String?
    var url: String?
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailedTitle.text = headline
        detailedCategory.text = category
        detailedDate.text = expandedDate
        detailedContent.text = des
        
        detailedImage.downloadImage(from: imageUrl!)
        
        topHeading.title = headline
        
        //For removing borders of Nav Bar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //For setting starting bookmark icon
        let currentKeys = Array(UserDefaults.standard.dictionaryRepresentation().keys)
        //print(currentKeys)
        if currentKeys.contains(String(url!)){
            bookmarkIcon.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else{
            bookmarkIcon.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
    }
    
    /*@IBAction func unwindToSomeVCWithSegue(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindSegueIdentifier", sender: nil)
    }*/
        

}
