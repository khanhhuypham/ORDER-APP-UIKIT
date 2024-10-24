//
//  RevenueEmployee.swift
//  ORDER
//
//  Created by Kelvin on 13/05/2023.
//
import UIKit
import ObjectMapper

struct RevenueEmployeeData: Mappable {
    var revenues: [RevenueEmployee]?
    var total_revenue = 0
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        revenues <- map["list"]
        total_revenue <- map["total_revenue"]
    }
}
struct RevenueEmployeeResponse:Mappable{
    var limit: Int?
    var data : RevenueEmployeeData?
    var total_record:Int?
      
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        limit <- map["limit"]
        data <- map["data"]
        total_record <- map["total_record"]
    }
    
}

struct RevenueEmployee:Mappable {
    
    var employee_id = 0
    var avatar = ""
    var username =  ""
    var employee_name = ""
    var employee_role_name = ""
    var order_count = 0
    var revenue = 0
    
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        employee_id                                      <- map["employee_id"]
        avatar                                    <- map["avatar"]
        username                                   <- map["username"]
        employee_name                                 <- map["employee_name"]
        employee_role_name                              <- map["employee_role_name"]
        order_count                      <- map["order_count"]
        revenue                      <- map["revenue"]
    }
    
}
