//
//  TableModel.swift
//  TechresOrder
//
//  Created by Kelvin on 14/01/2023.
//

import UIKit
import ObjectMapper


struct TableData :Mappable{
    var list = [Table]()
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


struct Table: Mappable {
    var id = 0
    var name = ""
    var is_take_away = DEACTIVE
    var status = 0
    var order_status = 0
    var area_id = 0
    var area_name = ""
    var table_merged_name = [String]()
    var merge_table_name = ""
    var status_text = ""
    var booking_time = ""
    var is_not_allow_open = 0
    var slot_number = 0
    var is_active = DEACTIVE
    var waiting_booking_id = 0
    var order_id = 0
    var is_selected = 0
 
    
    init?(map: Map) {
    }
    
    init(){}
    


    mutating func mapping(map: Map) {
        id                                                  <- map["id"]
        name                                                <- map["name"]
        status                                              <- map["status"]
        order_status                                        <- map["order_status"]
        area_id                                             <- map["area_id"]
        area_name                                           <- map["area_name"]
        table_merged_name                                   <- map["table_merged_name"]
        merge_table_name                                    <- map["merge_table_name"]
        status_text                                         <- map["status_text"]
        booking_time                                        <- map["booking_time"]
        is_not_allow_open                                   <- map["is_not_allow_open"]
        slot_number                                         <- map["slot_number"]
        is_active                                           <- map["is_active"]
        waiting_booking_id                                  <- map["waiting_booking_id"]
        order_id                                            <- map["order_id"]
    }
}


struct CreateTableQuickly: Mappable {
  
    var name = ""
    var total_slot = 0
 
    
    init?(map: Map) {
    }
    
    init(name:String,total_slot:Int) {
        self.name = name
        self.total_slot = total_slot
    }

    mutating func mapping(map: Map) {
       
        name                                                <- map["name"]
        total_slot                                            <- map["total_slot"]
    }
}
