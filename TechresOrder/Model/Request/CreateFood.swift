//
//  CreateFoodRequest.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 03/02/2023.
//

import UIKit
import ObjectMapper

struct CreateFood: Mappable {
    var id =  0
    var name = ""
    var avatar = ""
    var avatar_thump = ""
    var category_name = ""
    var price:Int = 0
    var originalPrice:Float = 0
    var timeToCompleted = 0
    var is_bbq = 0
    var is_addition = 0
    var is_addition_like_food = 0
    var is_special_claim_point = 0
    var is_allow_review = 0
    var quantity :Float = 1
    var quantity_refun = 0
    var is_cook_on_table = 0
    var note = ""
    var category_id = 0
    var category_type = 0
    var unit = ""
    var code = ""
    var prefix = ""
    var status = 0
    var normalize_name = ""
    var is_sell_by_weight = 0
    var description = ""
    var is_allow_print = 0
    var is_allow_print_stamp = 0
    var is_take_away = 0
    var categories = [Category]()
    var food_addition_ids = [Int]()
    var food_material_type = 1
    var restaurant_kitchen_place_id = 0
    var collapsed: Bool! = true
    var temporary_price:Int = 0
    var temporary_percent:Int = 0
    var temporary_price_from_date = ""
    var temporary_price_to_date = ""
    var promotion_percent:Float = 0
    var promotion_from_date = ""
    var promotion_to_date = ""
    var restaurant_vat_config_id = 0
    init() {}
    
    init?(map: Map) {
    }
    
    init(food:Food){
        self.id = food.id
        self.name = food.name
        self.category_id = food.category_id
        self.category_type = food.category_type.rawValue
        self.restaurant_kitchen_place_id = food.restaurant_kitchen_place_id
        self.unit = food.unit_type
        self.temporary_price = food.temporary_price
        self.temporary_percent = food.temporary_percent
        self.price = food.price
        self.avatar = food.avatar
        self.is_allow_print = food.is_allow_print
        self.is_allow_print_stamp = food.is_allow_print_stamp
        self.temporary_price_from_date = food.temporary_price_from_date
        self.temporary_price_to_date = food.temporary_price_to_date
        self.is_addition = food.is_addition
        self.is_addition_like_food = food.is_addition_like_food // cho vào menu
        self.food_addition_ids = food.addition_foods.map{$0.id}
        self.is_sell_by_weight = food.is_sell_by_weight
        self.restaurant_vat_config_id = food.restaurant_vat_config_id
        self.status = food.status
    }
 

    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        name                                    <- map["name"]
        avatar                                  <- map["avatar"]
        avatar_thump                            <- map["avatar_thump"]
        code                                    <- map["code"]
        prefix                                  <- map["prefix"]
        price                                   <- map["price"]
        originalPrice                           <- map["original_price"]
        status                                  <- map["status"]
        timeToCompleted                         <- map["time_to_completed"]
        normalize_name                          <- map["normalize_name"]
        category_id                             <- map["category_id"]
        category_type                           <- map["category_type"]
        category_name                           <- map["category_name"]
        is_bbq                                  <- map["is_bbq"]
        is_special_claim_point                  <- map["is_special_claim_point"]
        is_allow_review                         <- map["is_allow_review"]
        is_sell_by_weight                       <- map["is_sell_by_weight"]
        is_cook_on_table                        <- map["is_cook_on_table"]
        note                                    <- map["note"]
        quantity                                <- map["quantity"]
        quantity_refun                          <- map["return_quantity"]
        description                             <- map["description"]
        categories                              <- map["categories"]
        unit                                    <- map["unit"]
        is_allow_print                          <- map["is_allow_print"]
        is_allow_print_stamp                    <- map["is_allow_print_stamp"]
        is_take_away                            <- map["is_take_away"]
        food_material_type                      <- map["food_material_type"]
        food_addition_ids                       <- map["food_addition_ids"]
        restaurant_kitchen_place_id             <- map["restaurant_kitchen_place_id"]
        restaurant_vat_config_id <- map["restaurant_vat_config_id"]
        is_addition <- map["is_addition"]
        is_addition_like_food <- map["is_addition_like_food"]
    }
}
