//
//  FoodUpdateRequest.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import ObjectMapper

struct FoodUpdate: Mappable {
    var order_detail_id = 0
    var quantity: Float = 0
    var note = ""
    var discount_percent = 0
   
    init() {}
    init(order_detail_id:Int,quantity:Float,note:String) {
        self.order_detail_id = order_detail_id
        self.quantity = quantity
        self.note = note
    }
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        order_detail_id <- map["order_detail_id"]
        quantity <- map["quantity"]
        note <- map["note"]
        discount_percent <- map["discount_percent"]
    }
}
