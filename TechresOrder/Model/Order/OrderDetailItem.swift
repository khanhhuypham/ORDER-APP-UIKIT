//
//  OrderDetailItem.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 07/05/2024.
//

import UIKit
import ObjectMapper
struct OrderItem: Mappable {

    var is_booking_item = DEACTIVE //biến này dùng để nhận biết món này là món đã được booking
    var order_id = 0
    var id = 0
    var food_avatar = ""
    var food_id = 0
    var name = ""
    var price = 0
    var quantity:Float = 0
    var return_quantity_for_drink:Float = 0
    var printed_quantity:Float = 0
    var total_price_inlcude_addition_foods:Float = 0
    var total_price:Double = 0
    var status:FOOD_STATUS = .pending
    var category_type:FOOD_CATEGORY = .food
    var is_gift = 0
    var enable_return_beer = 0
    var note = ""
    var is_bbq = 0
    var is_extra_Charge = 0
    var quantity_change:Float = 0
    var isChange = 0

    var is_sell_by_weight = 0
    var review_score = 0
    var is_allow_print_stamp = DEACTIVE
    var order_detail_additions:[OrderDetailAddition] = []
    var order_detail_combo:[OrderDetailAddition] = []
    var order_detail_promotion_foods:[OrderDetailAddition] = []
    var order_detail_buffetTicket:[OrderDetailAddition] = []
    var buffet_ticket_id:Int = 0 // this variable's only used for buffet Item. if Item is buffet, this variable != nil, otherwise this variable == nil.
    
    var rateInfo = ReviewFoodData()
    var total_price_include_addition_foods: Double = 0
    var is_combo = 0
    var food_in_combo_wait_print_quantity = 0
    var cancel_reason = ""
    var service_start_time = ""
    var service_end_time = ""
    var service_time_used = 0
    var block_price = 0
    var time_per_block = 0
    var time_block_price = 0
    var is_enable_block = 0
    var vat_percent = 0
    var discount_percent = 0
    var discount_amount = 0
    var discount_price = 0
    var is_only_use_printer:Int = DEACTIVE
    
    init?(map: Map) {}
    
    init() {}
    
    init(name:String,price:Int,quantity:Float,total_price:Double,discount_percent:Int = 0,discount_amount:Int = 0,discount_price:Int = 0){
        self.name = name
        self.price = price
        self.quantity = quantity
        self.total_price = total_price
        self.discount_percent = discount_percent
        self.discount_amount = discount_amount
        self.discount_price = discount_price
    }

    mutating func mapping(map: Map) {
        order_id <- map["order_id"]
        id                                      <- map["id"]
        food_avatar <- map["food_avatar"]
        food_id                                 <- map["food_id"]
        name                                    <- map["name"]
        price                                   <- map["price"]
        quantity                                <- map["quantity"]
        return_quantity_for_drink               <- map["return_quantity_for_drink"]
        printed_quantity                        <- map["printed_quantity"]
        total_price                             <- map["total_price"]
        status                                  <- map["status"]
        category_type                           <- map["category_type"]
        is_gift                                 <- map["is_gift"]
        enable_return_beer                      <- map["enable_return_beer"]
        note                                    <- map["note"]
        is_bbq                                  <- map["is_bbq"]
        is_extra_Charge                        <- map["is_extra_charge"]
        isChange                                <- map["isChange"]
        is_sell_by_weight                       <- map["is_sell_by_weight"]
        review_score                            <- map["review_score"]
        order_detail_additions                  <- map["order_detail_additions"]
        order_detail_combo                  <- map["order_detail_combo"]
        total_price_inlcude_addition_foods      <- map["total_price_inlcude_addition_foods"]
        total_price_include_addition_foods <- map["total_price_include_addition_foods"]
        is_allow_print_stamp <- map["is_allow_print_stamp"]
        order_detail_promotion_foods <- map["order_detail_restaurant_promotion_campaign_foods"]
        is_combo <- map["is_combo"]
        food_in_combo_wait_print_quantity <- map["food_in_combo_wait_print_quantity"]
        cancel_reason <- map["cancel_reason"]
        food_avatar <- map["food_avatar"]
        is_only_use_printer <- map["is_only_use_printer"]
        
        //-------------------------- service --------------------
        service_start_time <- map["service_start_time"]
        service_end_time <- map["service_end_time"]
        service_time_used <- map["service_time_used"]
        //-------------------------- buffet--------------------
        buffet_ticket_id <- map["order_buffet_ticket_id"]
        
        block_price <- map["block_price"]
        time_per_block <- map["time_per_block"]
        time_block_price <- map["time_block_price"]
        is_enable_block <- map["is_enable_block"]
        
        //-------------------------- discount-food--------------------
        discount_percent <- map["discount_percent"]
        discount_amount <- map["discount_amount"]
        discount_price <- map["discount_price"]
        
        
        
       
   }
    

    
    mutating func setQuantity(quantity:Float) -> Void {
        let maximumNumber:Float = self.is_sell_by_weight == ACTIVE ? 999 : 999
        
        if self.is_gift == DEACTIVE{
       
            self.quantity = quantity
          
            self.quantity = self.quantity >= maximumNumber ? maximumNumber : self.quantity
            
            self.isChange = ACTIVE
            
            self.quantity = self.quantity <= 0 ? 0 : self.quantity
        }
    }
    
    
    
