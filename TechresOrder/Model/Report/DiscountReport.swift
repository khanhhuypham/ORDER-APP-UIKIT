//
//  DiscountReport.swift
//  ORDER
//
//  Created by Pham Khanh Huy on 30/06/2023.
//

import UIKit
import ObjectMapper

struct DiscountReport:Mappable{
    var reportType = 0
    var dateString = ""
    var discountReportData = [DiscountReportData]()
    var total_amount = 0
    var total_order_quantity = 0
    
    init?(map: Map) {
    }
    init?(){}
    
    init(reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
    }
    
    mutating func mapping(map: Map) {
        discountReportData <- map["list"]
        total_amount <- map["total_amount"]
        total_order_quantity <- map["total_order_quantity"]
    }
    
}

struct DiscountReportData:Mappable{
    var order_quantity = 0
    var report_time = ""
    var total_amount = 0
    var total_amount_vat = 0
    
    init?(){}
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        order_quantity <- map["order_quantity"]
        report_time <- map["report_time"]
        total_amount <- map["total_amount"]
        total_amount_vat <- map["total_amount_vat"]
    }
    
}
