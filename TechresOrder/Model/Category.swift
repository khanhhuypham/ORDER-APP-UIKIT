//
//  Category.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit
import ObjectMapper

struct Category: Mappable {
    var id = 0
    var name = ""
    var code = ""
    var description = ""
    var status = 0
    
    private var category_type = 0 {
        didSet{
            categoryType = CATEGORY_TYPE.setValue(value: category_type)
        }
    }
    
    var categoryType:CATEGORY_TYPE = .processed
    
    /*
        biến này chỉ sử dụng riêng cho module ReportBusinessAnalystic
        vì api của module này dùng chung với model category
        
        biến này sẽ dc chỉnh sửa lại sau khi có thời gian
     */
    var type = 0
    
    
    var isSelected = DEACTIVE
    init?(map: Map) {}
    
    init?() {
    }

   mutating func mapping(map: Map) {
       id                  <- map["id"]
       name                <- map["name"]
       code                <- map["code"]
       description          <- map["description"]
       status              <- map["status"]
       category_type        <- map["category_type"]
       
       type <- map["category_type"]
    }
}