    mutating func increaseChildrenItemByOne(id:Int) -> Void {
        switch category_type {
            case .buffet_ticket:
                if let position = order_detail_buffetTicket.firstIndex(where:{$0.id == id}){
                    order_detail_buffetTicket[position].increaseByOne()
                    self.isChange = ACTIVE
                }
            
            default:
                if let position = order_detail_additions.firstIndex(where:{$0.id == id}){
                    order_detail_additions[position].increaseByOne()
                    self.isChange = ACTIVE
                }
        }
       
    }

    
    mutating func decreaseChildrenItemByOne(id:Int) -> Void {
        
        switch category_type {
            case .buffet_ticket:
                if let position = order_detail_buffetTicket.firstIndex(where:{$0.id == id}){
                    order_detail_buffetTicket[position].decreaseByOne()
                    self.isChange = ACTIVE
                }
            
            
            default:
                if let position = order_detail_additions.firstIndex(where:{$0.id == id}){
                    order_detail_additions[position].decreaseByOne()
                    self.isChange = ACTIVE
                }
            
        }
        
    }
    
    
}

struct OrderDetailAddition: Mappable {
    var id = 0
    var name = ""
    var price = 0
    var total_price = 0
    var quantity:Float = 0
    var rateInfo = ReviewFoodData()
    var vat_percent = 0
    var discountAmount = 0
    var discountPercent = 0
    var discountPrice = 0
    var isSelected = DEACTIVE
    var isChange = DEACTIVE
    
    
    init?(map: Map) {}
    
    
    init(){}
    
    init(id:Int,name:String,quantity:Float,price:Int,total_price:Int,discountAmount:Int = 0,discountPercent:Int = 0, discountPrice:Int = 0){
        self.id = id
        self.name = name
        self.quantity = quantity
        self.price = price
        self.total_price = total_price
        self.discountAmount = discountAmount
        self.discountPercent = discountPercent
        self.discountPrice = discountPrice
    }
    
    

    mutating func mapping(map: Map) {
        id   <- map["id"]
        name                                    <- map["name"]
        price                                   <- map["price"]
        total_price                              <- map["total_price"]
        quantity                                <- map["quantity"]
        vat_percent <- map["vat_percent"]
  
    }
    
    
    mutating func increaseByOne() -> Void {

        let maximumNumber:Float = 1000
       
        if self.quantity != maximumNumber{
            self.quantity += 1
            self.isChange = ACTIVE
        }
    }

    
     mutating func decreaseByOne() -> Void {
        if self.quantity != 0{
            self.quantity -= 1
            self.isChange = ACTIVE
        }
        self.quantity = self.quantity <= 0 ? 0 : self.quantity
    }

}
