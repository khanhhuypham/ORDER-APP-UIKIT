//
//  FoodRequest.swift
//  TechresOrder
//
//  Created by Kelvin on 17/01/2023.
//

import UIKit
import ObjectMapper

struct FoodRequest: Mappable {
    var id = 0
    var quantity:Float = 0
    
    var note = ""
    var is_use_point = 0
    var customer_order_detail_id = 0
    var discount_percent = 0
    var addition_foods = [FoodAddition]()
    var buy_one_get_one_foods = [FoodAddition]()
    
    init() {}
    
    init?(map: Map) {}
 

    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        quantity                                    <- map["quantity"]
        note                                  <- map["note"]
        is_use_point                                    <- map["is_use_point"]
        customer_order_detail_id                                   <- map["customer_order_detail_id"]
        addition_foods <- map["addition_foods"]
        buy_one_get_one_foods                                  <- map["buy_one_get_one_foods"]
        discount_percent <- map["discount_percent"]

    }
    
}
