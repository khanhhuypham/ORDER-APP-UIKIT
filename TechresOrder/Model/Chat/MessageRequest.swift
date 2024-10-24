//
//  MessageRequest.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 15/05/2024.
//

import UIKit
import ObjectMapper
import SocketIO

struct MessageEmit: Mappable, SocketData {

    var key_error = "\(NSDate().timeIntervalSince1970)"
    var link = [String]()
    var media = [String]()
    var message = ""
    var message_reply_id = ""
    var message_vote_id = ""
    var sticker_id = ""
    var tag = [TagChatRequest]()
    var thumb = ThumbnailChat()
    var user_target = [Int]()
    var is_important = 0
    var order_id = ""
    var code = ""
    var order_platform = ""
    var received_at = ""
    var total_amount_reality = ""
    
    // Local Event Re-Sent
    var event_emit_local = ""

    init() {}
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        key_error <- map["key_error"]
        link <- map["link"]
        media <- map["media"]
        message <- map["message"]
        message_reply_id <- map["message_reply_id"]
        message_vote_id <- map["message_vote_id"]
        sticker_id <- map["sticker_id"]
        tag <- map["tag"]
        thumb <- map["thumb"]
        user_target <- map["user_target"]
        is_important <- map["is_important"]
        order_id <- map["order_id"]
        code <- map["code"]
        order_platform <- map["order_platform"]
        received_at <- map["received_at"]
        total_amount_reality <- map["total_amount_reality"]
        event_emit_local <- map["event_emit_local"]
    }
    
    func socketRepresentation() -> SocketData {
        return [
            "key_error" : key_error,
            "link" : link,
            "media" : media,
            "message" : message,
            "message_reply_id" : message_reply_id,
            "message_vote_id" : message_vote_id,
            "sticker_id" : sticker_id,
            "tag"  : tag,
            "thumb" : thumb,
            "user_target" : user_target,
            "is_important" : is_important,
            "order_id" : order_id,
        ]
    }
}



struct TagChatRequest: Mappable {
    var user_id = 0
    var user_name = ""
    var type = 0
    var key = ""
    
    init() {
    }
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        user_id <- map["user_id"]
        type <- map["type"]
        key <- map["key"]
    }
}
