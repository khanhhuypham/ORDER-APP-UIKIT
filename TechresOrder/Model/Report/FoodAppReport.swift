//
//  FoodAppReport.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/08/2024.
//

import UIKit
import ObjectMapper


struct FoodAppReport: Mappable {
    var filterType:Int = 0
    var reportType:Int = 0
    var dateString = ""
    
    
    var list:[FoodAppReportData] = []
    
    var total_order = 0
    var total_order_SHF = 0
    var total_order_GRF = 0
    var total_order_GOF = 0
    var total_order_BEF = 0
    
    var total_revenue = 0
    var total_revenue_SHF = 0
    var total_revenue_GRF = 0
    var total_revenue_GOF = 0
    var total_revenue_BEF = 0

    var percent_SHF = 0
    var percent_GRF = 0
    var percent_GOF = 0
    var percent_BEF = 0
    
    init?(map: Map) {}
    
    init(){}
    
    init(reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
    }
    
    mutating func mapping(map: Map) {
        list <- map["list"]
        
        total_order <- map["total_order"]
        total_order_SHF <- map["total_order_SHF"]
        total_order_GRF <- map["total_order_GRF"]
        total_order_GOF <- map["total_order_GOF"]
        total_order_BEF <- map["total_order_BEF"]
        
        
        total_revenue <- map["total_revenue"]
        total_revenue_SHF <- map["total_revenue_SHF"]
        total_revenue_GRF <- map["total_revenue_GRF"]
        total_revenue_GOF <- map["total_revenue_GOF"]
        total_revenue_BEF <- map["total_revenue_BEF"]
      
        percent_SHF <- map["percent_SHF"]
        percent_GRF <- map["percent_GRF"]
        percent_GOF <- map["percent_GOF"]
        percent_BEF <- map["percent_BEF"]
    }
    
    
}

struct FoodAppReportData:Mappable{
    var report_date = ""
    
    var total_order_SHF = 0
    var total_order_GRF = 0
    var total_order_GOF = 0
    var total_order_BEF = 0
    
    var commission_amount_SHF = 0
    var commission_amount_GRF = 0
    var commission_amount_GOF = 0
    var commission_amount_BEF = 0
    
    var order_amount_SHF = 0
    var order_amount_GRF = 0
    var order_amount_GOF = 0
    var order_amount_BEF = 0
    
    
    var total_amount_SHF = 0
    var total_amount_GRF = 0
    var total_amount_GOF = 0
    var total_amount_BEF = 0
    
    init?(map: Map) {}
    
    init(){}
    
    mutating func mapping(map: Map) {
        report_date <- map["report_date"]
        total_order_SHF <- map["total_order_SHF"]
        total_order_GRF <- map["total_order_GRF"]
        total_order_GOF <- map["total_order_GOF"]
        total_order_BEF <- map["total_order_BEF"]
        
        commission_amount_SHF <- map["commission_amount_SHF"]
        commission_amount_GRF <- map["commission_amount_GRF"]
        commission_amount_GOF <- map["commission_amount_GOF"]
        commission_amount_BEF <- map["commission_amount_BEF"]
        
        order_amount_SHF <- map["order_amount_SHF"]
        order_amount_GRF <- map["order_amount_GRF"]
        order_amount_GOF <- map["order_amount_GOF"]
        order_amount_BEF <- map["order_amount_BEF"]
        
        total_amount_SHF <- map["total_amount_SHF"]
        total_amount_GRF <- map["total_amount_GRF"]
        total_amount_GOF <- map["total_amount_GOF"]
        total_amount_BEF <- map["total_amount_BEF"]
        
    }
}
