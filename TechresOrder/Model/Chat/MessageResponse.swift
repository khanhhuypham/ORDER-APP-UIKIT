//
//  ChatMessage.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/05/2024.
//

import UIKit
import ObjectMapper



struct MessageResponse: Mappable {
    var message_id = ""
    var message_note = NoteChat()
    var message_type:messageType = .text
    var message = ""
    var user = UserNode()
    var user_target = [UserNode]()
    var role_target = [RoleNode]()
    var conversation = Conversation()

    var is_important = 0
    var thumb = ThumbnailChat()
    var position = ""
    var created_at = ""
    var updated_at = ""
    var sticker = StickerChat()
 

    var key_error = "\(NSDate().timeIntervalSince1970)"
    
   
    var my_reaction = 0
    var no_of_reaction = 0
    var no_of_like = 0
    var no_of_love = 0
    var no_of_haha = 0
    var no_of_wow = 0
    var no_of_sad = 0
    var no_of_angry = 0
    var media = [MediaChat]()
    var link:[String] = []
    var is_timeline:a = .deactive
    var tag_user_ids = 0
    var tag = [TagChat]()
    var message_object_interacted = MessageObjectInteracted()
    var order = OrderChat()
    var message_reminder = MessageReminder()
    var message_vote = MessageVote()
    
    // local
    var isCheckBoderMessage = 0
    var status_message:a = .deactive
    
    init?(map: Map) {
    }
    init() {}
    
    mutating func mapping(map: Map) {
        
        message_id <- map["message_id"]
        message_note <- map["message_note"]
        message_type <- map["message_type"]
        user <- map["user"]
        user_target <- map["user_target"]
        role_target <- map["role_target"]
        tag <- map["tag"]
        message <- map["message"]
        thumb <- map["thumb"]
        media <- map["media"]
        message_object_interacted <- map["message_object_interacted"]
        conversation <- map["conversation"]
        message_reminder <- map["message_reminder"]
        sticker <- map["sticker"]
        message_vote <- map["message_vote"]
        order <- map["order"]
        is_important <- map["is_important"]
        position <- map["position"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        key_error <- map["key_error"]
        is_timeline <- map["is_timeline"]
        link <- map["link"]
        
        my_reaction <- map["my_reaction"]
        no_of_reaction <- map["no_of_reaction"]
        no_of_like <- map["no_of_like"]
        no_of_love <- map["no_of_love"]
        no_of_haha <- map["no_of_haha"]
        no_of_wow <- map["no_of_wow"]
        no_of_sad <- map["no_of_sad"]
        no_of_angry <- map["no_of_angry"]
    }
}

struct NoteChat: Mappable{
    var message_note_id = ""
    var content = ""
    var title = ""
    var status = 0
    var created_at = ""
    
    init() {
    }
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        message_note_id <- map["message_note_id"]
        content <- map["content"]
        title <- map["title"]
        status <- map["status"]
        created_at <- map["created_at"]
    }
}


struct StickerChat: Mappable {
    var category_sticker_id = 0
    var sticker_id = 0
    var original = MediaObjectChat()
    var medium = MediaObjectChat()
    var thumb = MediaObjectChat()
    var tag = [String]()
    var created_at = ""
    var updated_at = ""
    
    var url_local = "" // Only Local
    
    init() {}
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        category_sticker_id <- map["category_sticker_id"]
        sticker_id <- map["sticker_id"]
        original <- map["original"]
        medium <- map["medium"]
        thumb <- map["thumb"]
        tag <- map["tag"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
    
}


struct TagChat: Mappable {
    var user = UserNode()
    var key = ""
    
    init() {
    }
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        user <- map["user"]
        if let keyValue = map["key"].currentValue {
            if let stringKey = keyValue as? String {
                key = stringKey
            } else if let intKey = keyValue as? Int {
                key = String(intKey)
            }
        }
    }
}



struct MessageObjectInteracted: Mappable{
    var message_id = ""
    var message = ""
    var message_type = 0
    var media = [MediaChat]()
    var tag = [TagChat]()
    var thumb = ThumbnailChat()
    var user = UserNode()
    var position = ""
    var sticker = StickerChat()
    
