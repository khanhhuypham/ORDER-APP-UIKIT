//
//  FoodAppOrder.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/08/2024.
//

import UIKit
import ObjectMapper
//import RealmSwift


struct FoodAppOrderResponse: Mappable {
    var errors:[[String:String]] = []
    var list:[FoodAppOrder] = []
 
    init?(map: Map) {}
    init(){}
        
    mutating func mapping(map: Map) {
        errors  <- map["errors"]
        list  <- map["list"]
    }
}


struct FoodAppOrder: Mappable {
    var id = 0
    var order_id = ""
    var phone = ""

    var driver_name:String = ""
    var driver_phone:String = ""
    var driver_avatar:String = ""
    var channel_order_id:String = ""
    var channel_order_code:String = ""
    var channel_order_food_id = 0
    var channel_order_food_name =  ""
    var channel_order_food_code = ""
    var is_app_food = ACTIVE
    var order_amount:Float = 0
    var discount_amount:Float = 0
    var total_amount:Float = 0
    var shipping_fee:Float = 0
    
    var customer_name = ""
    var customer_order_amount:Float = 0
    var customer_discount_amount:Float = 0
    
    var display_id = ""
    
    var details:[OrderItemOfFoodApp] = []
        
    private var order_details:[OrderItemOfFoodApp]? = nil{
        
        didSet{
            guard let details = self.order_details else {
                return
            }
            
            self.details = details
        }
    }
 
    var created_at = ""
    var updated_at = ""
    var order_created_at = ""
    var is_completed:OrderStatusOfFoodApp = .complete
    init?(map: Map) {}
    init(){}
        
    mutating func mapping(map: Map) {
     
        id  <- map["id"]
        order_id <- map["order_id"]

        phone  <- map["phone"]

        driver_name  <- map["driver_name"]
        driver_phone <- map["driver_phone"]
        driver_avatar  <- map["driver_avatar"]
    
        channel_order_id  <- map["channel_order_id"]
        channel_order_code <- map["channel_order_code"]
        channel_order_food_id  <- map["channel_order_food_id"]
        channel_order_food_name  <- map["channel_order_food_name"]
        channel_order_food_code  <- map["channel_order_food_code"]
        is_app_food  <- map["is_app_food"]
        order_amount  <- map["order_amount"]
        discount_amount <- map["discount_amount"]
        total_amount  <- map["total_amount"]
        
        customer_name  <- map["customer_name"]
        customer_order_amount  <- map["customer_order_amount"]
        customer_discount_amount  <- map["customer_discount_amount"]
        
        details <- map["order_channel_details"]
        order_details <- map["details"]
        
        
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        order_created_at <- map["order_created_at"]
        display_id <- map["display_id"]
        is_completed <- map["is_completed"]
    }
}



