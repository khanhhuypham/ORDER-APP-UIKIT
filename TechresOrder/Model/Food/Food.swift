//
//  Food.swift
//  TechresOrder
//
//  Created by Kelvin on 16/01/2023.
//

import UIKit
import ObjectMapper



struct FoodResponse: Mappable {
    var total_record = 0
    var limit = 0
    var foods = [Food]()
    
 
    init?(map: Map) {
    }
    init?() {
    }
    
    mutating func mapping(map: Map) {
        total_record    <- map["total_record"]
        limit          <- map["limit"]
        foods          <- map["list"]
       
    }
}




struct Food:Mappable {
 
    var id = 0
    var description = ""
    var status = 0
    var name =  ""

    var note = ""
    var cancel_reason = ""
    var prefix = ""
    var price =  0
    var price_with_temporary:Int = 0
    var unit_type = ""
    var quantity:Float = 0.0
    var printed_quantity:Float = 0

    var restaurant_id = 0   
    var restaurant_brand_id = 0
    var branch_id = 0
    var category_id = 0
    var avatar = ""
    var avatar_thump = ""
    var normalize_name = ""

    var temporary_price = 0
    var temporary_percent = 0
    var temporary_price_from_date = ""
    var temporary_price_to_date = ""

    var is_addition = 0
    var is_addition_like_food = 0
    var is_sell_by_weight:Int = DEACTIVE
//    var is_allow_review = 0
    var is_allow_print = 0
    var is_allow_print_stamp = 0
    var is_allow_purchase_by_point = 0
    var is_take_away = 0

    var is_allow_employee_gift = 0
    var is_combo = 0
    var is_bbq = 0
    var category_type:FOOD_CATEGORY = .food


    var restaurant_vat_config_id =  0
    var food_addition_ids = [Int]()
    var food_in_combo = [FoodAddition]()
    var addition_foods = [FoodAddition]()
//    var order_detail_additions = [OrderDetailAddition]() //Biến này chỉ dùng để map các món con khi gọi api lấy danh sách các món cần in
    var food_list_in_promotion_buy_one_get_one = [FoodAddition]()

    var restaurant_kitchen_place_id = 0
    var is_out_stock = 0
    var is_selected = 0
    var return_quantity_for_drink = 0
    var enable_return_beer = 0
    //temp
    var order_id = 0
    var discount_percent = 0
    var buffet_ticket_ids:[Int]? = nil
    
    
    init() {}
    init?(map: Map) {
    }
    
    init(id:Int,name:String){
        self.id = id
        self.name = name
    }
    
    
    init(itemObject:ItemObject){
        self.id = itemObject.id
        self.name = itemObject.name
        self.quantity = itemObject.quantity
        self.is_sell_by_weight = itemObject.is_sell_by_weight
        self.note = itemObject.note
        
 
        var childrenItem:[FoodAddition] = []

        for child in itemObject.addition_foods{
            childrenItem.append(FoodAddition.init(name: child.name, quantity: child.quantity))
        }
        self.addition_foods = childrenItem
    }
    
    init(id:Int,name:String,quantity:Float,price:Int,note:String,restaurant_kitchen_place_id:Int){
        /*init for print test function*/
        self.id = id
        self.name = name
        self.quantity = quantity
        self.price = price
        self.note = note
        self.restaurant_kitchen_place_id = restaurant_kitchen_place_id
    }
    
    mutating func mapping(map: Map) {
        description                                      <- map["description"]
        status                                      <- map["status"]
        name                                      <- map["name"]
        note                                      <- map["note"]
        cancel_reason <- map["cancel_reason"]
        prefix                                      <- map["prefix"]
        price                                      <- map["price"]
        price_with_temporary                       <- map["price_with_temporary"]
        unit_type                                      <- map["unit_type"]
        quantity                                      <- map["quantity"]

        printed_quantity                                      <- map["printed_quantity"]
        id                                      <- map["id"]
        restaurant_id                                      <- map["restaurant_id"]
        restaurant_brand_id                                      <- map["restaurant_brand_id"]
        branch_id                                      <- map["branch_id"]
        category_id                                      <- map["category_id"]
        avatar                                      <- map["avatar"]
        avatar_thump                                      <- map["avatar_thump"]
        normalize_name                                      <- map["normalize_name"]
        temporary_price                                      <- map["temporary_price"]
        temporary_percent                                      <- map["temporary_percent"]
        temporary_price_to_date                                      <- map["temporary_price_to_date"]
        temporary_price_from_date                                      <- map["temporary_price_from_date"]
        is_addition                                      <- map["is_addition"]
        
        is_addition_like_food                                      <- map["is_addition_like_food"]
        is_sell_by_weight                                      <- map["is_sell_by_weight"]
//        is_allow_review                                      <- map["is_allow_review"]
        is_allow_print                                      <- map["is_allow_print"]
        is_allow_print_stamp                                      <- map["is_allow_print_stamp"]
        is_allow_purchase_by_point                                      <- map["is_allow_purchase_by_point"]
        is_take_away                                      <- map["is_take_away"]
        is_combo                                      <- map["is_combo"]
        category_type                                     <- map["category_type"]
        restaurant_vat_config_id                          <- map["restaurant_vat_config_id"]
        food_addition_ids                                 <- map["food_addition_ids"]
        food_in_combo                                     <- map["food_in_combo"]
        addition_foods                                     <- map["addition_foods"]
//        order_detail_additions <- map["order_detail_additions"]
        food_list_in_promotion_buy_one_get_one <- map["food_list_in_promotion_buy_one_get_one"]
        restaurant_kitchen_place_id                       <- map["restaurant_kitchen_place_id"]
        is_out_stock                                      <- map["is_out_stock"]
        is_selected                                      <- map["is_selected"]
        is_allow_employee_gift                           <- map["is_allow_employee_gift"]
        enable_return_beer  <- map["enable_return_beer"]
        return_quantity_for_drink <- map["return_quantity_for_drink"]
        order_id                           <- map["order_id"]
        buffet_ticket_ids <- map["buffet_ticket_ids"]
        
    }
}


