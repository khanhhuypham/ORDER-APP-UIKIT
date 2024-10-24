//
//  APIResponse.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import ObjectMapper


class APIResponse: Mappable {
    var code: Int?
    var data: AnyObject?
    var social_data: AnyObject?
    var error:Bool?
    var message:String?
    var token:String?
    var total: Int?
    var limit: Int?
    var totalMessage: Int?
    
    init() {}
    
    required  init?(map: Map) {
        mapping(map: map)
    }
    
    func  mapping(map: Map) {
        data    <- map["data"]
        social_data    <- map["entries"]
        code    <- map["status"]
        error   <- map["error"]
        message <- map["message"]
        token   <- map["token"]
        total   <- map["total_record"]
        limit   <- map["limit"]
        totalMessage   <- map["totalMessage"]
    }
}
