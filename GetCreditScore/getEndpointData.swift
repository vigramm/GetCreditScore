//
//  getEndpointData.swift
//  GetCreditScore
//
//  Created by Vigram Mohan on 03/10/2018.
//  Copyright © 2018 Vigram. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON

protocol getEndPointDataProtocol: class {
    
    
    var score: PieChartDataEntry {get set}
    func getData(urlString: String, completionHandler: @escaping (_ output: NSString) -> Void )
    
}
