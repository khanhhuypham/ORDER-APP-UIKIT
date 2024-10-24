//
//  Payment.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 04/11/2023.
//

import UIKit
import ObjectMapper


struct Payment {
    var order_id = 0
    var tip_amount:Double = 0
    var bank_amount:Double = 0
    var transfer_amount:Double = 0
    var cash_amount:Double = 0
    var payment_method = 0

    
    init?(map: Map) {}
    init(){}
}

struct PaymentMethod:Mappable {
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



