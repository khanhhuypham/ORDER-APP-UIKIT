//
//  ExtraCharge.swift
//  TechresOrder
//
//  Created by Kelvin on 14/01/2023.
//

import UIKit
import ObjectMapper

struct ExtraCharge: Mappable {
    var id = 0
    var name = ""
    var description = ""
    var price:Float=0
    var quantity = 0

    init?(map: Map) {}
    init() {}
    
    init(id:Int, name:String, price:Float, quantity:Int, description:String) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.description = description
    }

    

   mutating func mapping(map: Map) {
       id                                                  <- map["id"]
       name                                                  <- map["name"]
       description                                                  <- map["description"]
       price                                                  <- map["price"]
       quantity                                                  <- map["quantity"]
   }
    
    
}
