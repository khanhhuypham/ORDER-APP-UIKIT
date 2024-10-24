//
//  Review.swift
//  TechresOrder
//
//  Created by Kelvin on 22/01/2023.
//

import UIKit
import ObjectMapper

struct Review: Mappable {
    var order_detail_id = 0
    var score = 0
    var note = ""
    
    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
       order_detail_id              <- map["order_detail_id"]
       score                        <- map["score"]
       note                         <- map["note"]
    }
}
