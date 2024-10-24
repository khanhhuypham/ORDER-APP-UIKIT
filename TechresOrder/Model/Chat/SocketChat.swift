//
//  SocketChat.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 15/05/2024.
//


import UIKit
import ObjectMapper
import SocketIO

struct JoinRoom: Mappable, SocketData {
    var conversation_id = ""

    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        conversation_id  <- map["conversation_id"]
    }
    
    func socketRepresentation() -> SocketData {
       return ["conversation_id": conversation_id]
   }
}

struct LeaveRoom: Mappable, SocketData {
    var conversation_id = ""

    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        conversation_id  <- map["conversation_id"]
    }
    
    func socketRepresentation() -> SocketData {
       return ["conversation_id": conversation_id]
    }
}
