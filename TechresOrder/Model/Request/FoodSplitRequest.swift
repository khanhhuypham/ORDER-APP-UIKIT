//
//  FoodSplitRequest.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import ObjectMapper

struct FoodSplitRequest: Mappable {
    var order_detail_id = 0
    var quantity: Float = 0
   
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        order_detail_id <- map["order_detail_id"]
        quantity <- map["quantity"]
    }
}

struct ExtraFoodSplitRequest: Mappable {
    var extra_charge_id = 0
    var quantity: Float = 0
   
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        extra_charge_id <- map["extra_charge_id"]
        quantity <- map["quantity"]
    }
}
