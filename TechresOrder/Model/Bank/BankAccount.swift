//
//  BankAccount.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/04/2024.
//


import ObjectMapper

struct BankAccountResponse :Mappable{
    var list:[BankAccount]?
    var limit: Int?
    var total_record:Int?
      
    init?(map: Map) {
    }
        
    mutating func mapping(map: Map) {
        list <- map["list"]
        limit <- map["limit"]
        total_record <- map["total_record"]
    }
    
}

struct BankAccount:Mappable {
    var id = 0
    var status = 0
    var restaurant_id = 0
    var restaurant_brand_id = 0
    var bank_identify_id:String = ""
    var bank_number = ""
    var bank_name = ""
    var bank_account_name = ""
    var is_default = 0
    var type = 0
    var payment_type = 0
    var is_use_static_qr = 0
    
    var qr_code = ""
    
    init?(map: Map) {}
    
    init(){}
    
    init(bank_number:String,bank_name:String,bank_account_name:String, qr_code:String ){
        self.bank_number = bank_number
        self.bank_name = bank_name
        self.bank_account_name = bank_account_name
        self.qr_code = qr_code
    }
    
    mutating func mapping(map: Map) {
       
        id <- map["id"]
        status <- map["status"]
        restaurant_id <- map["restaurant_id"]
        restaurant_brand_id <- map["restaurant_brand_id"]
        bank_identify_id <- map["bank_identify_id"]
        bank_number <- map["bank_number"]
        bank_name <- map["bank_name"]
        bank_account_name <- map["bank_account_name"]
        is_default <- map["is_default"]
        type <- map["type"]
        payment_type <- map["payment_type"]
        is_use_static_qr <- map["is_use_static_qr"]
        
        qr_code <- map["qr_code"]
    }
}


