//
//  Area.swift
//  TechresOrder
//
//  Created by Kelvin on 14/01/2023.
//

import UIKit
import ObjectMapper

struct AreaData :Mappable{
    var list = [Area]()
    var limit: Int?
    var total_record:Int?
      
    init?(map: Map) {
    }
    
    
    
    
    mutating func mapping(map: Map) {
        list <- map["list"]
        limit <- map["limit"]
        total_record <- map["total_record"]
    }
    
}


struct Area: Mappable {
    var id =  0
    var name = ""
    var status = 0
    var branch_id = 0
    var is_select = 0
    
     init?(map: Map) {
    }
    
    init(id:Int, name:String, is_select:Int){
        self.id = id
        self.name = name
        self.is_select = is_select
    }
    
    
    init?() {
    }

    mutating func mapping(map: Map) {
        
        id                          <- map["id"]
        name                        <- map["name"]
        status                      <- map["status"]
        branch_id                   <- map["branch_id"]
        is_select                   <- map["is_select"]
    }
}
