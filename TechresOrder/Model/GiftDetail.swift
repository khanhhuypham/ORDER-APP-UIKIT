//
//  GiftDetail.swift
//  ORDER
//
//  Created by Kelvin on 02/06/2023.
//

import UIKit
import ObjectMapper

struct GiftDetail: Mappable {
    var id = 0
    var customer_id = 0
    var customer_name = ""

    var customer_phone = ""

    var restaurant_id = 0

    var restaurant_name = ""
    var restaurant_avatar = ""
    var restaurant_banner = ""
    var restaurant_brand_id = 0
    var restaurant_brand_name = ""
    var branch_ids = [Int]()
    var branches = [Branch]()

    var restaurant_gift_id = 0
    var restaurant_gift_object_value = 0

    var restaurant_gift_object_quantity = 0
    var restaurant_gift_type = 0
    var name = ""
    var description = ""
    var is_opened = 0
    var expire_at = ""
    var is_expired = ""
    var is_used = 0
    var image_url = ""
    var banner_url = ""
    var restaurant_gift_image_url = ""

    var restaurant_gift_banner_url = ""
    var restaurant_gift_content = ""
    var restaurant_gift_use_guide = ""
    var restaurant_gift_term = ""
    var restaurant_day_of_weeks = [Int]()
    var restaurant_from_hour = 0
    var restaurant_to_hour = 0
    var created_at = ""
    var foods = [Food]()
    

    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        id                                                                  <- map["id"]
        customer_id                                                           <- map["customer_id"]
        name                                                           <- map["name"]
        customer_name                                                                <- map["customer_name"]
        customer_phone                                                                  <- map["customer_phone"]
        restaurant_id                                                           <- map["restaurant_id"]
        restaurant_name                                                                <- map["restaurant_name"]
        restaurant_avatar                                                                  <- map["restaurant_avatar"]
        restaurant_banner                                                           <- map["restaurant_banner"]
        restaurant_brand_id                                                                <- map["restaurant_brand_id"]
        restaurant_brand_name                                                                  <- map["restaurant_brand_name"]
        branch_ids                                                           <- map["branch_ids"]
        branches                                                                <- map["branches"]
        restaurant_gift_id                                                                  <- map["restaurant_gift_id"]
        restaurant_gift_object_value                                                           <- map["restaurant_gift_object_value"]
        restaurant_gift_object_quantity                                                                <- map["restaurant_gift_object_quantity"]
        restaurant_gift_type                                                                  <- map["restaurant_gift_type"]
        description                                                           <- map["description"]
        is_opened                                                                <- map["is_opened"]
        expire_at                                                                  <- map["expire_at"]
        expire_at                                                           <- map["expire_at"]
        is_expired                                                                <- map["is_expired"]
        is_used                                                                  <- map["is_used"]
        expire_at                                                           <- map["expire_at"]
        image_url                                                                <- map["image_url"]
        banner_url                                                                  <- map["banner_url"]
        restaurant_gift_image_url                                                           <- map["restaurant_gift_image_url"]
        restaurant_gift_banner_url                                                                <- map["restaurant_gift_banner_url"]
        
        restaurant_gift_content                                                                <- map["restaurant_gift_content"]
        restaurant_gift_use_guide                                                                <- map["restaurant_gift_use_guide"]
        restaurant_gift_term                                                                <- map["restaurant_gift_term"]
        restaurant_day_of_weeks                                                                <- map["restaurant_day_of_weeks"]
        restaurant_from_hour                                                                <- map["restaurant_from_hour"]
        restaurant_to_hour                                                                <- map["restaurant_to_hour"]
        created_at                                                                <- map["created_at"]
       
        
        foods                                           <- map["foods"]
    }
}
