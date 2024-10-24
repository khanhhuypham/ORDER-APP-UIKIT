//
//  OrderReportDaily.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 04/02/2023.
//

import UIKit

import ObjectMapper

struct DailyOrderReport:Mappable {
    var reportType = 0
    var dateString = ""
    var cash_amount = 0
    var bank_amount = 0
    var transfer_amount = 0
    var total_amount = 0
    var revenue_paid = 0
    var revenue_serving = 0
    var customer_slot_served = 0
    var customer_slot_serving = 0
    var order_served = 0
    var order_serving = 0
    var deposit_amount = 0
    
    init() {}
    init?(map: Map) {}
    
    init(reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
    }

    mutating func mapping(map: Map) {
        cash_amount                                      <- map["cash_amount"]
        bank_amount                                    <- map["bank_amount"]
        transfer_amount                                   <- map["transfer_amount"]
        total_amount                                 <- map["total_amount"]
        revenue_paid                                  <- map["revenue_paid"]
        revenue_serving                      <- map["revenue_serving"]
        customer_slot_served                          <- map["customer_slot_served"]
        customer_slot_serving                         <- map["customer_slot_serving"]
        order_served                         <- map["order_served"]
        order_serving                         <- map["order_serving"]
        deposit_amount          <- map["deposit_amount"]
    }
    
}
