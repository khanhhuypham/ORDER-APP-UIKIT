//
//  RevenueCategory.swift
//  TechresOrder
//
//  Created by Kelvin on 05/02/2023.
//

import UIKit
import ObjectMapper

struct RevenueCategoryData: Mappable {
    var revenues: [RevenueCategory]?
    var total_amount = 0
    var total_original_amount = 0
    var total_profit = 0
    var total_profit_ratio = 0
    init() {}
    init?(map: Map) {
    }


    mutating func mapping(map: Map) {
        revenues <- map["list"]
        total_amount <- map["total_amount"]
        total_original_amount <- map["total_original_amount"]
        total_profit <- map["total_profit"]
        total_profit_ratio <- map["total_profit_ratio"]
    }
}




struct RevenueCategoryReport: Mappable {
    var reportType = 0
    var dateString = ""
    var filterType = 0
    var revenuesData: [RevenueCategory] = []
    var total_amount = 0
    var total_original_amount = 0
    var total_profit = 0
    var total_profit_ratio = 0
    init() {}
    init?(map: Map) {
    }
    
    init(reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
    }

    mutating func mapping(map: Map) {
        revenuesData <- map["list"]
        total_amount <- map["total_amount"]
        total_original_amount <- map["total_original_amount"]
        total_profit <- map["total_profit"]
        total_profit_ratio <- map["total_profit_ratio"]
    }
}



struct RevenueCategory:Mappable {
    
    var category_id = 0
    var category_name = ""
    var total_amount =  0
    var total_original_amount = 0
    var profit = 0
    var profit_ratio = 0
    var order_quantity = 0
    
    
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        category_id                                      <- map["category_id"]
        category_name                                    <- map["category_name"]
        total_amount                                   <- map["total_amount"]
        total_original_amount                                 <- map["total_original_amount"]
        profit                                  <- map["profit"]
        profit_ratio                      <- map["profit_ratio"]
        order_quantity <- map["order_quantity"]
       
    }
    
}
