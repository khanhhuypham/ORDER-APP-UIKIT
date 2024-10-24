//
//  TechresShopDevice.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit
import ObjectMapper



struct TechresDeviceResponse: Mappable {
    var limit = 0
    var list:[TechresDevice] = []
    var total_record = 0
    
    init?(map: Map) {
    }
    init?() {}
    
    mutating func mapping(map: Map) {
        limit <- map["limit"]
        list <- map["list"]
        total_record <- map["total_record"]
    }
}

struct TechresDevice: Mappable {
    var id = 0
    var images:[String] = []
    var description = ""
    var slug = ""
    var product_category_id = 0
    var vat_percent = 0
    var product_category_type = 0
    var product_category_type_name = ""
    var name = ""
    var short_description = ""
    var specical_properties = ""
    var price = 0
    var warranty_duration_by_day = 0
    var is_hidden = 0
    var inventory = 0
    var created_at = ""
    var updated_at = ""
    var quantity = 0
    
    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        images <- map["images"]
        description <- map["description"]
        slug <- map["slug"]
        product_category_id <- map["product_category_id"]
        vat_percent <- map["vat_percent"]
        product_category_type <- map["product_category_type"]
        product_category_type_name <- map["product_category_type_name"]
        name <- map["name"]
        short_description <- map["short_description"]
        specical_properties <- map["specical_properties"]
        price <- map["price"]
        warranty_duration_by_day <- map["warranty_duration_by_day"]
        is_hidden <- map["is_hidden"]
        inventory <- map["inventory"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
    
    
}
