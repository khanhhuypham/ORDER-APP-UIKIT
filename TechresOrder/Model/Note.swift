//
//  Note.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import ObjectMapper

struct NoteModel: Mappable{
    var data = [Note]()
    init?(map: Map) {
   }
   init?() {
   }
    
    mutating func mapping(map: Map) {
        data <- map["data"]

     }
}
struct Note: Mappable {
    var id = 0
    var content = ""
    var note = ""
    
    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
       id <- map["id"]
       content <- map["content"]
       note <- map["note"]
    }
}

