//
//  OtherFoodRequest.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit
import ObjectMapper

struct OtherFoodRequest: Mappable {
    var price = 0
    var quantity:Float = 0.0
    
    var note = ""
    var restaurant_vat_config_id = 0
    var restaurant_kitchen_place_id = 0
    var food_name = ""
    var is_allow_print = 0
    init() {}
    
    init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        price                                      <- map["price"]
        quantity                                      <- map["quantity"]
        note                                      <- map["note"]
        restaurant_vat_config_id                                      <- map["restaurant_vat_config_id"]
        restaurant_kitchen_place_id                                      <- map["restaurant_kitchen_place_id"]
        food_name                                      <- map["food_name"]
        is_allow_print                                      <- map["is_allow_print"]
    }
    
}
