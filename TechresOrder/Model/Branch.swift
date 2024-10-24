//
//  Branch.swift
//  TechresOrder
//
//  Created by Kelvin on 14/01/2023.
//

import UIKit
import ObjectMapper

struct Branch: Mappable {
    var id = 0
    var name = ""
    var phone = ""
    var address = ""
    var status = 0
    var is_use_fingerprint = 0
    var is_enable_checkin = DEACTIVE
    var qr_code_checkin = ""
    var avatar = ""
    var is_office = 0
  
    var city_id = 0
    var city_name = ""
    var district_id = 0
    var district_name = ""
    var ward_id = 0
    var ward_name = ""
    var street_name = ""
    var address_full_text = ""
    var restaurant_brand_id = -1
    var branch_office_id = 0
    var country_name = ""
    var lng = ""
    var lat = ""
    var address_note = ""
    var image_logo = ""
    var banner = ""
    
    var image_logo_url = ""
    var banner_image_url = ""
    var is_enable_app_food = DEACTIVE
    
    var setting:BranchSetting = BranchSetting()
    
    init() {}
    
    init?(map: Map) {}
    

    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        name                                    <- map["name"]
        phone                                   <- map["phone"]
        address                                 <- map["address"]
        status                                  <- map["status"]
        avatar                                  <- map["avatar"]
        is_use_fingerprint                      <- map["is_use_fingerprint"]
        is_enable_checkin                          <- map["is_enable_checkin"]
        qr_code_checkin                         <- map["qr_code_checkin"]
        is_office                               <- map["is_office"]

        city_id <- map["city_id"]
        city_name <- map["city_name"]
        district_id <- map["district_id"]
        district_name <- map["district_name"]
        ward_id <- map["ward_id"]
        ward_name <- map["ward_name"]
        street_name <- map["street_name"]
        address_full_text <- map["address_full_text"]
        restaurant_brand_id <- map["restaurant_brand_id"]
        branch_office_id <- map["branch_office_id"]
        country_name <- map["country_name"]
        lng <- map["lng"]
        lat <- map["lat"]

        address_note <- map["address_note"]

        image_logo <- map["image_logo"]
        banner <- map["banner"]

        image_logo_url <- map["image_logo_url"]
        banner_image_url <- map["banner_image_url"]

        is_enable_app_food <- map["is_enable_app_food"]
        setting <- map["setting"]
    }
}



struct BranchSetting:Mappable {
    var is_apply_only_cash_amount_payment_method = DEACTIVE
    var is_enable_send_to_kitchen_request = DEACTIVE
    var is_enable_food_court = DEACTIVE
    var is_hidden_payment_detail_in_bill = DEACTIVE
    var is_show_vat_on_items_in_bill = DEACTIVE
    var is_enable_checkin = DEACTIVE
    var vat_content_on_bill = ""
    var greeting_content_on_bill = ""
    var is_enable_app_food = DEACTIVE
    
    var maximum_bef_slot = 0
    var maximum_shf_slot = 0
    var maximum_grf_slot = 0
    
    

    init?(map: Map) {}
    init(){}
    
    mutating func mapping(map: Map) {
        is_apply_only_cash_amount_payment_method <- map["is_apply_only_cash_amount_payment_method"]
        is_enable_send_to_kitchen_request <- map["is_enable_send_to_kitchen_request"]
        is_enable_food_court <- map["is_enable_food_court"]
        is_hidden_payment_detail_in_bill <- map["is_hidden_payment_detail_in_bill"]
        is_show_vat_on_items_in_bill <- map["is_show_vat_on_items_in_bill"]
        is_enable_checkin <- map["is_enable_checkin"]
        vat_content_on_bill <- map["vat_content_on_bill"]
        greeting_content_on_bill <- map["greeting_content_on_bill"]
        is_enable_app_food <- map["is_enable_app_food"]
        
        maximum_bef_slot <- map["maximum_bef_slot"]
        
        maximum_shf_slot <- map["maximum_shf_slot"]
        
        maximum_grf_slot <- map["maximum_grf_slot"]
    }
}



