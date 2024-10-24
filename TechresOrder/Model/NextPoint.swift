//
//  NextPoint.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit
import ObjectMapper

struct NextPoint: Mappable {
    var bonus_salary: Int = 0
    var id: Int = 0
    var point: Int = 0
    
    var current_rank_target_point = 0.0
    var current_rank_bonus_salary = 0.0
    var next_rank_target_point = 0.0
    var next_rank_bonus_salary = 0.0
    
    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
       bonus_salary              <- map["bonus_salary"]
       id       <- map["id"]
       point       <- map["point"]
       current_rank_target_point <- map["current_rank_target_point"]
       current_rank_bonus_salary <- map["current_rank_bonus_salary"]
       next_rank_target_point <- map["next_rank_target_point"]
       next_rank_bonus_salary <- map["next_rank_bonus_salary"]
    }
}
