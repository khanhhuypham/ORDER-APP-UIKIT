//
//  Order.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit
import ObjectMapper

struct OrderStatistic: Mappable {
    var amount = 0
    var vat_amount = 0
    var discount_amount = 0
    var total_amount = 0
    var membership_accumulate_point_used = 0
    
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        amount <- map["amount"]
        vat_amount <- map["vat_amount"]
        discount_amount <- map["discount_amount"]
        total_amount <- map["total_amount"]
        membership_accumulate_point_used <- map["membership_accumulate_point_used"]
    
    }
}


struct OrderResponse:Mappable{
    var limit: Int?
    var data = [Order]()
    var total_record:Int?
      
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        limit <- map["limit"]
        data <- map["list"]
        total_record <- map["total_record"]
    }
    
}

struct Order: Mappable {
    var using_time_minutes = 0
    var using_time_minutes_string = ""
    var table_name = ""
    var table_id = 0
    var table_merged_names = [String]()
    var using_slot = 0
    var order_status = 0
    var created_at = ""
    var payment_date = ""
    var id = 0
    var customer_id = 0
    var total_amount:Double = 0
    var deposit_amount:Double = 0
    var is_share_point = 0
    var total_order_detail_customer_request = 0
    var note = ""
    var booking_infor_id = 0
    var is_allow_request_payment = 0
    var booking_status = 0
    var is_take_away = 0
    var employee = Account()
    var updated_at = ""
    // Thêm trường employee_id
    var employee_id = 0
    var area_id = 0
    var total_amount_avg_per_customer = 0
    var buffet_ticket_id = 0
    var order_method:Order_Method = .EAT_IN
    
    init?(map: Map) {
    }
    
    init(table:Table) {
        self.id = table.order_id
        self.table_name = table.name
        self.table_id = table.id
    }
    init(orderDetail:OrderDetail) {
        self.id = orderDetail.id
        self.table_name = orderDetail.table_name
        self.table_id = orderDetail.table_id
        self.buffet_ticket_id = orderDetail.buffet?.buffet_ticket_id ?? 0
    }
    
    init?() {}

    mutating func mapping(map: Map) {
        using_time_minutes                  <- map["using_time_minutes"]
        using_time_minutes_string           <- map["using_time_minutes_string"]
        using_slot                          <- map["using_slot"]
        table_name                          <- map["table_name"]
        table_id                            <- map["table_id"]
        table_merged_names                  <- map["table_merged_names"]
        order_status                        <- map["order_status"]
        created_at                          <- map["created_at"]
        payment_date <- map["payment_date"]
        id                                  <- map["id"]
        customer_id <- map["customer_id"]
        total_amount                        <- map["total_amount"]
        is_share_point                      <- map["is_share_point"]
        total_order_detail_customer_request <- map["total_order_detail_customer_request"]
        note <- map["note"]
        booking_infor_id <- map["booking_infor_id"]
        is_allow_request_payment <- map["is_allow_request_payment"]
        booking_status <- map["booking_status"]
        is_take_away <- map["is_take_away"]
        employee <- map["employee"]
        deposit_amount <- map["deposit_amount"]
        employee_id <- map["employee_id"] // map employee_id
        area_id <- map["area_id"] // map area_id
        updated_at <- map["updated_at"]
        total_amount_avg_per_customer <- map["total_amount_avg_per_customer"]
        buffet_ticket_id <- map["buffet_ticket_id"]
        order_method <- map["order_method"]
    
    }
}


struct SplitFoodResponse:Mappable{
    
    var order_id = 0

    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        order_id <- map["order_id"]
        
    }
    
}

struct OrderMethod: Mappable {
    var is_have_take_away = DEACTIVE
    
    init() {}
    
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        is_have_take_away <- map["is_have_take_away"]
    }
}
