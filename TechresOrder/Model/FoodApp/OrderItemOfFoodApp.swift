//
//  OrderItemOfFoodApp.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/08/2024.
//

import UIKit
import ObjectMapper


struct OrderItemOfFoodApp: Mappable {
    var id = 0
   
//    var customer_order_id:Int = 0
    var food_id:String = ""
    var name = ""
//    var order_detail_parent_id = 0
//    var order_detail_combo_parent_id = 0
    
//    var customer_order_detail_addition_ids:[String:Any] = [:]
//    var customer_order_detail_combo_ids:[String:Any] =  [:]
//    var customer_order_detail_combo:[String:Any] =  [:]
//    var customer_order_detail_addition:[String:Any] =  [:]
    var vat_percent:Float = 0
    var vat_amount:Float = 0
    var quantity:Float = 0
    var price:Double = 0
    var total_price:Double = 0
//    var total_price_include_addition_foods:Double = 0
//    var is_addition:Int = 0
//    var is_combo:Int = 0
    var note:String = ""
//    var created_at:Int = 0
//    var updated_at:Int = 0
//    var channel_order_food_code = ""
    var food_options:[OrderItemChildrenOfFoodApp] = []

    
//    var order_detail_additions:[OrderItemChildrenOfFoodApp]? = nil{
//        didSet{
//            guard let order_detail_additions = self.order_detail_additions else {
//                return
//            }
//            
//            self.food_options = order_detail_additions
//        }
//    }
    
    var food_name:String? =  nil{
        didSet{
            guard let food_name = self.food_name else {
                return
            }
            
            
            self.name = food_name
        }
    }
    
    var total_price_addition:Double = 0
    
//    var total_price_addition:Double? = nil{
//        didSet{
//            guard let total_price_addition = self.total_price_addition else {
//                return
//            }
//            
////            self.total_price_include_addition_foods = total_price_addition
//        }
//    }
    
    
        
    init?(map: Map) {}
    
    init(){}
    
    init(name:String,price:Double,quantity:Float,total_price:Double,food_options:[OrderItemChildrenOfFoodApp] = []){
        self.name = name
        self.price = price
        self.quantity = quantity
        self.total_price = total_price
        self.food_options = food_options
    }
        
    mutating func mapping(map: Map) {
     
        id  <- map["id"]
//        customer_order_id  <- map["customer_order_id"]
        food_id  <- map["food_id"]
        name <- map["name"]
//        order_detail_parent_id  <- map["order_detail_parent_id"]
//        order_detail_combo_parent_id  <- map["order_detail_combo_parent_id"]
//        customer_order_detail_addition_ids  <- map["customer_order_detail_addition_ids"]
//        customer_order_detail_combo_ids  <- map["customer_order_detail_combo_ids"]
//        customer_order_detail_combo  <- map["customer_order_detail_combo"]
//        customer_order_detail_addition  <- map["customer_order_detail_addition"]
        vat_percent <- map["vat_percent"]
        vat_amount <- map["vat_amount"]
        quantity  <- map["quantity"]
        price  <- map["price"]
        total_price  <- map["total_price"]
//        total_price_include_addition_foods  <- map["total_price_include_addition_foods"]
//        is_addition  <- map["is_addition"]
//        is_combo  <- map["is_combo"]
        note  <- map["note"]
//        is_combo  <- map["is_combo"]
//        created_at  <- map["created_at"]
//        updated_at  <- map["updated_at"]
//        channel_order_food_code <- map["channel_order_food_code"]
        food_options <- map["food_options"]
        
        
        total_price_addition <- map["total_price_addition"]
        food_name  <- map["food_name"]
//        order_detail_additions <- map["order_detail_additions"]
    }
}


struct OrderItemChildrenOfFoodApp: Mappable {
    var name = ""
    var quantity = 0
    var price = 0
 
    init?(map: Map) {}
    
    init(){}
    
    init(name:String,quantity:Int,price:Int){
        self.name = name
        self.quantity = quantity
        self.price = price
    }
    
  
    mutating func mapping(map: Map) {
     
        name  <- map["name"]
        quantity  <- map["quantity"]
        price  <- map["price"]
      
    }
}
