////
////  SumRevenueCostProfitReport.swift
////  TECHRES-ORDER
////
////  Created by Pham Khanh Huy on 14/09/2023.
////
//
//import UIKit
//import ObjectMapper
//struct SumRevenueCostProfitReport:Mappable{
//    
//    var reportType = 0
//    var dateString = ""
//    var reportData:[RevenueCostProfitReportData] = []
//  
//    var rate_total_addition_fee_amount_other:Float = 0
//    var rate_total_amount_basic_salary:Float = 0
//    var rate_total_amount_different:Float = 0
//    var rate_total_amount_goods:Float = 0
//    var rate_total_amount_internal:Float = 0
//    var rate_total_amount_inventory:Float = 0
//    var rate_total_amount_material:Float = 0
//    var rate_total_amount_orther:Float = 0
//    var rate_total_amount_salary:Float = 0
//    var rate_total_another_material_inventory_amount:Float = 0
//    var rate_total_bar_inventory_amount:Float = 0
//    var rate_total_basic_salary_estimate:Float = 0
//    var rate_total_cost:Float = 0
//    var rate_total_debt_amount:Float = 0
//    var rate_total_employee_food_inventory_amount:Float = 0
//    var rate_total_employee_sale_inventory_amount:Float = 0
//    var rate_total_funds:Float = 0
//    var rate_total_good_inventory_amount:Float = 0
//    var rate_total_gross_profit:Float = 0
//    var rate_total_internal_inventory_amount:Float = 0
//    var rate_total_kitchen_inventory_amount:Float = 0
//    var rate_total_material_inventory_amount:Float = 0
//    var rate_total_profit:Float = 0
//    var rate_total_recuring_cost:Float = 0
//    var rate_total_restaurant_debt_amount:Float = 0
//    var rate_total_revenue:Float = 0
//    var rate_total_salary_cost_amount:Float = 0
//    var total_addition_fee_amount_other = 0
//    var total_amount_basic_salary = 0
//    var total_amount_different = 0
//    var total_amount_goods = 0
//    var total_amount_internal = 0
//    var total_amount_inventory = 0
//    var total_amount_material = 0
//    var total_amount_orther = 0
//    var total_amount_salary = 0
//    var total_another_material_inventory_amount = 0
//    var total_bar_inventory_amount = 0
//    var total_basic_salary_estimate = 0
//    var total_cost = 0
//    var total_debt_amount = 0
//    var total_employee_food_inventory_amount = 0
//    var total_employee_sale_inventory_amount = 0
//    var total_funds = 0
//    var total_good_inventory_amount = 0
//    var total_gross_profit = 0
//    var total_internal_inventory_amount = 0
//    var total_kitchen_inventory_amount = 0
//    var total_material_inventory_amount = 0
//    var total_profit = 0
//    var total_recuring_cost = 0
//    var total_restaurant_debt_amount = 0
//    var total_revenue = 0
//    var total_salary_cost_amount = 0
//    
//    
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
//    mutating func mapping(map: Map) {
//        reportData <- map["list"]
//        rate_total_addition_fee_amount_other <- map["rate_total_addition_fee_amount_other"]
//        rate_total_amount_basic_salary <- map["rate_total_amount_basic_salary"]
//        rate_total_amount_different <- map["rate_total_amount_different"]
//        rate_total_amount_goods <- map["rate_total_amount_goods"]
//        rate_total_amount_internal <- map["rate_total_amount_internal"]
//        rate_total_amount_inventory <- map["rate_total_amount_inventory"]
//        rate_total_amount_material <- map["rate_total_amount_material"]
//        rate_total_amount_orther <- map["rate_total_amount_orther"]
//        rate_total_amount_salary <- map["rate_total_amount_salary"]
//        rate_total_another_material_inventory_amount <- map["rate_total_another_material_inventory_amount"]
//        rate_total_bar_inventory_amount <- map["rate_total_bar_inventory_amount"]
//        rate_total_basic_salary_estimate <- map["rate_total_basic_salary_estimate"]
//        rate_total_cost <- map["rate_total_cost"]
//        rate_total_debt_amount <- map["rate_total_debt_amount"]
//        rate_total_employee_food_inventory_amount <- map["rate_total_employee_food_inventory_amount"]
//        rate_total_employee_sale_inventory_amount <- map["rate_total_employee_sale_inventory_amount"]
//        rate_total_funds <- map["rate_total_funds"]
//        rate_total_good_inventory_amount <- map["rate_total_good_inventory_amount"]
//        rate_total_gross_profit <- map["rate_total_gross_profit"]
//        rate_total_internal_inventory_amount <- map["rate_total_internal_inventory_amount"]
//        rate_total_kitchen_inventory_amount <- map["rate_total_kitchen_inventory_amount"]
//        rate_total_material_inventory_amount <- map["rate_total_material_inventory_amount"]
//        rate_total_profit <- map["rate_total_profit"]
//        rate_total_recuring_cost <- map["rate_total_recuring_cost"]
//        rate_total_restaurant_debt_amount <- map["rate_total_restaurant_debt_amount"]
//        rate_total_revenue <- map["rate_total_revenue"]
//        rate_total_salary_cost_amount <- map["rate_total_salary_cost_amount"]
//        total_addition_fee_amount_other <- map["total_addition_fee_amount_other"]
//        total_amount_basic_salary <- map["total_amount_basic_salary"]
//        total_amount_different <- map["total_amount_different"]
//        total_amount_goods <- map["total_amount_goods"]
//        total_amount_internal <- map["total_amount_internal"]
//        total_amount_inventory <- map["total_amount_inventory"]
//        total_amount_material <- map["total_amount_material"]
//        total_amount_orther <- map["total_amount_orther"]
//        total_amount_salary <- map["total_amount_salary"]
//        total_another_material_inventory_amount <- map["total_another_material_inventory_amount"]
//        total_bar_inventory_amount <- map["total_bar_inventory_amount"]
//        total_basic_salary_estimate <- map["total_basic_salary_estimate"]
//        total_cost <- map["total_cost"]
//        total_debt_amount <- map["total_debt_amount"]
//        total_employee_food_inventory_amount <- map["total_employee_food_inventory_amount"]
//        total_employee_sale_inventory_amount <- map["total_employee_sale_inventory_amount"]
//        total_funds <- map["total_funds"]
//        total_good_inventory_amount <- map["total_good_inventory_amount"]
//        total_gross_profit <- map["total_gross_profit"]
//        total_internal_inventory_amount <- map["total_internal_inventory_amount"]
//        total_kitchen_inventory_amount <- map["total_kitchen_inventory_amount"]
//        total_material_inventory_amount <- map["total_material_inventory_amount"]
//        total_profit <- map["total_profit"]
//        total_recuring_cost <- map["total_recuring_cost"]
//        total_restaurant_debt_amount <- map["total_restaurant_debt_amount"]
//        total_revenue <- map["total_revenue"]
//        total_salary_cost_amount <- map["total_salary_cost_amount"]
//    }
//    
//}
