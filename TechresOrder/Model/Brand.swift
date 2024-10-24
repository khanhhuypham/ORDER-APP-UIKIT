//
//  Brand.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import ObjectMapper

struct Brand: Mappable {
    var id = 0
    var status = 0
    var restaurant_id = 0
    var customer_partner_id = 0
    var name = ""
    var address = ""
    var logo_url = ""
    var banner = ""
    var qr_code_checkin = ""
    var description = ""
    var setting = BrandSetting()
    var restaurant_brand_business_types = ""
    var total_branches = 0
    var created_at = ""
    var updated_at = ""
    var service_restaurant_level_id = 0
    var service_restaurant_level_type = 0
    var service_restaurant_level_price = 0
    var is_office = 0
   

    init() {}
    
    init?(map: Map) {
    }
    
    init(id: Int, name:String) {
        self.id = id
        self.name = name
   }
   
   
 

    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        status                                    <- map["status"]
        restaurant_id                                   <- map["restaurant_id"]
        customer_partner_id                                 <- map["customer_partner_id"]
        name                                  <- map["name"]
        address                                  <- map["address"]
        logo_url                      <- map["logo_url"]
        banner                          <- map["banner"]
        qr_code_checkin                         <- map["qr_code_checkin"]
        description                               <- map["description"]
        
        setting                               <- map["setting"]
        restaurant_brand_business_types                               <- map["restaurant_brand_business_types"]
        total_branches                               <- map["total_branches"]
        created_at                               <- map["created_at"]
        updated_at                               <- map["updated_at"]
        service_restaurant_level_id                               <- map["service_restaurant_level_id"]
        service_restaurant_level_type                               <- map["service_restaurant_level_type"]
        service_restaurant_level_price                               <- map["service_restaurant_level_price"]
        
        
        is_office                               <- map["is_office"]
        
        
    }
}
struct BrandSetting: Mappable {
    var branch_type = 3
    var branch_type_option = 1
    var hour_to_take_report = 0
    var is_hide_total_amount_before_complete_bill = 0
    var is_print_bill_logo = 1
    var is_print_bill_on_mobile_app = 0

    var bank_number = ""
    var bank_name = ""
    var bank_account_name = ""
    var template_bill_printer_type = 3


    var payment_type:QRCODE_TYPE = .pay_os
    var is_hidden_payment_detail_in_bill = 0
    var is_show_vat_on_items_in_bill = 0
    var is_enable_buffet = 0

    var maximum_bef_account = 0
    var maximum_shf_account = 0
    var maximum_grf_account = 0
    
    init?(map: Map) {}
    init?() {}
    
    mutating func mapping(map: Map) {
        branch_type <- map["branch_type"]
        branch_type_option <- map["branch_type_option"]

        hour_to_take_report <- map["hour_to_take_report"]
        is_hide_total_amount_before_complete_bill <- map["is_hide_total_amount_before_complete_bill"]
        is_print_bill_logo <- map["is_print_bill_logo"]
        is_print_bill_on_mobile_app <- map["is_print_bill_on_mobile_app"]
        bank_number <- map["bank_number"]
        bank_name <- map["bank_name"]
        bank_account_name <- map["bank_account_name"]
        template_bill_printer_type <- map["template_bill_printer_type"]
        payment_type <- map["payment_type"]
        is_hidden_payment_detail_in_bill <- map["is_hidden_payment_detail_in_bill"]
        is_show_vat_on_items_in_bill <- map["is_show_vat_on_items_in_bill"]
        is_enable_buffet <- map["is_enable_buffet"]
        maximum_bef_account <- map["maximum_bef_account"]
        maximum_shf_account <- map["maximum_shf_account"]
        maximum_grf_account <- map["maximum_grf_account"]
    }
}
