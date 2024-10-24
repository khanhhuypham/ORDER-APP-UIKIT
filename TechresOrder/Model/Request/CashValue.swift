//
//  CashValue.swift
//  TechresOrder
//
//  Created by Kelvin on 22/02/2023.
//

import UIKit
import ObjectMapper
struct CashValue: Mappable {
    var value = 0
    var quantity = 0

    
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        value       <- map["value"]
        quantity       <- map["quantity"]
       
    }
    
}
