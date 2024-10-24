//
//  Account.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import ObjectMapper

struct Account: Mappable {
    var id = 0
    var access_token=""
    var refresh_token = ""
    var expires_in = 0
    var branch_type = 0
    var avatar=""
    var branch_id=0
    var city_id=0
    var district_id=0
    var ward_id=0
    var email=""
    var employee_id=0
    var employee_role = ""
    var employee_role_id = 0
    var employee_role_name=""
    var employee_role_description = ""
    var name = ""
    var birthday = ""
    var phone_number=""
    var restaurant_name=""
    var restaurant_domain_name=""
    var restaurant_id=0
    var token_type=""
    var username=""
    var password=""
    var header = ""
    var branch_name = ""
    var branch_address = ""
    var address_full_text = ""
    var permissions = [String]()
    var prefix = ""
    var role_name = ""
    var normalize_name = ""
    var isSelect = 0
    var gender:Gender = .male
    var working_session_id = 0
    var working_session_time = ""
    var working_session_name = ""
    var address = ""
    var employee_rank_id = 0
    var employee_rank_name = ""
    var restaurant_brand_id = 0
    var brand_name = ""
    var jwt_token = ""
    var token_time_life:Double = 0
    var city_name = ""
    var district_name = ""
    var ward_name = ""
    var is_branch_office:Int = 0
    //========== Chat =========
    var node_id = ""
//    var node_access_token = ""
    var currentChatId = ""
    var identity_card = ""
    var is_working = 0
    var is_enable_change_password = 0//lần đầu sử dụng cần đổi password
    
    
    //========== this variable uses for local, not exist from server =========
    var alreadCheckWorkingSession:Bool = false
    
    init() {}
    
    init?(map: Map) {
        
    }
    
    
    mutating func mapping(map: Map){
        id                                      <- map["id"]
        access_token                            <- map["access_token"]
        header                                  <- map["header"]
        refresh_token                           <- map["refresh_token"]
        address_full_text                       <- map["address_full_text"]
        branch_address                           <- map["branch_address"]
        avatar                                  <- map["avatar"]
        email                                   <- map["email"]
        name                                    <- map["name"]
        branch_id                               <- map["branch_id"]
        city_id                               <- map["city_id"]
        district_id                               <- map["district_id"]
        ward_id                               <- map["ward_id"]
        employee_id                             <- map["id"]
        employee_role                           <- map["employee_role"]
        employee_role_id                        <- map["employee_role_id"]
        employee_role_name                      <- map["role_name"]
        phone_number                            <- map["phone"]
        restaurant_id                           <- map["restaurant_id"]
        restaurant_name                         <- map["restaurant_name"]
        restaurant_domain_name                 <- map["restaurant_domain_name"]
        token_type                              <- map["token_type"]
        username                                <- map["username"]
        password                                <- map["password"]
        permissions                             <- map["permissions"]
        birthday                                <- map["birthday"]
        employee_role_description               <- map["employee_role_description"]
        expires_in                              <- map["expires_in"]
        branch_type                             <- map["branch_type"]
        branch_name                             <- map["branch_name"]
        prefix                                  <- map["prefix"]
        role_name                               <- map["role_name"]
        normalize_name                          <- map["normalize_name"]
        gender                                  <- map["gender"]
        working_session_id                      <- map["working_session_id"]
        working_session_time                    <- map["working_session_time"]
        working_session_name                    <- map["working_session_name"]
        address                                 <- map["address"]
        employee_rank_id                        <- map["employee_rank_id"]
        employee_rank_name                      <- map["employee_rank_name"]
        node_id                                 <- map["_id"]
        restaurant_brand_id                     <- map["restaurant_brand_id"]
        brand_name <- map["restaurant_brand_name"]
        jwt_token <- map["jwt_token"]
        token_time_life <- map["token_time_life"]
        city_name <- map["city_name"]
        district_name <- map["district_name"]
        ward_name <- map["ward_name"]
        is_branch_office <- map["is_branch_office"]
        identity_card <- map["identity_card"]
        is_working <- map["is_working"]
        is_enable_change_password <- map["is_enable_change_password"]
        
        
        //========== this variable uses for local, not exist from server =========
        alreadCheckWorkingSession <- map["alreadCheckWorkingSession"]
    }
    
}
