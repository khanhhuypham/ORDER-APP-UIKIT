//
//  ReasonCancel.swift
//  TechresOrder
//
//  Created by Kelvin on 18/01/2023.
//

import UIKit
import ObjectMapper

struct ReasonCancel: Mappable {
    var id = 0
    var content = ""
    var is_select = 0
    
    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
        id              <- map["id"]
        content       <- map["content"]
        
    }
}
