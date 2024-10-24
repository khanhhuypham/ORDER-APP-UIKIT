//
//  DiscountOfFoodAppPartner.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/08/2024.
//

import UIKit
import ObjectMapper


struct DiscountOfFoodAppPartner: Mappable {
    var id = 0
    var channel_order_food_id:Int = 0
    var channel_order_food_name = ""
    var channel_order_food_code = ""
    var percent:Int = 0
    
    
    var channel_order_food_token_id = 0
    var channel_order_food_token_name = ""
    var username = ""
    
    
    init?(map: Map) {}
    init(){}
        
    mutating func mapping(map: Map) {
     
        id  <- map["id"]
        channel_order_food_id  <- map["channel_order_food_id"]
        channel_order_food_name  <- map["channel_order_food_name"]
        channel_order_food_code  <- map["channel_order_food_code"]
        percent  <- map["percent"]
        
        channel_order_food_token_id  <- map["channel_order_food_token_id"]
        channel_order_food_token_name  <- map["channel_order_food_token_name"]
        username  <- map["username"]
    
    }
}
