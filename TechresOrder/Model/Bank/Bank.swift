//
//  Bank.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/04/2024.
//


import ObjectMapper

struct Bank:Mappable {
    var id = 0
    var name = ""
    var code = ""
    var bin = ""
    var logo = ""
    var support = 0
    var transfer_supported = 0
    var lookup_supported = 0
    var short_name = ""
    var is_transfer = 0
    var swift_code = ""
    
    init?(map: Map) {}
    init(){}
    
    mutating func mapping(map: Map) {
       
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        bin <- map["bin"]
        logo <- map["logo"]
        support <- map["support"]
        transfer_supported <- map["transfer_supported"]
        lookup_supported <- map["lookup_supported"]
        short_name <- map["short_name"]
        is_transfer <- map["is_transfer"]
        swift_code <- map["swift_code"]
    
    }
}


