//
//  TableRevenueReport.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/08/2023.
//

import UIKit
import ObjectMapper
struct TableRevenueReport:Mappable{
    var reportType = 0
    var dateString = ""
    var tableRevenueReportData = [TableRevenueReportData]()
    var total_revenue = 0
    
    init?(map: Map) {
    }
    init?(){}
    
    
    init(reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
    }

    
    mutating func mapping(map: Map) {
        tableRevenueReportData <- map["list"]
        total_revenue <- map["total_revenue"]
    }
    
}

struct TableRevenueReportData:Mappable{
    var table_id = 0
    var table_name = ""
    var area_id = 0
    var area_name = ""
    var order_count = 0
    var revenue = 0

    

      
    init?(map: Map) {
    }
    init?(){}
    
    mutating func mapping(map: Map) {
        table_id <- map["table_id"]
        table_name <- map["table_name"]
        area_id <- map["area_id"]
        area_name <- map["area_name"]

        order_count <- map["order_count"]
        revenue <- map["revenue"]

    }
    
}
