//
//  OrderHistoryOfFoodApp.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/08/2024.
//

import UIKit
import ObjectMapper


struct OrderHistoryOfFoodApp: Mappable {
    var partnerId:Int = 0
    var reportType:Int = 0
    var dateString = ""
        
    var list:[FoodAppOrder] = []
    var total_revenue_SHF = 0
    var total_revenue_GRF = 0
    var total_revenue_GOF = 0
    var total_revenue_BEF = 0
    var total_revenue = 0
    var total_order_completed = 0
    var total_order_cancelled = 0
    
    
    
 
    
    init?(map: Map) {}
    
    init(){}
    
    init(partnerId:Int,reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
        self.partnerId = partnerId
    }
    
    mutating func mapping(map: Map) {
        list <- map["list"]
        total_revenue_SHF <- map["total_revenue_SHF"]
        total_revenue_GRF <- map["total_revenue_GRF"]
        total_revenue_GOF <- map["total_revenue_GOF"]
        total_revenue_BEF <- map["total_revenue_BEF"]
        total_revenue <- map["total_revenue"]
        total_order_completed <- map["total_order_completed"]
        total_order_cancelled <- map["total_order_cancelled"]
    }
    
    
}

