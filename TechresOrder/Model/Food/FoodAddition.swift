//
//  FoodAddition.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/01/2024.
//

import UIKit
import ObjectMapper



struct FoodAddition : Mappable {
  
    var id = 0
    var name = ""
    var price = 0
    var avatar = ""
    var quantity = 0
    var combo_quantity = 0
    var weight:Float = 0
    var is_selected = 0
    var is_out_stock = 0
    var price_with_temporary = 0
    var temporary_price = 0
    var unit_type = ""
    init(name:String,quantity:Int){
        self.name = name
        self.quantity = quantity
    }
    
    init(){}
    
    init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        avatar                                  <- map["avatar"]
        name                                    <- map["name"]
        price                                   <- map["price"]
        quantity                                <- map["quantity"]
        combo_quantity                          <- map["combo_quantity"]
        is_selected                                <- map["is_selected"]
        is_out_stock                                      <- map["is_out_stock"]
        price_with_temporary                <- map["price_with_temporary"]
        temporary_price <- map["temporary_price"]
        unit_type <- map["unit_type"]
    }
    
    
    
    
    mutating func select() -> Void {
        is_selected = ACTIVE
        if quantity <= 0 && is_selected == ACTIVE{
            quantity = 1
        }
    }
    
    
    mutating func deSelect() -> Void {
        is_selected = DEACTIVE
        
         if is_selected == DEACTIVE{
            quantity = 0
        }
    }
    
    
    mutating func setQuantity(quantity:Int) -> Void {
        self.quantity = quantity
        self.quantity = quantity > 0 ? quantity : 0
        is_selected = quantity > 0 ? ACTIVE : DEACTIVE
    }

    
    
}




