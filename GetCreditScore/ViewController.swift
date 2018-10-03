//
//  ViewController.swift
//  GetCreditScore
//
//  Created by Vigram Mohan on 03/10/2018.
//  Copyright © 2018 Vigram. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON


@IBDesignable

class ViewController: UIViewController, getEndPointDataProtocol {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    var score = PieChartDataEntry(value:0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(urlString: "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values", completionHandler: {output in print(output)})
    }
    
    
    func getData(urlString: String, completionHandler: @escaping (_ output: NSString) -> Void ) {
        
        guard let url = URL(string: urlString)
        else {
                completionHandler("String not valid")
                return
        }
        //Perfrom HTTP request to the endpoint
        Alamofire.request(url).responseJSON { response in
            if let result = response.result.value {
                let json = JSON(result)
                //get response as double
                if let scoreTemp = json["creditReportInfo"]["score"].double {
                    self.score = PieChartDataEntry(value: scoreTemp)
                    print(self.score)
                    completionHandler("Value obtained")
                    //Draw pie chart once the value is obtained.
                    self.initiatePieChart()
                }
                
            }
            else
            {
                completionHandler("value not obtained")
            }
        }
    }
    
    
    func initiatePieChart()
    {
        // Add dataSet so that the values are displayed as a percentage of 700
        let pieChartDataSet = PieChartDataSet(values: [score,PieChartDataEntry(value: 700.0)], label: nil)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        let colours = [ UIColor.orange,UIColor.white]
        pieChartDataSet.colors = colours
        pieChartDataSet.drawValuesEnabled = false
        pieChartDataSet.label = ""
        
        pieChart.centerText = "Your Credit Score is \(self.score.value)"
        pieChart.chartDescription?.enabled = false
        pieChart.data = pieChartData
        pieChart.legend.enabled = false
        pieChart.holeRadiusPercent = 0.8
        pieChart.rotationEnabled = false
        
        addBorderCircle()
    }
    
    func addBorderCircle()
    {
        // Create BezierPath with the same center as the circle
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: pieChart.centerCircleBox.x, y: pieChart.centerCircleBox.y+18) , radius: pieChart.radius+20, startAngle: CGFloat(0), endAngle:.pi*2, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2.0
        
        //Add layer on top of the charts layer
        pieChart.layer.addSublayer(shapeLayer)
        
    }
}

