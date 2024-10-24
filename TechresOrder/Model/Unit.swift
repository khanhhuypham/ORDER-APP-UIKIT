//
//  Unit.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 03/02/2023.
//

import UIKit
import ObjectMapper
struct Unit: Mappable {
    var id = 0
    var code = ""
    var name = ""
    
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        id                                                                  <- map["id"]
        code                                                                <- map["code"]
        name                                                                <- map["name"]
    }
}
