//
//  SurchargeReport.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/09/2023.
//

import UIKit
import ObjectMapper

struct SurchargeReport:Mappable{
    var reportType = 0
    var dateString = ""
    var surchargeReportData = [SurchargeReportData]()
    var total_amount = 0
    var total_order_quantity = 0
    
    
    init?(){}
    init?(map: Map) {
    }
    
    
    init(reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
    }
    
    mutating func mapping(map: Map) {
        surchargeReportData <- map["list"]
        total_amount <- map["total_amount"]
        total_order_quantity <- map[""]
    }
    
}


struct SurchargeReportData:Mappable {
    var branch_id = 0
    var order_quantity = 0
    var report_time = ""
    var restaurant_brand_id =  0
    var restaurant_id = 0
    var total_amount = 0
    var total_order = 0
  
    
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        order_quantity <- map["order_quantity"]
        report_time                                      <- map["report_time"]
        restaurant_id                                    <- map["restaurant_id"]
        restaurant_brand_id                                   <- map["restaurant_brand_id"]
        branch_id                                 <- map["branch_id"]
        total_amount                                  <- map["total_amount"]
        total_order                      <- map["total_order"]
     
       
    }
    
}
