//
//  AreaRevenueReport.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/08/2023.
//

import UIKit
import ObjectMapper

struct AreaRevenueReport:Mappable{
    var reportType = 0
    var dateString = ""
    var areaRevenueReportData = [AreaRevenueReportData]()
    var total_revenue = 0
    var total_revenue_amount = 0
    init?(map: Map) {
    }
    init?(){}
    
    init(reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
    }
    
    mutating func mapping(map: Map) {
        areaRevenueReportData <- map["list"]
        total_revenue <- map["total_revenue"]
        total_revenue_amount <- map["total_revenue_amount"]
    }
    
}

struct AreaRevenueReportData:Mappable{
    var area_id = 0
    var branch_id = 0
    var branch_name = ""
    var phone_number = ""
    var area_name = ""
    var order_count = 0
    var revenue = 0

    

      
    init?(map: Map) {
    }
    init?(){}
    
    mutating func mapping(map: Map) {
        area_id <- map["area_id"]
        branch_id <- map["branch_id"]
        branch_name <- map["branch_name"]
        phone_number <- map["phone_number"]
        area_name <- map["area_name"]
        order_count <- map["order_count"]
        revenue <- map["revenue"]

    }
    
}
