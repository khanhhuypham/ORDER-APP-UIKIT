//
//  VersionModel.swift
//  TechresOrder
//
//  Created by Kelvin on 14/01/2023.
//

import UIKit
import ObjectMapper

struct VersionModel: Mappable {
    var id:Int?
    var version:String?
    var message:String?
    var message_en:String?
    var is_require_update:Int?
    
    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
       id <- map["id"]
       version <- map["version"]
       message <- map["message"]
       message_en <- map["message_en"]
       is_require_update <- map["is_require_update"]
   }
}
