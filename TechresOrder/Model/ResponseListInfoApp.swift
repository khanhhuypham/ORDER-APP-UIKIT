//
//  ResponseListInfoApp.swift
//  TECHRES-ORDER
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 08/01/2024.
//

import UIKit
import ObjectMapper

struct ResponseListInfoApp: Mappable{
    var limit = 0
    var list = [ResponseInfoApp]()
    var total_record = 0
    
    init?(map: Map) {
    }
    init?() {
    }
    
    mutating func mapping(map: Map) {
        limit <- map["limit"]
        list <- map["list"]
        total_record <- map["total_record"]
    }
}

struct ResponseInfoApp: Mappable{
    var id = 0
    var message = ""
    var app_version = ""
    var os_name = ""
    var is_require_update = 0
    var download_link = ""
    var created_at = ""
    var updated_at = ""
    var version_application_name = ""
    
    init?(map: Map) {
    }
    init?() {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        message <- map["message"]
        app_version <- map["app_version"]
        os_name <- map["os_name"]
        is_require_update <- map["is_require_update"]
        download_link <- map["download_link"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        version_application_name <- map["version_application_name"]
    }
}

