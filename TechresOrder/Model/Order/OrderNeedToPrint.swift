//
//  OrderNeedToPrint.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 19/01/2024.
//

import UIKit

import ObjectMapper
struct OrderNeedToPrint: Mappable {
    var order_id = 0
    var type = 0
    var employee_id = 0
    var order_details:[Food] = []
    
    init?(map: Map) {}
    init?() {}
    

 
    
    mutating func mapping(map: Map) {
        order_id              <- map["id"] //this id is order_id of an order
        type              <- map["type"]
        employee_id <- map["employee_id"]
        order_details <- map["order_details"]
    }
}






