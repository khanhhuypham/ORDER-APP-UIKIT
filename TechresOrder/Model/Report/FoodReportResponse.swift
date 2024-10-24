//
//  FoodReportResponse.swift
//  ORDER
//
//  Created by Kelvin on 05/06/2023.
//

import UIKit
import ObjectMapper

struct FoodReportData: Mappable {
    var filterType:Int = 0
    var reportType:Int = 0
    var dateString = ""
    var foods:[FoodReport] = []
    var total_original_amount = 0
    var total_amount:Double = 0
    var total_profit_amount = 0
    
    init?(map: Map) {
    }
    init?(){
    }
    
    init(reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
    }
    
    
    mutating func mapping(map: Map) {
        foods <- map["list"]
        total_original_amount <- map["total_original_amount"]
        total_amount <- map["total_amount"]
        total_profit_amount <- map["total_profit_amount"]
    }
}
struct FoodReportResponse:Mappable{
    var limit: Int?
    var data : FoodReportData?
    var total_record:Int?
      
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        limit <- map["limit"]
        data <- map["data"]
        total_record <- map["total_record"]
    }
    
}
struct FoodReport:Mappable{
    var food_id: Int = 0
    var food_name: String = ""
    var food_avatar: String = ""
    var food_avatar_thump: String = ""
    var category_id: Int = 0
    var category_name: String = ""
    var category_type: Int = 0
    var unit_name: String = ""
    var quantity: Float = 0
    var original_price: Int = 0
    var price: Int = 0
    
    var total_original_amount: Int = 0
    var total_amount: Int = 0
    var profit: Int = 0
    var profit_ratio: Int = 0
    var profit_original_ratio: Int = 0
    var total_profit: Int = 0
    
    init?(map: Map) {
    }
    init?() {
    }

    
    mutating func mapping(map: Map) {
        food_id <- map["food_id"]
        food_name <- map["food_name"]
        food_avatar <- map["food_avatar"]
        food_avatar_thump <- map["food_avatar_thump"]
        category_id <- map["category_id"]
        category_name <- map["category_name"]
        category_type <- map["category_type"]
        unit_name <- map["unit_name"]
        quantity <- map["quantity"]
        original_price <- map["original_price"]
        price <- map["price"]
        total_original_amount <- map["total_original_amount"]
        total_amount <- map["total_amount"]
        profit <- map["profit"]
        profit_ratio <- map["profit_ratio"]
        profit_original_ratio <- map["profit_original_ratio"]
        total_profit <- map["total_profit"]
    }
    
}
