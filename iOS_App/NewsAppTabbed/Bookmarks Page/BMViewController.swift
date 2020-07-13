//
//  BMViewController.swift
//  NewsAppTabbed
//
//  Created by Anand Gokul on 5/4/20.
//  Copyright © 2020 Anand Gokul. All rights reserved.
//

import UIKit

class BMViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    
    
    @IBOutlet weak var noBookmarksLabel: UILabel!
    
    
    let cellReuseIdentifier = "cell"
       let cellSpacingHeight: CGFloat = 10
    
    var articles1: [Article]? = []
    var articles2: [Article]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //fetchArticles()
        loadFromUserDefaults()

        //Refreshing table from other view cotrollers
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadBookmarks"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeToast), name: NSNotification.Name(rawValue: "makeToast"), object: nil)


    }
    
    @objc func makeToast(notification: NSNotification){
        //load data here
        self.view.makeToast("Article Removed from Bookmarks", duration: 3.0, position: .bottom)
    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
        loadFromUserDefaults()
        self.tableView1.reloadData()
        self.tableView2.reloadData()
    }
    
    func loadFromUserDefaults(){
        
         var count = 1
        
        self.articles1 = [Article]()
        self.articles2 = [Article]()
        
        let currentKeys = Array(UserDefaults.standard.dictionaryRepresentation().keys)
        var bookmarkKeys = [String]()
        
        for key in currentKeys{
            //print("--------------------------")
            //print(key)
            if key.contains("https://www.theguardian.com/"){
                //print(key)
                bookmarkKeys.append(key)
            }
        }
        
        if bookmarkKeys.count == 0{
            noBookmarksLabel.text = "No Bookmarks added"
        } else{
            noBookmarksLabel.text = ""
        }
        
        for key in bookmarkKeys{
            let valueOfOneKey = UserDefaults.standard.dictionary(forKey: key)
        
            let article = Article()
            //dump(valueOfOneKey)
            
            for (key, value) in valueOfOneKey! {
                //print("\(key) -> \(value)")
                
                if(key == "des"){
                    article.des = value as? String
                }
                else if(key == "headline"){
                    article.headline = value as? String
                }
                else if(key == "category"){
                    article.category = value as? String
                }
                else if(key == "originalDate"){
                    article.originalDate = value as? String
                }
                else if(key == "url"){
                    article.url = value as? String
                }
                else if(key == "imageUrl"){
                    article.imageUrl = value as? String
                }
                else if(key == "expandedDate"){
                    article.expandedDate = value as? String
                }
                else{
                    article.agoDate = value as? String
                }
                
            }
            
            if(count%2==1){
                self.articles1?.append(article)
                count+=1
            } else{
                self.articles2?.append(article)
                count+=1
            }
            
        }
        
        DispatchQueue.main.async {
            self.tableView1.reloadData()
            self.tableView2.reloadData()
        }
        
    }
    
    //MARK:Tableview Delegates and Datasource Methods
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
        //print("||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n")
        //print(indexPath[0])
        //print("||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n")
        
        
        if tableView  == tableView1
           {
               // place your code here
            let cell1 = tableView1.dequeueReusableCell(withIdentifier: "bm1TableViewCell", for: indexPath) as! BM1TableViewCell
                       //Previously...Was .item instead of .section
                       cell1.title.text = self.articles1?[indexPath.section].headline
                       cell1.time.text = self.articles1?[indexPath.section].agoDate
                       cell1.category.text = self.articles1?[indexPath.section].category
                       cell1.imgView.downloadImage(from: (self.articles1?[indexPath.section].imageUrl!)!)
            
                        //Bookmarks Class
            cell1.url = (self.articles1?[indexPath.section].url)!
                               
                       return cell1
           }
           else {
               // place your code here
            let cell2 = tableView2.dequeueReusableCell(withIdentifier: "bm2TableViewCell", for: indexPath) as! BM2TableViewCell
                       //Previously...Was .item instead of .section
                       cell2.title.text = self.articles2?[indexPath.section].headline
                       cell2.time.text = self.articles2?[indexPath.section].agoDate
                       cell2.category.text = self.articles2?[indexPath.section].category
                       cell2.imgView.downloadImage(from: (self.articles2?[indexPath.section].imageUrl!)!)
            
                        //Bookmarks Class
            cell2.url = (self.articles2?[indexPath.section].url)!
                               
                       return cell2
           }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        if tableView  == tableView1
        {
            // place your code here
            return self.articles1?.count ?? 0
        }
        else if tableView  == tableView2 {
            // place your code here
            return self.articles2?.count ?? 0
        }
        else {
          return 0
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.articles?.count ?? 0
        return 1
    }
    
    //This function will be called whenever a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailed") as! DetailedViewController
        
        if tableView  == tableView1
           {
               // place your code here
            
            detailedVC.headline = self.articles1?[indexPath.section].headline
                   detailedVC.category = self.articles1?[indexPath.section].category
                   detailedVC.expandedDate = self.articles1?[indexPath.section].expandedDate
                   detailedVC.des = self.articles1?[indexPath.section].des
                   detailedVC.url = self.articles1?[indexPath.section].url
                   detailedVC.imageUrl = self.articles1?[indexPath.section].imageUrl
            detailedVC.originalDate = (self.articles1?[indexPath.section].originalDate)!
            detailedVC.agoDate = (self.articles1?[indexPath.section].agoDate)!
            
            /*print("||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n")
            print(indexPath.item)
            print(indexPath.section)
            print("||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n")*/
            
            detailedVC.modalPresentationStyle = .fullScreen
            //self.present(detailedVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(detailedVC, animated: true)
           }
           else {
       
            detailedVC.headline = self.articles2?[indexPath.section].headline
                   detailedVC.category = self.articles2?[indexPath.section].category
                   detailedVC.expandedDate = self.articles2?[indexPath.section].expandedDate
                   detailedVC.des = self.articles2?[indexPath.section].des
                   detailedVC.url = self.articles2?[indexPath.section].url
                   detailedVC.imageUrl = self.articles2?[indexPath.section].imageUrl
            detailedVC.originalDate = (self.articles2?[indexPath.section].originalDate)!
            detailedVC.agoDate = (self.articles2?[indexPath.section].agoDate)!
            
            /*print("||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n")
                       print(indexPath.item)
                       print(indexPath.section)
                       print("||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n")*/
            
            detailedVC.modalPresentationStyle = .fullScreen
            //self.present(detailedVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(detailedVC, animated: true)
        }
        
       
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
}