    init() {
    }
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        message_id <- map["message_id"]
        message <- map["message"]
        message_type <- map["message_type"]
        media <- map["media"]
        tag <- map["tag"]
        thumb <- map["thumb"]
        user <- map["user"]
        position <- map["position"]
        sticker <- map["sticker"]
    }
}


struct Conversation: Mappable{
    var conversation_id = ""
    var name = ""
    var type = 0
    var object_type = 0
    var no_of_member = 0
    var position = 0
    var last_activity = ""
    var is_notify = 1
    var is_send_message = 1
    var my_permission = 1
    var branch_id = ""
    var brand_id = ""
    var restaurant_id = ""
    var supplier_id = ""
    var avatar = MediaChat()
    
    init (){
    }
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        conversation_id <- map["conversation_id"]
        name <- map["name"]
        type <- map["type"]
        object_type <- map["object_type"]
        no_of_member <- map["no_of_member"]
        position <- map["position"]
        last_activity <- map["last_activity"]
        is_notify <- map["is_notify"]
        is_send_message <- map["is_send_message"]
        branch_id <- map["branch_id"]
        brand_id <- map["brand_id"]
        restaurant_id <- map["restaurant_id"]
        supplier_id <- map["supplier_id"]
        avatar <- map["avatar"]
        my_permission <- map["my_permission"]
    }
}


struct OrderChat: Mappable{
    var id = 0
    var code = ""
    var status = 0
    var received_at = ""
    var created_at = ""
    var total_amount_reality = 0
    var total_amount = 0
    var order_platform = 0
    
    init() {
    }
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        code <- map["code"]
        status <- map["status"]
        received_at <- map["received_at"]
        created_at <- map["created_at"]
        total_amount_reality <- map["total_amount_reality"]
        total_amount <- map["total_amount"]
        order_platform <- map["order_platform"]
    }
}



struct MessageReminder: Mappable{
    var message_reminder_id = 0
    var content = ""
    var time = ""
    var user = UserNode()
    var type_repeat = ""
    var status = 0
    var no_of_join = 0
    var no_of_reject = 0
    var my_registration = 0
    var is_event = 0
    var created_at = ""
    
    init() {
    }
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        message_reminder_id <- map["message_reminder_id"]
        content <- map["content"]
        time <- map["time"]
        type_repeat <- map["type_repeat"]
        status <- map["status"]
        no_of_join <- map["no_of_join"]
        no_of_reject <- map["no_of_reject"]
        my_registration <- map["my_registration"]
        is_event <- map["is_event"]
        created_at <- map["created_at"]
    }
}





struct MessageVoteOption: Mappable{
    var message_vote_option_id = 0
    var no_of_vote = 0
    var content = ""
    var is_vote = 0
    var list_message_vote_user = [UserNode]()
    
    var isSelected = 0
    
    init() {
    }
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        message_vote_option_id <- map["message_vote_option_id"]
        no_of_vote <- map["no_of_vote"]
        content <- map["content"]
        is_vote <- map["is_vote"]
        list_message_vote_user <- map["list_message_vote_user"]
    }
}



struct MessageVote: Mappable {
    var message_vote_id = 0
    var content = ""
    var no_of_user_vote = 0
    var is_add_option = 0
    var no_of_option = 0
    var is_choose_many_option = 0
    var end_time = ""
    var created_at = ""
    var status = 0
    var user = UserNode()
    var is_last_vote = 0
    var total_votes = 0
    var my_vote = [Int]()
    var position = 0
    var is_pinned = 0
    var message_vote_option = [MessageVoteOption]()
    var list_message_vote_option = [MessageVoteOption]()
    
    init() {
    }
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        message_vote_id <- map["message_vote_id"]
        content <- map["content"]
        no_of_user_vote <- map["no_of_user_vote"]
        is_add_option <- map["is_add_option"]
        no_of_option <- map["no_of_option"]
        is_choose_many_option <- map["is_choose_many_option"]
        end_time <- map["end_time"]
        created_at <- map["created_at"]
        status <- map["status"]
        user <- map["user"]
        is_last_vote <- map["is_last_vote"]
        total_votes <- map["total_votes"]
        my_vote <- map["my_vote"]
        position <- map["position"]
        is_pinned <- map["is_pinned"]
        message_vote_option <- map["message_vote_option"]
        list_message_vote_option <- map["list_message_vote_option"]
    }
}
