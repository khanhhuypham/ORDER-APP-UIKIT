//
//  DeviceRequest.swift
//  TechresOrder
//
//  Created by Kelvin on 14/01/2023.
//

import UIKit
import ObjectMapper

struct DeviceRequest: Mappable {
    var restaurant_id:Int?
    var device_uid:String?
    var employee_id:String?
    var push_token:String?
    var app_type:Int?
    
    init?(map: Map) {
   }
   init?() {
   }

    init(appType:Int,deviceUID:String,pushToken:String) {
        self.app_type = appType
        self.device_uid = deviceUID
        self.push_token = pushToken
    }
   
    mutating func mapping(map: Map) {
       restaurant_id <- map["restaurant_id"]
       device_uid <- map["device_uid"]
       employee_id <- map["employee_id"]
       push_token <- map["push_token"]
       app_type <- map["app_type"]
    }

}
