//
//  NoteRequest.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 01/02/2023.
//

import UIKit
import ObjectMapper
struct NoteRequest: Mappable {
    
    var id = 0
    var branch_id = 0
    var content = ""
    var delete = 0
    
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        id       <- map["id"]
        branch_id       <- map["branch_id"]
        content       <- map["content"]
        delete       <- map["delete"]
       
    }
    
}

