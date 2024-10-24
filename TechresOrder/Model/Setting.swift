//
//  Setting.swift
//  TechresOrder
//
//  Created by Kelvin on 14/01/2023.
//

import UIKit
import ObjectMapper

struct SettingResponse: Mappable {
    var setting: Setting?
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        setting <- map["data"]
    }
}

struct Setting: Mappable {
    var branch_type: Int = 0
    var branch_type_option = 0
    var service_restaurant_level_id = 0
    var service_restaurant_level_type = 0
    var hour_to_take_report: Int = 3
    var is_have_take_away = DEACTIVE
    var is_enable_membership_card = 0
    var is_hide_total_amount_before_complete_bill: Int = 0
    var is_require_update_customer_slot_in_order = 0
    var branch_info = Branch()
    var is_hidden_payment_detail_in_bill = DEACTIVE
    var is_show_vat_on_items_in_bill = DEACTIVE
    
    var is_enable_buffet = DEACTIVE
    var template_bill_printer_type:Bill_TYPE = .bill3
    var vat_content_on_bill = ""
    var greeting_content_on_bill = ""
    
    
    init?(map: Map) {}

    init?() {
    }

    mutating func mapping(map: Map) {
        branch_type       <- map["branch_type"]
        branch_type_option  <- map["branch_type_option"]
        service_restaurant_level_id <- map["service_restaurant_level_id"]
        service_restaurant_level_type <- map["service_restaurant_level_type"]
        
        is_have_take_away <- map["is_have_take_away"]
        is_enable_membership_card <- map["is_enable_membership_card"]
        is_hide_total_amount_before_complete_bill <- map["is_hide_total_amount_before_complete_bill"]
        
        is_require_update_customer_slot_in_order  <- map["is_require_update_customer_slot_in_order"]
        branch_info  <- map["branch_info"]
        service_restaurant_level_id <- map["service_restaurant_level_id"]
        hour_to_take_report <- map["hour_to_take_report"]
        is_hidden_payment_detail_in_bill <- map["is_hidden_payment_detail_in_bill"]
        is_show_vat_on_items_in_bill <- map["is_show_vat_on_items_in_bill"]
        template_bill_printer_type <- map["template_bill_printer_type"]
        is_enable_buffet <- map["is_enable_buffet"]
        
        vat_content_on_bill <- map["vat_content_on_bill"]
        greeting_content_on_bill <- map["greeting_content_on_bill"]
    }
    
}
