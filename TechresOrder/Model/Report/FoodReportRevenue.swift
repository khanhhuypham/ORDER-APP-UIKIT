//
//  FoodReportRevenue.swift
//  ORDER
//
//  Created by Kelvin on 05/06/2023.
//

import UIKit
import ObjectMapper

struct FoodReportRevenueData: Mappable {
    var foods: [FoodReportRevenue]?
    var total_original_amount = 0
    var total_amount = 0
    var total_profit_amount = 0
    
    init?(map: Map) {
    }
    init?(){}
    
    mutating func mapping(map: Map) {
        foods <- map["list"]
        total_original_amount <- map["total_original_amount"]
        total_amount <- map["total_amount"]
        total_profit_amount <- map["total_profit_amount"]
    }
}
struct FoodReportRevenueResponse:Mappable{
    var limit = 0
    var data: FoodReportRevenueData?
    var total_record = 0
      
    init?(map: Map) {
    }
    init?(){}
    
    mutating func mapping(map: Map) {
        limit <- map["limit"]
        data <- map["data"]
        total_record <- map["total_record"]
    }
    
}
struct FoodReportRevenue:Mappable{
    var category_id = 0
    var category_name = ""
    var total_amount = 0
    var total_original_amount = 0
    var profit = 0
    var total_profit = 0
    var food_name = ""
    var food_avatar = ""
    var unit_name = ""
    var quantity = 0
      
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        category_id <- map["category_id"]
        category_name <- map["category_name"]
        total_amount <- map["total_amount"]
        total_original_amount <- map["total_original_amount"]
        profit <- map["profit"]
//        profit_ratio <- map["profit_ratio"]
        food_name <- map["food_name"]
        food_avatar <- map["food_avatar"]
        unit_name <- map["unit_name"]
        quantity <- map["quantity"]
    }
    
}
