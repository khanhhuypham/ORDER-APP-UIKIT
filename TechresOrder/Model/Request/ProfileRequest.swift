//
//  ProfileRequest.swift
//  TechresOrder
//
//  Created by Kelvin on 05/02/2023.
//

import UIKit
import ObjectMapper
struct ProfileRequest: Mappable {
    var id = 0
    var name = ""
    var gender = 0
    var birthday = ""
    var phone_number = ""
    var address = ""
    var avatar = ""
    var email = ""
    var node_token = ""
    var city_id = 0
    var district_id = 0
    var ward_id = 0
    
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        id       <- map["id"]
        name       <- map["name"]
        gender       <- map["gender"]
        birthday       <- map["birthday"]
        phone_number       <- map["phone_number"]
        address       <- map["address"]
        avatar       <- map["avatar"]
        email       <- map["email"]
        node_token       <- map["node_token"]
      
       
    }
    
}
