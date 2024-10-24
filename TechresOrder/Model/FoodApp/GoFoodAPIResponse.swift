//
//  GoFoodToken.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/08/2024.
//

import UIKit
import ObjectMapper

struct GoFoodAPIResponse: Mappable {

    var data:[String : Any] = [:]
    var errors:[[String : Any]] = []
    var success:Bool = false
    var access_token:String?
    
    init?(map: Map) {}
    
    init(){}
        
    mutating func mapping(map: Map) {
     
        data  <- map["data"]
        errors <- map["errors"]
        success <- map["success"]
        access_token <- map["access_token"]
        
    }
}


struct ShopeeFoodAPIResponse: Mappable {

    var data:[String : Any] = [:]
    var error_msg:String?

    
    init?(map: Map) {}
    
    init(){}
        
    mutating func mapping(map: Map) {
     
        data  <- map["data"]
        error_msg <- map["error_msg"]
       
        
    }
}

