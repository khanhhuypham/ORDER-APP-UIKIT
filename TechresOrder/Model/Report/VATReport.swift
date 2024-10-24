//
//  VATReport.swift
//  ORDER
//
//  Created by Pham Khanh Huy on 30/06/2023.
//

import UIKit
import ObjectMapper



struct VATReport:Mappable{
    var reportType = 0
    var dateString = ""
    var vatReportData = [VATReportData]()
    var total_amount = 0
    var total_order_quantity = 0
    var transfer_amount = 0
    var vat_amount = 0
    
    
    init?(){}
    init?(map: Map) {
    }
    
    init(reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
    }
    
    mutating func mapping(map: Map) {
        vatReportData <- map["list"]
        total_amount <- map["total_amount"]
        total_order_quantity <- map["total_order_quantity"]
        transfer_amount <- map["transfer_amount"]
        vat_amount <- map["vat_amount"]
    }
    
}

struct VATReportData:Mappable{
    var id = 0
    var amount = 0
    var bank_amount = 0
    var cash_amount = 0
    var customer_slot_number = 0
    var discount_amount = 0
    var report_time = ""
    var order_quantity = 0
    var total_amount = 0
    var transfer_amount = 0
    var vat_amount = 0
 
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        amount <- map["amount"]
        bank_amount <- map["bank_amount"]
        cash_amount <- map["cash_amount"]
        customer_slot_number <- map["customer_slot_number"]
        discount_amount <- map["discount_amount"]
        report_time <- map["report_time"]
        order_quantity <- map["order_quantity"]
        total_amount <- map["total_amount"]
        transfer_amount <- map["transfer_amount"]
        vat_amount <- map["vat_amount"]
    }
    
}
