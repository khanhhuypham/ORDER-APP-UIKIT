//
//  Config.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import Foundation
import UIKit
import ObjectMapper

struct ConfigModel: Mappable {
    var config: Config?
    
    init?(map: Map) {
    }

   
    
    mutating func mapping(map: Map) {
        config <- map["data"]
    }
}

struct Config: Mappable {
    var id: Int!
    var api_key: String!
    var ads_domain: String!
    var aloline_new_feed_content_url_path: String!
    var api_chat_aloline: String!
    var api_chat_tms: String!
    var api_domain: String!
    var api_oauth_node: String!
    var api_log: String!
    var api_upload: String!
    var chat_domain: String!
    var current_domain: String!
    var date_time: String!
    var install_app_url: String!
    var realtime_domain: String!
    var report_domain: String!
    var system_server: String!
    var type: String!
    var socket_conect_login = ""
    var api_upload_short: String!
    var rpk_public_key: String = ""
    
    
     init?(map: Map) {
    }
    init?() {
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        api_key <- map["api_key"]
        ads_domain <- map["ads_domain"]
        aloline_new_feed_content_url_path <- map["aloline_new_feed_content_url_path"]
        api_chat_aloline <- map["api_chat_aloline"]
        api_chat_tms <- map["api_chat_tms"]
        api_domain <- map["api_domain"]
        api_oauth_node <- map["api_oauth_node"]
        api_log <- map["api_log"]
        api_upload <- map["api_upload"]
        chat_domain <- map["chat_domain"]
        current_domain <- map["current_domain"]
        date_time <- map["date_time"]
        install_app_url <- map["install_app_url"]
        realtime_domain <- map["realtime_domain"]
        report_domain <- map["report_domain"]
        system_server <- map["system_server"]
        type <- map["type"]
        socket_conect_login <- map["socket_conect_login"]
        api_upload_short <- map["api_upload_short"]
        rpk_public_key <- map["rpk_public_key"]
    }
   
}
