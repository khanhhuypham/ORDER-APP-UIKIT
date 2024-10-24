//
//  ChannelList.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 11/05/2024.
//

import UIKit
import ObjectMapper



struct MediaChat: Mappable {
    var media_id = ""
    var type = 0
    var created_at = ""
    var original = MediaObjectChat()
    var medium = MediaObjectChat()
    var thumb = MediaObjectChat()
    
    var url_local = "" // Only Local
    var is_play_audio = 0
    
    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        media_id <- map["media_id"]
        type <- map["type"]
        created_at <- map["created_at"]
        original <- map["original"]
        medium <- map["medium"]
        thumb <- map["thumb"]
    }
}

struct MediaStore: Mappable{
    
    var message_id = ""
    var time = ""
    var user = UserNode()
    var media = MediaChat()
    var created_at = ""
    var position = ""
    var thumb = ThumbnailChat()
    
    var is_day_different = 0
    
    init() {}
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        message_id <- map["message_id"]
        time <- map["time"]
        user <- map["user"]
        media <- map["media"]
        created_at <- map["created_at"]
        position <- map["position"]
        thumb <- map["thumb"]
    }
}

struct MediaObjectChat: Mappable {
    var url = ""
    var name = ""
    var size = 0
    var width = 0
    var height = 0
    var link_full = ""
    
    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        url <- map["url"]
        name <- map["name"]
        size <- map["size"]
        width <- map["width"]
        height <- map["height"]
        link_full <- map["link_full"]
    }
}


struct ThumbnailChat: Mappable {
    var object_id = ""
    var domain = ""
    var title = ""
    var description = ""
    var logo = ""
    var url = ""
    var is_system = 0
    var type_system = 0
    var type = 0
    var is_thumb = 0 // is_thumb 0 là tin nhắn text , is_thumb 1 là tin nhắn link
    
    init() {
    }
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        object_id <- map["object_id"]
        description <- map["description"]
        domain <- map["domain"]
        logo <- map["logo"]
        title <- map["title"]
        url <- map["url"]
        is_system <- map["is_system"]
        type_system <- map["type_system"]
        type <- map["type"]
        is_thumb <- map["is_thumb"]
    }
}

struct UserNode: Mappable {
    var user_id = 0
    var type = 0
    var name = ""
    var avatar = ""
    var permission = 0
    var member_type = 0
    var role = RoleNode()
    var is_selected = 0
    
    init() {
    }
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        user_id <- map["user_id"]
        type <- map["type"]
        name <- map["name"]
        avatar <- map["avatar"]
        permission <- map["permission"]
        member_type <- map["member_type"]
        role <- map["role"]
        is_selected <- map["is_selected"]
    }
}

struct RoleNode: Mappable {
    var role_id = 0
    var type = ""
    var name = ""
    var avatar = ""
    
    init() {
    }
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        role_id <- map["role_id"]
        type <- map["type"]
        name <- map["name"]
        avatar <- map["avatar"]
        
    }
}
