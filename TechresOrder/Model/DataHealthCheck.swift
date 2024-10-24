//
//  DataHealthCheck.swift
//  TECHRES-ORDER
//
//  Created by Kelvin on 25/09/2023.
//

import UIKit
import ObjectMapper
struct DataHealthCheck: Mappable {
    var is_update = 0
   
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        is_update                                                                  <- map["is_update"]
    }
}