extension Food{
    
    
    mutating func select() -> Void {
        is_selected = ACTIVE
        if quantity <= 0 && is_selected == ACTIVE{
            quantity = is_sell_by_weight == ACTIVE ? 0.01 : 1
        }
    }
    
    
    mutating func deSelect() -> Void {
        is_selected = DEACTIVE
        
         if is_selected == DEACTIVE{
            quantity = 0
            discount_percent = 0
            note = ""
            addition_foods.enumerated().forEach{(i,data) in
                addition_foods[i].deSelect()
            }
             
            food_list_in_promotion_buy_one_get_one.enumerated().forEach{(i,data) in
                food_list_in_promotion_buy_one_get_one[i].deSelect()
            }
            
        }
    }
    
    mutating func setQuantity(quantity:Float) -> Void {
//        let maximumNumber:Float = self.is_sell_by_weight == ACTIVE ? 200 : 1000
        let maximumNumber:Float = 1000
        self.quantity = quantity
    
        self.quantity = self.quantity >= maximumNumber ? maximumNumber : self.quantity
        
          if self.quantity > 0 {
              self.is_selected = ACTIVE
              self.addition_foods.enumerated().forEach{(i,childFood) in
                  if childFood.is_selected == ACTIVE && self.is_allow_print_stamp == ACTIVE{
                      /*
                              Nếu món chính là món in stamp
                                  if món chính bán theo kg -> thì số lượng món con luôn = 1
                                  if món chính không bán theo kg -> thì số lượng món con luôn = số lượng món chính
                              các số lượng các món con được check sẽ = với số lượng món chính
                          */
                      self.addition_foods[i].quantity = self.is_sell_by_weight == ACTIVE ? Int(1) : Int(self.quantity)
                  }
              }
              if self.category_type == .service && self.quantity > 1{
                  self.quantity = 1
              }
          }else{
              self.deSelect()
          }
    }

    
    mutating func getChildren(id:Int) -> FoodAddition? {
        if addition_foods.count > 0{
            if let i = addition_foods.firstIndex(where: {$0.id == id}){
                return addition_foods[i]
            }
        }else if food_list_in_promotion_buy_one_get_one.count > 0{
            
            if let i = food_list_in_promotion_buy_one_get_one.firstIndex(where: {$0.id == id}){
               return food_list_in_promotion_buy_one_get_one[i]
            }
        }
        return nil
    }
    
    
    mutating func selectChildren(id:Int) -> Void {

        if addition_foods.count > 0{
            
            if let i = addition_foods.firstIndex(where: {$0.id == id}){
                
                if is_allow_print_stamp == ACTIVE{
                /*
                       Nếu món chính là món in stamp
                       if món chính bán theo kg -> thì số lượng món con luôn = 1
                       if món chính không bán theo kg -> thì số lượng món con luôn = số lượng món chính
                       các số lượng các món con được check sẽ = với số lượng món chính
                    */
                    addition_foods[i].quantity = is_sell_by_weight == ACTIVE ? Int(1) : Int(quantity)
                    addition_foods[i].is_selected = ACTIVE
                }else {
                    addition_foods[i].select()
                }
            }
        }else if food_list_in_promotion_buy_one_get_one.count > 0{
            var childrenQuantity = 0
            
            for children in food_list_in_promotion_buy_one_get_one{
                childrenQuantity += children.quantity
            }
            
            if let i = food_list_in_promotion_buy_one_get_one.firstIndex(where: {$0.id == id}){
                if Float(childrenQuantity) < quantity{
                    food_list_in_promotion_buy_one_get_one[i].select()
                }

            }
        }
    }
    
    
    mutating func deSelectChildren(id:Int) -> Void {
        if addition_foods.count > 0{
            
            if let i = addition_foods.firstIndex(where: {$0.id == id}){
                addition_foods[i].deSelect()
            }
            
        }else if food_list_in_promotion_buy_one_get_one.count > 0{
            
            if let i = food_list_in_promotion_buy_one_get_one.firstIndex(where: {$0.id == id}){
                food_list_in_promotion_buy_one_get_one[i].deSelect()
            }
        }
    }
    
    mutating func setChildrenQuantity(id:Int,quantity:Int) -> Void {
        if addition_foods.count > 0{
            if let i = addition_foods.firstIndex(where: {$0.id == id}){
                addition_foods[i].setQuantity(quantity: quantity)
            }
        }else if food_list_in_promotion_buy_one_get_one.count > 0{
            if let i = food_list_in_promotion_buy_one_get_one.firstIndex(where: {$0.id == id}){
                food_list_in_promotion_buy_one_get_one[i].setQuantity(quantity: quantity)
            }
        }
    }
    
  
}
