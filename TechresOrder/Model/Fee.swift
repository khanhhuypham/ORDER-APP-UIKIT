//
//  Fee.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit
import ObjectMapper


struct FeeResponse:Mappable{
    var limit: Int?
    var data = [FeeData]()
    var total_record:Int?
      
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        limit <- map["limit"]
        data <- map["data"]
        total_record <- map["total_record"]
    }
    
}


struct FeeData: Mappable {
    var reportType = 0
    var dateString = ""
    var fees: [Fee]?
    
    var reportData: [Fee] = []
    
    init?(map: Map) {
    }
    
    init(reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
    }
    
    mutating func mapping(map: Map) {
        fees <- map["list"]
        reportData <- map["list"]
    }
}


struct Fee: Mappable {
    var id: Int = 0
    var code = ""
    var icon = ""
    var type = 0
    var amount:Float = 0
    var note = ""
    var date = ""
    var status = 0
    var created_at = ""
    var updated_at = ""
    var branch = Branch()
    var employee = Account()
    var employee_edit = Account()
    var employee_confirm = Account()
    var type_name = ""
    var payment_method_id = 0
    var payment_method = ""
    var reason_id = 0
    var reason_type_id = 0
    var reason_name = ""
    var object_type = ""
    var object_name = ""
    var object_name_prefix = ""
    var object_name_normalize_name = ""
    var object_id = 0
    var object_type_id = 0
    var addition_fee_reason_type_id = 0
    var warehouse_session_ids = [Int]()
    var status_text = ""
    var is_count_to_revenue = 0
    var is_count_to_revenue_name = ""
    var is_automatically_generated = 0
    var is_automatically_generated_name = ""
    var automatically_generated_type = 0
    var automatically_generated_type_name = ""
    var addition_fee_status = -1
    
    
    var isSelect = 0 //local
    
    init?(map: Map) {
    }
    
    init(){}
    
    init(id:Int,objectName:String,icon:String){
        self.id = id
        self.object_name = objectName
        self.icon = icon
    }

   mutating func mapping(map: Map) {
       id                                                                              <- map["id"]
       code                                                                            <- map["code"]
       type                                                                            <- map["type"]
       amount                                                                          <- map["amount"]
       note                                                                            <- map["note"]
       date                                                                            <- map["fee_month"]
       status                                                                          <- map["status"]
       created_at                                                                      <- map["created_at"]
       updated_at                                                                      <- map["updated_at"]
       branch                                                                          <- map["branch"]
       employee                                                                        <- map["employee"]
       employee_edit                                                                   <- map["employee_edit"]
       employee_confirm                                                                <- map["employee_confirm"]
       type_name                                                                       <- map["type_name"]
       payment_method_id                                                               <- map["payment_method_id"]
       payment_method                                                                  <- map["payment_method"]
       reason_id                                                                       <- map["addition_fee_reason_id"]
       reason_type_id                                                                  <- map["addition_fee_reason_type_id"]
       reason_name                                                                     <- map["reason_name"]
       object_type                                                                     <- map["object_type"]
       object_name                                                                     <- map["object_name"]
       object_name_prefix                                                              <- map["object_name_prefix"]
       object_name_normalize_name                                                      <- map["object_name_normalize_name"]
       object_id                                                                       <- map["object_id"]
       addition_fee_reason_type_id                                                     <- map["addition_fee_reason_type_id"]
       object_type_id                                                                  <- map["object_type_id"]
       warehouse_session_ids                                                           <- map["warehouse_session_ids"]
       status_text                                                                     <- map["status_text"]
       is_count_to_revenue                                                             <- map["is_count_to_revenue"]
       is_count_to_revenue_name                                                        <- map["is_count_to_revenue_name"]
       is_automatically_generated                                                      <- map["is_automatically_generated"]
       is_automatically_generated_name                                                 <- map["is_automatically_generated_name"]
       automatically_generated_type                                                    <- map["automatically_generated_type"]
       automatically_generated_type_name                                               <- map["automatically_generated_type_name"]
       addition_fee_status                                                             <- map["addition_fee_status"]
    }
}

