//
//  SaleReport.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 14/09/2023.
//

import UIKit
import ObjectMapper

struct SaleReport:Mappable{

    var reportType = 0
    var dateString = ""
    var fromDate = ""
    var saleReportData:[SaleReportData] = []
    var total_revenue = 0
    var total_revenue_without_vat = 0
    var total_vat_amount = 0
    
 
    init?(map: Map) {
    }
    
    init?(){}
    
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
        saleReportData <- map["list"]
        total_revenue <- map["total_revenue"]
        total_revenue_without_vat <- map["total_revenue_without_vat"]
        total_vat_amount <- map["total_vat_amount"]
    }
    
}

struct SaleReportData:Mappable{
    var branch_id = 0
    var report_time = ""
    var restaurant_brand_id = 0
    var restaurant_id = 0
    var total_order = 0
    var total_revenue = 0
    var total_revenue_without_vat = 0
    var total_vat_amount = 0




      
    init?(map: Map) {
    }
    init?(){}
    
    mutating func mapping(map: Map) {
        branch_id <- map["branch_id"]
        report_time <- map["report_time"]
        restaurant_brand_id <- map["restaurant_brand_id"]
        restaurant_id <- map["restaurant_id"]
        total_order <- map["total_order"]
        total_revenue <- map["total_revenue"]
        total_revenue_without_vat <- map["total_revenue_without_vat"]
        total_vat_amount <- map["total_vat_amount"]

    }
    
}
