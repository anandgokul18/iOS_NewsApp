//
//  TrendingViewController.swift
//  NewsAppTabbed
//
//  Created by Anand Gokul on 5/3/20.
//  Copyright © 2020 Anand Gokul. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON
import Foundation
import SwiftSpinner

class TrendingViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var txtTextBox: UITextField!
    
    @IBOutlet weak var chtChart: LineChartView!
    
    var numbers : [Double] = [] //This is where we are going to store all the numbers. This can be a set of numbers that come from a Realm database, Core data, External API's or where ever else
    
    var input = "coronavirus"
    
    
    override func viewDidLoad() {
                
        super.viewDidLoad()
                
        self.txtTextBox.delegate = self
        
        print("loaded...")
        
        self.numbers = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 15.0, 9.0, 7.0, 6.0, 27.0, 35.0, 74.0, 100.0, 82.0, 67.0, 66.0, 56.0, 43.0, 31.0, 28.0]
        
        
        // Do any additional setup after loading the view.
        updateGraph()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        //textField code

        textField.resignFirstResponder()  //if desired
        performAction()
        return true
    }
    
    
    func performAction() {
                
        let myinput  = String(String(txtTextBox.text!).filter { !" \n\t\r".contains($0) })  //gets input from the textbox - expects input as double/int
        input = String(txtTextBox.text!)
                
        //getJsonAndUpdateGraph(input: input)
                
   // }
    
    //func getJsonAndUpdateGraph(input:String){
        //numbers.append(input!) //here we add the data to the array.
        
        Alamofire.request("http://newswebsite.us-east-1.elasticbeanstalk.com/guardianIOSTrending?searchstring=\(myinput)").responseJSON { response in
            
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                //debugPrint(json)
                
                let arrayNames =  json["valueArray"].arrayValue.map {$0.doubleValue}
                //print(arrayNames)
                self.numbers = arrayNames
                
                
            case .failure(let error):
                print(error)
            }
            
        }
        
        //self.numbers = [0.0, 2.0, 3.0]
        debugPrint(self.numbers)
        debugPrint(self.numbers.count)
        
        updateGraph()
    }
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        
        //here is the for loop
        for i in 0..<numbers.count {

            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Trending Chart for \(self.input)") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.systemBlue] //Sets the colour to blue
        line1.circleColors = [NSUIColor.systemBlue] //Sets the colour to blue

        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        

        chtChart.data = data //finally - it adds the chart data to the chart and causes an update
        //chtChart.chartDescription?.text = "Trending Chart for \(self.input)" // Here we set the description for the graph
        
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
