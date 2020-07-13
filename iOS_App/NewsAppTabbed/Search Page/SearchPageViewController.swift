//
//  SearchPageViewController.swift
//  NewsAppTabbed
//
//  Created by Anand Gokul on 5/3/20.
//  Copyright © 2020 Anand Gokul. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var txtSearchBar: UITextField!
    @IBOutlet weak var tblAutosuggestList: UITableView!
    
    var suggestions:[String] = Array()
    
    var oldcount:Int = 0
    
    //var originalSuggestionsList:[String] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         suggestions.append("")
        /*
        suggestions.append("Australia")
        suggestions.append("India")
        suggestions.append("South Africa" )
        suggestions.append("Ghana" )
        suggestions.append("China" )
        suggestions.append("USA" )
        suggestions.append("Russia" )
        suggestions.append("New Zealand" )
        suggestions.append("Saudi Arabia" )
        suggestions.append("Germany" )

        
        for suggestionitem in suggestions{
            originalSuggestionsList.append(suggestionitem)
        } */
                 
        bingautosuggest()
        DispatchQueue.main.async {
            self.tblAutosuggestList.reloadData()
        }
                          
        
        tblAutosuggestList.delegate = self
        tblAutosuggestList.dataSource = self
        
        txtSearchBar.delegate = self
        txtSearchBar.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
            
        suggestions.append("")
                 
        bingautosuggest()
        DispatchQueue.main.async {
            self.tblAutosuggestList.reloadData()
        }
        
        tblAutosuggestList.delegate = self
        tblAutosuggestList.dataSource = self
        
        txtSearchBar.delegate = self
        txtSearchBar.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
    }
    
    func bingautosuggest(){
        
            //let searchquery = String(txtSearchBar.text!).replacingOccurrences(of: " ", with: "%20")
       //Alamofire.request("http://newswebsite.us-east-1.elasticbeanstalk.com/guardianIOSBingAutosuggest?searchstring=\(searchquery)").responseJSON { response in
        
            let filteredtext = String( String(txtSearchBar.text!).filter { !" \n\t\r".contains($0) })
            
            let parameters = ["searchstring": filteredtext]
        
        Alamofire.request("http://newswebsite.us-east-1.elasticbeanstalk.com/guardianIOSBingAutosuggest", parameters: parameters).responseJSON { response in
        
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                //debugPrint(json)
                
                let arrayNames =  json["suggestions"].arrayValue.map {$0.stringValue}
                print(arrayNames)
                self.suggestions = arrayNames
               //self.originalSuggestionsList = arrayNames
                
            case .failure(let error):
                print(error)
            }
            
        }
        
        //self.tblAutosuggestList.reloadData()
        
        /*DispatchQueue.main.async {
                   self.tblAutosuggestList.reloadData()
               }*/
        
    }
    
    
    //MARK:- UITextFieldDelegate
    //What to do on pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Currently dismissing the keyboard on pressing return
        //txtSearchBar.resignFirstResponder()
        
        let detVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        
        //The private variables for that corresponding view goes here
        if((txtSearchBar.text!.count) != 0){
            detVC.toSearchFor = txtSearchBar.text!
            self.navigationController?.pushViewController(detVC, animated: true)
        } else{
            txtSearchBar.resignFirstResponder()
        }
        
        
        
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "autosuggestion")
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "autosuggestion")
        }
        
        cell?.textLabel?.text = suggestions[indexPath.row]
        return cell!
        
    }
    
    @objc func searchRecords(_ textField: UITextField){
        //self.suggestions.removeAll()
        /*if textField.text!.count > 1 {
            bingautosuggest()
            oldcount = textField.text!.count
        }*/
        
        if textField.text!.count > 2 {
            if textField.text!.count < oldcount {
                //self.suggestions.removeAll()
                //suggestions.append("")
                bingautosuggest()
                oldcount = textField.text!.count
            } else{
                bingautosuggest()
                oldcount = textField.text!.count
            }
        }
        
        //Reloading the table view
        
        //tblAutosuggestList.reloadData()
        
        DispatchQueue.main.async {
            self.tblAutosuggestList.reloadData()
        }
        
         //self.tblAutosuggestList.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: true)
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
           // Do some reloading of data and update the table view's data source
           // Fetch more objects from a web service, for example...
           
           // Simply adding an object to the data source for this example           
           self.tblAutosuggestList.reloadData()
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        
        //The private variables for that corresponding view goes here
        detVC.toSearchFor = suggestions[indexPath.row]
        
        
        self.navigationController?.pushViewController(detVC, animated: true)
    }

}
