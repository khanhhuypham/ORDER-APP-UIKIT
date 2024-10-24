//
//  DetailVAT.swift
//  Techres - Order
//
//  Created by kelvin on 15/04/2022.
//  Copyright © 2022 vn.techres.sale. All rights reserved.
//

import UIKit
import ObjectMapper

class DetailVAT: Mappable {
    var id = 0
    var name = ""
    var price = 0.0
    var quantity = 0.0
    var vat_percent = 0.0
    var vat_amount = 0.0
    var discount_percent = 0.0
    var discount_amount = 0.0
    var total_price = 0.0
    
    init() {}
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        price <- map["price"]
        quantity <- map["quantity"]
        vat_percent <- map["vat_percent"]
        vat_amount <- map["vat_amount"]
        
        discount_percent <- map["discount_percent"]
        discount_amount <- map["discount_amount"]
        total_price <- map["total_price"]
    }
}

class VATOrder: Mappable {
    var vat_percent = 0.0
    var vat_amount = 0.0
    var order_details = [DetailVAT]()
    
    init() {}
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        vat_percent <- map["vat_percent"]
        vat_amount <- map["vat_amount"]
        order_details <- map["order_details"]
    }
}




struct Vat: Mappable {
    var id = 0
    var vat_config_id = 0
    var vat_config_name = ""
    var restaurant_id = 0
    var percent = 0.0
    var admin_percent = 0.0
    var created_at = ""
    var updated_at = ""
    var is_updated = 0
    var is_actived = 0

    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
        id                                      <- map["id"]
        vat_config_id                                    <- map["vat_config_id"]
        vat_config_name                             <- map["vat_config_name"]
        restaurant_id                           <- map["restaurant_id"]
        percent                                  <- map["percent"]
        admin_percent                               <- map["admin_percent"]
        created_at                              <- map["created_at"]
        updated_at                              <- map["updated_at"]
        is_updated <- map["is_updated"]
        is_actived <- map["is_actived"]
    }

}
