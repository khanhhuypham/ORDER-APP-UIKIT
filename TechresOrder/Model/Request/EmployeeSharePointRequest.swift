//
//  EmployeeSharePointRequest.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit
import ObjectMapper

struct EmployeeSharePointRequest: Mappable {
    var id = 0
    var name = ""
  
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        name                                    <- map["name"]
    }
    
}
