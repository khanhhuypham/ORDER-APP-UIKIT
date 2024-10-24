//
//  CloseWorkingSessionRequest.swift
//  TechresOrder
//
//  Created by Kelvin on 22/02/2023.
//

import UIKit
import ObjectMapper
struct CloseWorkingSessionRequest: Mappable {
    
    var real_amount = 0
    var cash_value = [CashValue]()
    
    
    init() {}
     init?(map: Map) {
    }
 

    mutating func mapping(map: Map) {
        real_amount       <- map["real_amount"]
        cash_value       <- map["cash_value"]
    }
    
}
