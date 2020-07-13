//
//  BM1TableViewCell.swift
//  NewsAppTabbed
//
//  Created by Anand Gokul on 5/4/20.
//  Copyright © 2020 Anand Gokul. All rights reserved.
//

import UIKit
import Toast_Swift

class BM1TableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var bookmarkIcon1: BookmarksButtonClass!
    
    var url: String = ""
    @IBAction func onBMIconClick(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: url)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadBookmarks"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "makeToast"), object: nil)
        
        //Reloading Home Page
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomePage"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHeadlinesPage"), object: nil)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
