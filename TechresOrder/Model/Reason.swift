//
//  Reason.swift
//  TechresOrder
//
//  Created by Kelvin on 14/01/2023.
//

import UIKit
import ObjectMapper

struct Reason: Mappable {
    var id = 0
    var content = ""
    
    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
       id <- map["id"]
       content <- map["content"]
   }
    
}
