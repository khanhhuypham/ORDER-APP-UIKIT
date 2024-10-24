//
//  WorkingSession.swift
//  TechresOrder
//
//  Created by Kelvin on 26/01/2023.
//

import UIKit
import ObjectMapper

struct WorkingSession: Mappable {
    var id = 0
    var name = ""
    var status = 0
    var branch_id = 0
    var from_hour = ""
    var to_hour = ""
    var time_interval_string = ""
    
    init?(map: Map) {
    }
    
    init(){}

   mutating func mapping(map: Map) {
       id                                                              <- map["id"]
       name                                                            <- map["name"]
       status                                                          <- map["status"]
       branch_id                                                       <- map["branch_id"]
       from_hour                                                       <- map["from_hour"]
       to_hour                                                         <- map["to_hour"]
       time_interval_string                                            <- map["time_interval_string"]
   }
}


struct CheckWorkingSession: Mappable {
    var type = 0
    var message = ""
    var order_session_id = 0
   
    
    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
       type                                                              <- map["type"]
       message                                                           <- map["message"]
       order_session_id                                                  <- map["order_session_id"]
   }
    
}
