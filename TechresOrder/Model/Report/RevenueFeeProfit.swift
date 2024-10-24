//
//  RevenueFeeProfit.swift
//  TechresOrder
//
//  Created by Kelvin on 05/02/2023.
//

import UIKit
import ObjectMapper

struct RevenueFeeProfitData: Mappable {
    var revenues: [RevenueFeeProfit]?
    var total_revenue_amount = 0
    var total_cost_amount = 0
    var total_profit_amount = 0

    init?(map: Map) {
    }


    mutating func mapping(map: Map) {
        revenues <- map["list"]
        total_revenue_amount <- map["total_revenue_amount"]
        total_cost_amount <- map["total_cost_amount"]
        total_profit_amount <- map["total_profit_amount"]
    }
}


struct RevenueFeeProfitReport: Mappable {
    var reportType = 0
    var dateString = ""
    var fromDate = ""
    var revenueFeeProfitData: [RevenueFeeProfit] = []
    var total_revenue_amount = 0
    var total_cost_amount = 0
    var total_profit_amount = 0
    
    init?(map: Map) {
    }
    init?() {
    }
    
    init(reportType:Int, dateString:String,fromDate:String){
        self.reportType = reportType
        self.dateString = dateString
        self.fromDate = fromDate
    }
    init(reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
    }

    
    mutating func mapping(map: Map) {
        revenueFeeProfitData <- map["list"]
        total_revenue_amount <- map["total_revenue_amount"]
        total_cost_amount <- map["total_cost_amount"]
        total_profit_amount <- map["total_profit_amount"]
    }
}


struct RevenueFeeProfit:Mappable {
    
    var restaurant_id = 0
    var restaurant_brand_id = 0
    var branch_id =  0
    var branch_name = ""
    var total_revenue_amount = 0
    var total_cost_amount = 0
    var total_profit_amount = 0
  
    
    
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        restaurant_id                                      <- map["restaurant_id"]
        restaurant_brand_id                                    <- map["restaurant_brand_id"]
        branch_id                                   <- map["branch_id"]
        branch_name                                 <- map["branch_name"]
        total_revenue_amount                                  <- map["total_revenue_amount"]
        total_cost_amount                      <- map["total_cost_amount"]
        total_profit_amount                      <- map["total_profit_amount"]
     
       
    }
    
}
