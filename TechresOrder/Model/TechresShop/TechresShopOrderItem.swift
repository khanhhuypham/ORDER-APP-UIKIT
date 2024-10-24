//
//  TechresShopOrderItem.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/09/2024.
//

import UIKit
import ObjectMapper


struct TechresShopOrderItem: Mappable {
    var product_id = 0
    var product_name = ""
    var product_category_id = 0
    var product_category_name = ""
    var product_category_type = 0
    var product_category_type_name = ""
    var price = 0
    var quantity = 0
    var amount = 0
    var total_amount = 0
    var warranty_duration_by_day = 0
    var vat_percent = 0
    var vat_amount = 0
    var discount_percent = 0
    var discount_amount = 0
    var product_discount_percent = 0
    var product_discount_amount = 0
    
    init?(map: Map) {
    }
    init?() {}
    
    mutating func mapping(map: Map) {
        product_id <- map["product_id"]
        product_name <- map["product_name"]
        product_category_id <- map["product_category_id"]
        product_category_name <- map["product_category_name"]
        product_category_type <- map["product_category_type"]
        product_category_type_name <- map["product_category_type_name"]
        price <- map["price"]
        quantity <- map["quantity"]
        amount <- map["amount"]
        total_amount <- map["total_amount"]
        warranty_duration_by_day <- map["warranty_duration_by_day"]
        vat_percent <- map["vat_percent"]
        vat_amount <- map["vat_amount"]
        discount_percent <- map["discount_percent"]
        discount_amount <- map["discount_amount"]
        product_discount_percent <- map["product_discount_percent"]
        product_discount_amount <- map["product_discount_amount"]
    }
}
