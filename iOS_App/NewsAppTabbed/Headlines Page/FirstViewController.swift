//
//  FirstViewController.swift
//  NewsAppTabbed
//
//  Created by Anand Gokul on 4/27/20.
//  Copyright © 2020 Anand Gokul. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!{
        didSet {
            let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            imageView.addGestureRecognizer(imageTapGestureRecognizer)
            imageView.isUserInteractionEnabled = true
        }
    }

    
    override func viewDidLoad() {
                
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
   // Func in your UIViewController
    @objc func imageTapped() {
        //navigate to another view controller
        performSegue(withIdentifier: "doSearch", sender: self)
    }
    

}

