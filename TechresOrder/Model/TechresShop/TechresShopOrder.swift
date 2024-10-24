//
//  TechresShopOrder.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit
import ObjectMapper


struct TechresShopOrderResponse: Mappable {
    var limit = 0
    var list:[TechresShopOrder] = []
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

struct TechresShopOrder: Mappable {
    var id = 0
    var product_order_id = 0
    var code = ""
    var amount:Float = 0
    var vat_percent:Float = 0
    var vat_amount:Float = 0
    var total_product_discount_amount = 0
    var discount_percent:Float = 0
    var discount_amount:Float = 0
    var total_amount:Float = 0
    var total_amount_returned = 0
    var total_device = 2
    var note = ""
    var customer_object_type = 0
    var customer_object_id = 0
    var customer_brand_id = 0
    var customer_branch_id = 0
    var customer_name = ""
    var customer_phone = ""
    var customer_email = ""
    var customer_address = ""
    var customer_type = 0
    var receiver_name = ""
    var receiver_phone = ""
    var receiver_email = ""
    var shipping_city_id = 0
    var shipping_city_name = ""
    var shipping_district_id = 0
    var shipping_district_name = ""
    var shipping_ward_id = 0
    var shipping_ward_name = ""
    var shipping_street_name = ""
    var shipping_full_address = ""
    var shipping_lat = ""
    var shipping_lng = ""
    var product_order_status:OrderStatusOfTechresShop = .waiting_confirm
    var created_at = ""
    var updated_at = ""
    var delivery_at = ""
    var received_at = ""
    var completed_at = ""
    var cancelled_at = ""
    var canceled_reason = ""
    var payment_status:PaymentStatusOfTechresShop = .payment_waitting_confirm
    var is_apply_vat = 0
    
    var details:[TechresShopOrderItem] = []
    
    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        id  <- map["id"]
        product_order_id  <- map["product_order_id"]
        code  <- map["code"]
        amount  <- map["amount"]
        vat_percent  <- map["vat_percent"]
        vat_amount  <- map["vat_amount"]
        total_product_discount_amount  <- map["total_product_discount_amount"]
        discount_percent  <- map["discount_percent"]
        discount_amount  <- map["discount_amount"]
        total_amount  <- map["total_amount"]
        total_amount_returned  <- map["total_amount_returned"]
        total_device  <- map["total_device"]
        note  <- map["note"]
        customer_object_type  <- map["customer_object_type"]
        customer_object_id  <- map["customer_object_id"]
        customer_brand_id  <- map["customer_brand_id"]
        customer_branch_id  <- map["customer_branch_id"]
        customer_name  <- map["customer_name"]
        customer_phone  <- map["customer_phone"]
        customer_email  <- map["customer_email"]
        customer_address  <- map["customer_address"]
        customer_type  <- map["customer_type"]
        receiver_name  <- map["receiver_name"]
        receiver_phone  <- map["receiver_phone"]
        receiver_email  <- map["receiver_email"]
        shipping_city_id  <- map["shipping_city_id"]
        shipping_city_name  <- map["shipping_city_name"]
        shipping_district_id  <- map["shipping_district_id"]
        shipping_district_name  <- map["shipping_district_name"]
        shipping_ward_id  <- map["shipping_ward_id"]
        shipping_ward_name  <- map["shipping_ward_name"]
        shipping_street_name  <- map["shipping_street_name"]
        shipping_full_address  <- map["shipping_full_address"]
        shipping_lat  <- map["shipping_lat"]
        shipping_lng  <- map["shipping_lng"]
        product_order_status  <- map["product_order_status"]
        created_at  <- map["created_at"]
        updated_at  <- map["updated_at"]
        delivery_at  <- map["delivery_at"]
        received_at  <- map["received_at"]
        completed_at  <- map["completed_at"]
        cancelled_at  <- map["cancelled_at"]
        canceled_reason  <- map["canceled_reason"]
        payment_status  <- map["payment_status"]
        is_apply_vat  <- map["is_apply_vat"]
        details <- map["details"]
    }
    
    
}
