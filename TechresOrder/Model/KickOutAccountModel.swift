//
//  KickOutAccountModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/10/2023.
//

import UIKit
import ObjectMapper
struct KickOutAccountModel: Mappable {
    var app_type = 0
    var device_name = ""
    var device_uid = ""
    var ip_address = ""
    var login_at = ""
    var user_id = 0
    
    init?(map: Map) {
    }

   
    mutating func mapping(map: Map) {
        app_type        <- map["app_type"]
        device_name     <- map["device_name"]
        device_uid   <- map["device_uid"]
        ip_address   <- map["ip_address"]
        login_at   <- map["login_at"]
        user_id   <- map["user_id"]
    }
}
