//
//  ArticleCell.swift
//  NewsAppTabbed
//
//  Created by Anand Gokul on 4/28/20.
//  Copyright © 2020 Anand Gokul. All rights reserved.
//

import UIKit


class ArticleCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var category: UILabel!
    
    //Bookmark
    @IBOutlet weak var bookmarkIcon: BookmarksButtonClass!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
