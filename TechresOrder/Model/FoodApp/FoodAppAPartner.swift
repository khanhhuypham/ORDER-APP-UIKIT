//
//  FoodAppAPartner.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/07/2024.
//


import UIKit
import ObjectMapper
struct FoodAppAPartner: Mappable {

    var id = 0
    var name = ""
    var code:APP_PARTNER = .befood
    var image_url = 0
    var status = 0
    var restaurant_brand_channel_order_food_map_id = 0
    var is_connect = 0
    var channel_order_food_token_id = 0
 
    
    init?(map: Map) {}
    init(){}
    
    init(cre:PartnerCredential){
        self.id = cre.id
        self.name = cre.name ?? ""
        self.code = cre.partnerType ?? .befood
        self.restaurant_brand_channel_order_food_map_id = 0
        self.is_connect = cre.is_connection ?? DEACTIVE
        self.channel_order_food_token_id = cre.id
    }
    
    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        name                                    <- map["name"]
        code                             <- map["code"]
        image_url                           <- map["image_url"]
        status                           <- map["status"]
        restaurant_brand_channel_order_food_map_id <- map["restaurant_brand_channel_order_food_map_id"]
        is_connect <- map["is_connect"]
        channel_order_food_token_id <- map["channel_order_food_token_id"]
    }
}


struct PartnerCredential: Mappable {

    var id = 0
    var restaurant_id = 0
    var restaurant_brand_id = 0
    var channel_order_food_id = 0
    var access_token = ""
    var username = ""
    var password = ""
    
    var x_foody_entity_id:Int?
    var x_merchant_token:String?
    var device_id:String?
    var device_brand:String?
    
    //this varibale only use for GoFood
    var phoneNumber:String?
    var is_connection:Int?
    var name:String?
    var partnerType:APP_PARTNER?

    
    init?(map: Map) {}
    init(){}
    
   
    
    
    
    init(id:Int,restaurant_id:Int, restaurant_brand_id:Int,partnerType:APP_PARTNER,channel_order_food_id:Int,access_token:String,username:String,password:String){
        self.id = id
        self.restaurant_id = restaurant_id
        self.restaurant_brand_id = restaurant_brand_id
        self.partnerType = partnerType
        self.channel_order_food_id = channel_order_food_id
        self.access_token = access_token
        self.username = username
        self.password = password
    }
    
    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        restaurant_id                                    <- map["restaurant_id"]
        restaurant_brand_id                             <- map["restaurant_brand_id"]
        channel_order_food_id                           <- map["channel_order_food_id"]
        access_token                           <- map["access_token"]
        username <- map["username"]
        password <- map["password"]
        
        x_foody_entity_id <- map["x_foody_entity_id"]
        x_merchant_token <- map["x_merchant_token"]
        device_id <- map["device_id"]
        device_brand <- map["device_brand"]
        is_connection <- map["is_connection"]
        name <- map["name"]
    }
}




struct BranchMapsFoodApp: Mappable {

    var channel_branch_id = ""
    var channel_branch_name = ""
    var branch_id = 0
 
    
    init?(map: Map) {}
    init(){}
    
    mutating func mapping(map: Map) {
        channel_branch_id  <- map["channel_branch_id"]
        channel_branch_name <- map["channel_branch_name"]
        branch_id <- map["branch_id"]
    }
}
