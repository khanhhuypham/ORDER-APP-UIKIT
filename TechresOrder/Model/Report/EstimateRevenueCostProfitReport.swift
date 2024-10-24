////
////  RevenueCostProfitReport.swift
////  TECHRES-ORDER
////
////  Created by Pham Khanh Huy on 14/09/2023.
////
//
//import UIKit
//import ObjectMapper
//
//struct EstimateRevenueCostProfitReport:Mappable{
//    var reportType = 0
//    var dateString = ""
//    var reportData:[RevenueCostProfitReportData] = []
//    var rate_total_cost = 0
//    var rate_total_profit:Float = 0.0
//    var rate_total_revenue = 0
//    var total_addition_fee_amount = 0
//    var total_amount_salary = 0
//    var total_basic_salary_estimate = 0
//    var total_cost = 0
//    var total_profit = 0
//    var total_recuring_cost = 0
//    var total_restaurant_debt_amount = 0
//    var total_revenue = 0
//    var total_salary_cost_amount = 0
//    var total_vat_amount = 0
//    
//    init?(map: Map) {
//    }
//    init?(){}
//    
//    init(reportType:Int, dateString:String){
//        self.reportType = reportType
//        self.dateString = dateString
//    }
//    
//    
//    mutating func mapping(map: Map) {
//        reportData <- map["list"]
//        rate_total_cost <- map["rate_total_cost"]
//        rate_total_profit <- map["rate_total_profit"]
//        rate_total_revenue <- map["rate_total_revenue"]
//        total_addition_fee_amount <- map["total_addition_fee_amount"]
//        total_amount_salary <- map["total_amount_salary"]
//        total_basic_salary_estimate <- map["total_basic_salary_estimate"]
//        total_cost <- map["total_cost"]
//        total_profit <- map["total_profit"]
//        total_recuring_cost <- map["total_recuring_cost"]
//        total_restaurant_debt_amount <- map["total_restaurant_debt_amount"]
//        total_revenue <- map["total_revenue"]
//        total_salary_cost_amount <- map["total_salary_cost_amount"]
//        total_vat_amount <- map["total_vat_amount"]
//    }
//    
//}
//
//struct RevenueCostProfitReportData:Mappable{
//    var addition_fee_amount = 0
//    var report_time = ""
//    var restaurant_debt_amount = 0
//    var total_cost = 0
//    var total_profit = 0
//    var total_recuring_average_cost = 0
//    var total_revenue = 0
//    var total_salary_cost = 0
//    var vat_amount = 0
//      
//    init?(map: Map) {
//    }
//    init?(){}
//    
//    mutating func mapping(map: Map) {
//        addition_fee_amount <- map["addition_fee_amount"]
//        report_time <- map["report_time"]
//        restaurant_debt_amount <- map["restaurant_debt_amount"]
//        total_cost <- map["total_cost"]
//        total_profit <- map["total_profit"]
//        total_recuring_average_cost <- map["total_recuring_average_cost"]
//        total_revenue <- map["total_revenue"]
//        total_salary_cost <- map["total_salary_cost"]
//        vat_amount <- map["vat_amount"]
//
//    }
//    
//}
