//
//  Media.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 03/02/2023.
//

import UIKit
import ObjectMapper

struct Media: Mappable{
    var name : String?
    var type : media_type?
    var size : Int?
    var width : Int?
    var height : Int?
    var is_keep : Int?
    var media_id : String?
    var url: URL? = nil
    init() {}
    
    init(media_id:String? = nil,name:String? = nil,type:media_type? = nil,url:URL? = nil,size:Int? = nil,width:Int? = nil,height:Int? = nil,is_keep:Int? = nil) {
        self.media_id = media_id
        self.name = name
        self.type = type
        self.url = url
        self.size = size
        self.width = width
        self.height = height
        self.is_keep = is_keep
      
    }
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        name <- map["name"]
        type <- map["type"]
        size <- map["size"]
        width <- map["original"]
        height <- map["height"]
        is_keep <- map["is_keep"]
        media_id <- map["media_id"]
        
    }
    
}

struct MediaResponse:Mappable{
    var limit: Int?
    var data = [Media]()
    var total_record:Int?
      
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        limit <- map["limit"]
        data <- map["list"]
        total_record <- map["total_record"]
    }
}
struct MediaObject:Mappable{
    var media_id : String?
    var created_at :String?
    var type : Int?
    var original : MediaResouce?
    var medium : MediaResouce?
    var thumb : MediaResouce?
    
    init() {}
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        media_id <- map["media_id"]
        created_at <- map["created_at"]
        type <- map["type"]
        original <- map["original"]
        medium <- map["medium"]
        thumb <- map["thumb"]
    }
    
}

struct MediaResouce:Mappable{
    var url : String?
    var name : String?
    var width : Int?
    var height : Int?
    
    init() {}
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        url <- map["url"]
        name <- map["name"]
        width <- map["width"]
        height <- map["height"]
    }
    
}


//struct Resource{
//    var url = URL(string: "")
//    var index = 0
//}
