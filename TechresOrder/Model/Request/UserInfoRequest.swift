//
//  UserInfoRequest.swift
//  TechresOrder
//
//  Created by Kelvin on 11/02/2023.
//

import UIKit
import ObjectMapper
struct UserInfoRequest: Mappable {
    var employee_id = 0
    var city_id = 0
    var district_id = 0
    var ward_id = 0
    var street_name = ""

    
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        employee_id       <- map["employee_id"]
        city_id       <- map["city_id"]
        district_id       <- map["district_id"]
        ward_id       <- map["ward_id"]
        street_name       <- map["street_name"]
       
    }
    
}
