//
//  BookmarksViewController.swift
//  NewsAppTabbed
//
//  Created by Anand Gokul on 5/4/20.
//  Copyright © 2020 Anand Gokul. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
            
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}

extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of rows of collectionview cells...Only 1
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarksCell", for: indexPath) as! BookmarksTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Height of one cell...should be equal to screen height
        return 700
    }
    
    
}
