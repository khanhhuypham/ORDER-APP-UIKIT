//
//  ActivityLog.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 14/12/2023.
//

import UIKit
import ObjectMapper



struct ActivityLogResponse:Mappable{
    var limit: Int?
    var data = [ActivityLog]()
    var total_record:Int?
      
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        limit <- map["limit"]
        data <- map["list"]
        total_record <- map["total_record"]
    }
}


struct ActivityLog: Mappable {
    var id = 0
    var user_id = 0
    var full_name = ""
    var user_name = ""
    var object_id = 0
    var content = ""
    var created_at = ""
 
    init?(map: Map) {
    }
    init?() {
    }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        user_id      <- map["user_id"]
        full_name      <- map["full_name"]
        user_name   <- map["user_name"]
        object_id              <- map["object_id"]
        user_id       <- map["user_id"]
        content              <- map["content"]
        created_at       <- map["created_at"]
       
    }
}
