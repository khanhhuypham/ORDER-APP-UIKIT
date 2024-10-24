//
//  Revenue.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 06/00/2023.
//

import UIKit
import ObjectMapper


struct RevenueReport: Mappable {
    var reportType = 0
    var dateString = ""
    var revenues: [Revenue] = []
    var total_revenue = 0
    init?(map: Map) {
    }
    init?() {
    }
    
    init(reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
    }
 

    mutating func mapping(map: Map) {
        revenues <- map["list"]
        total_revenue <- map["total_revenue"]
    }
}

struct Revenue:Mappable {
    
    var report_time = ""
    var restaurant_id = 0
    var restaurant_brand_id =  0
    var branch_id = 0
    var total_revenue = 0
    var total_order = 0
  
    
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        report_time                                      <- map["report_time"]
        restaurant_id                                    <- map["restaurant_id"]
        restaurant_brand_id                                   <- map["restaurant_brand_id"]
        branch_id                                 <- map["branch_id"]
        total_revenue                                  <- map["total_revenue"]
        total_order                      <- map["total_order"]
     
       
    }
    
}
