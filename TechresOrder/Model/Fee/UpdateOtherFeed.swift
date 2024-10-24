//
//  UpdateOtherFeed.swift
//  ORDER
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 17/06/2023.
//
import UIKit
import ObjectMapper

struct UpdateOtherFeed: Mappable {
    var data = [UpdateOtherFeedList]()
    var total_record = 0
    var limit = 0
    
    init?() {}
    init?(map: Map) {}
    
    
    mutating func mapping(map: Map) {
        limit <- map[ "limit" ]
        data <- map[ "list" ]
        total_record <- map[ "total_record" ]
    }
}

struct UpdateOtherFeedList: Mappable {
    
    var id = 0
    var amount = 0
    var note = ""
    var branch = Branch()
    var employee = Account()
    var employee_edit = Account()
    var employee_confirm = Account()
    var offer_spending_id = 0
    var refund_addition_fee_id = 0
    var payment_method_id = 0
    var addition_fee_reason_id = 0
    var addition_fee_reason_name = ""
    var addition_fee_reason_type_id = 0
    var object_id = 0
    var object_name = ""
    var object_type = 0
    var cancel_reason = ""
    var image_urls = [String]()
    var fee_month = ""
    var addition_fee_status = 0
    var recuring_cost_id = 0
    var is_recurring_cost = 0
    var is_paid_debt = 0
    var recurring_cost_circle_repeats_type = 0
    var is_count_to_revenue = 0
    var is_automatically_generated = 0
    var is_restaurant_budget_closed = 0
    var supplier_order_ids = [Int]()
    var is_deleted = 0
    var created_at = ""
    var updated_at = ""
//    var supplier_orders = SupplierOrders()
    var isSelect = 0
    
    init?() {}
    init?(map: Map) {}
    
    
    mutating func mapping(map: Map) {
        id <- map[ "id" ]
        amount <- map[ "amount" ]
        note <- map[ "note" ]
        branch <- map[ "branch" ]
        employee <- map[ "employee" ]
        employee_edit <- map[ "employee_edit" ]
        employee_confirm <- map[ "employee_confirm" ]
        offer_spending_id <- map[ "offer_spending_id" ]
        refund_addition_fee_id <- map[ "refund_addition_fee_id" ]
        payment_method_id <- map[ "payment_method_id" ]
        addition_fee_reason_id <- map[ "addition_fee_reason_id" ]
        addition_fee_reason_name <- map[ "addition_fee_reason_name" ]
        addition_fee_reason_type_id <- map[ "addition_fee_reason_type_id" ]
        object_id <- map[ "object_id" ]
        object_name <- map[ "object_name" ]
        object_type <- map[ "object_type" ]
        cancel_reason <- map[ "cancel_reason" ]
        image_urls <- map[ "image_urls" ]
        fee_month <- map[ "fee_month" ]
        addition_fee_status <- map[ "addition_fee_status" ]
        recuring_cost_id <- map[ "recuring_cost_id" ]
        is_paid_debt <- map[ "is_paid_debt" ]
        recurring_cost_circle_repeats_type <- map[ "recurring_cost_circle_repeats_type" ]
        is_count_to_revenue <- map[ "is_count_to_revenue" ]
        is_automatically_generated <- map[ "is_automatically_generated" ]
        is_restaurant_budget_closed <- map[ "is_restaurant_budget_closed" ]
        supplier_order_ids <- map[ "supplier_order_ids" ]
        is_deleted <- map[ "is_deleted" ]
        created_at <- map[ "created_at" ]
        updated_at <- map[ "updated_at" ]
        isSelect <- map[ "isSelect" ]
        
    }
}
