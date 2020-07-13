//
//  XLViewController.swift
//  NewsAppTabbed
//
//  Created by Anand Gokul on 5/3/20.
//  Copyright © 2020 Anand Gokul. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class XLViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        
        self.configureButtonBar()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - PagerTabStripDataSource

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

         let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
         child1.childNumber = "World"
         child1.sourceURL = "http://newswebsite.us-east-1.elasticbeanstalk.com/guardianiOSWorld"

         let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
         child2.childNumber = "Business"
         child2.sourceURL = "http://newswebsite.us-east-1.elasticbeanstalk.com/guardianiOSBusiness"
        
        let child3 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
        child3.childNumber = "Politics"
        child3.sourceURL = "http://newswebsite.us-east-1.elasticbeanstalk.com/guardianiOSPolitics"
        
        let child4 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
        child4.childNumber = "Sports"
        child4.sourceURL = "http://newswebsite.us-east-1.elasticbeanstalk.com/guardianiOSSports"
        
        let child5 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
        child5.childNumber = "Technology"
        child5.sourceURL = "http://newswebsite.us-east-1.elasticbeanstalk.com/guardianiOSTechnology"
        
        let child6 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
        child6.childNumber = "Science"
        child6.sourceURL = "http://newswebsite.us-east-1.elasticbeanstalk.com/guardianiOSScience"

         return [child1, child2, child3, child4, child5, child6]
    }
    

    // MARK: - Configuration

    func configureButtonBar() {
         // Sets the background colour of the pager strip and the pager strip item
         settings.style.buttonBarBackgroundColor = .white
         settings.style.buttonBarItemBackgroundColor = .white

         // Sets the pager strip item font and font color
         settings.style.buttonBarItemFont = UIFont(name: "Helvetica", size: 16.0)!
         settings.style.buttonBarItemTitleColor = .gray

         // Sets the pager strip item offsets
         settings.style.buttonBarMinimumLineSpacing = 0
         settings.style.buttonBarItemsShouldFillAvailableWidth = true
         settings.style.buttonBarLeftContentInset = 0
         settings.style.buttonBarRightContentInset = 0

         // Sets the height and colour of the slider bar of the selected pager tab
         settings.style.selectedBarHeight = 3.0
         settings.style.selectedBarBackgroundColor = .systemBlue

         // Changing item text color on swipe
         changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
               guard changeCurrentIndex == true else { return }
               oldCell?.label.textColor = .gray
               newCell?.label.textColor = .systemBlue
         }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
