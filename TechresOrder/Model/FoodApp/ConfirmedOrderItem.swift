//
//  ConfirmedOrderItem.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/09/2024.
//

import UIKit
import ObjectMapper


struct refresChannelOrder: Mappable {
    var branch_id = 0
    var restaurant_id = 0
    var total_revenue_SHF = 0
    var channel_orders:[ChannelOrder] = []
    
    init?(map: Map) {}
    
    init(){}
    
    mutating func mapping(map: Map) {
        branch_id <- map["list"]
        restaurant_id <- map["total_revenue_SHF"]
        total_revenue_SHF <- map["total_revenue_SHF"]
        channel_orders <- map["channel_orders"]
    }
    
}

struct ChannelOrder: Mappable {
    var id = 0
    var channel_order_id = 0
    var channel_order_food_id = 0
    var channel_order_code = 0
    
    init?(map: Map) {}
    
    init(){}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        channel_order_id <- map["channel_order_id"]
        channel_order_food_id <- map["channel_order_food_id"]
        channel_order_code <- map["channel_order_code"]
    }
    
}

