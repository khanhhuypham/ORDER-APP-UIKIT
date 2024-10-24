//
//  ChatEnum.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/05/2024.
//

import UIKit

enum a:Int {
    case active = 1
    case deactive = 0
}

enum messageType:Int {
    case text = 1
    case image = 2
    case video = 3
    case audio = 4
    case file = 5
    case reply = 6
    case update_name = 7
    case update_avatar = 8
    case update_background = 9
    case remove_user = 10
    case add_new_user = 11
    case change_permission_order = 12
    case user_out_group = 13
    case revoke_message = 14
    case sticker = 15
    case pinned = 16
    case remove_pinned = 17
    case add_deputy = 18
    case remove_deputy = 19
    case create_vote = 20
    case vote = 21
    case change_vote = 22
    
    case add_vote_option = 23
    case block_vote = 24
    case order = 25
    case share = 26
    case new_group = 27
    
    case create_reminder = 28
    case update_reminder = 29
    case cancel_reminder = 30
    case join_reminder = 31
    case reject_reminder = 32
    case message_reminder = 33
    case message_create_note = 34
    case message_update_note = 35
    case message_remove_note = 36
//    case DATA_MESSAGE = "DATA_MESSAGE"
//    case KEY_FLOW = "KEY_FLOW"
    case pinned_vote = 37 // ghim bình chọn
    case remove_pinned_vote = 38 // gỡ ghim bình chọn
}

enum media_type:Int { // ========= Define MEDIA TYPE  ============
    case image = 0
    case video = 1
    case audio = 2
    case file = 3
    case link = 4
    case type_error = -1 // Local handle
}
