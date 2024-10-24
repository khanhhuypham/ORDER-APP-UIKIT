//
//  Shift.swift
//  TechresOrder
//
//  Created by Kelvin on 14/01/2023.
//

import UIKit
import ObjectMapper

struct Shift: Mappable {
    var id = 0
    var deposit_amount = 0.0
    var deposit_cash_amount = 0.0
    var deposit_bank_amount = 0.0
    var deposit_transfer_amount = 0.0
    var return_deposit_amount = 0.0
    var return_deposit_cash_amount = 0.0
    var return_deposit_bank_amount = 0.0
    var return_deposit_transfer_amount = 0.0
    var total_top_up_card_amount = 0.0
    var total_top_up_card_cash_amount = 0.0
    var total_top_up_card_bank_amount = 0.0
    var total_top_up_card_transfer_amount = 0.0
    var in_total_amount_by_addition_fee = 0.0
    var in_cash_amount_by_addition_fee = 0.0
    var in_bank_amount_by_addition_fee = 0.0
    var in_transfer_amount_by_addition_fee = 0.0
    var out_total_amount_by_addition_fee = 0.0
    var out_cash_amount_by_addition_fee = 0.0
    var out_bank_amount_by_addition_fee = 0.0
    var out_transfer_amount_by_addition_fee = 0.0
    var total_amount = 0.0
    var cash_amount = 0.0
    var bank_amount = 0.0
    var transfer_amount = 0.0
    var debt_amount = 0.0
    var tip_amount = 0.0
    var before_cash = 0.0
    var total_cost_final = 0.0
    var total_amount_final = 0.0
    var total_receipt_amount_final = 0.0
    
    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
       id <- map["id"]
       deposit_amount <- map["deposit_amount"]
       deposit_cash_amount <- map["deposit_cash_amount"]
       deposit_bank_amount  <- map["deposit_bank_amount"]
       deposit_transfer_amount  <- map["deposit_transfer_amount"]
       return_deposit_amount  <- map["return_deposit_amount"]
       return_deposit_cash_amount  <- map["return_deposit_cash_amount"]
       return_deposit_bank_amount  <- map["return_deposit_bank_amount"]
       return_deposit_transfer_amount  <- map["return_deposit_transfer_amount"]
       total_top_up_card_amount  <- map["total_top_up_card_amount"]
       total_top_up_card_cash_amount  <- map["total_top_up_card_cash_amount"]
       total_top_up_card_bank_amount  <- map["total_top_up_card_bank_amount"]
       total_top_up_card_transfer_amount  <- map["total_top_up_card_transfer_amount"]
       in_total_amount_by_addition_fee  <- map["in_total_amount_by_addition_fee"]
       in_cash_amount_by_addition_fee  <- map["in_cash_amount_by_addition_fee"]
       in_bank_amount_by_addition_fee  <- map["in_bank_amount_by_addition_fee"]
       in_transfer_amount_by_addition_fee  <- map["in_transfer_amount_by_addition_fee"]
       out_total_amount_by_addition_fee  <- map["out_total_amount_by_addition_fee"]
       out_cash_amount_by_addition_fee  <- map["out_cash_amount_by_addition_fee"]
       out_bank_amount_by_addition_fee  <- map["out_bank_amount_by_addition_fee"]
       out_transfer_amount_by_addition_fee  <- map["out_transfer_amount_by_addition_fee"]
       total_amount  <- map["total_amount"]
       cash_amount  <- map["cash_amount"]
       bank_amount  <- map["bank_amount"]
       transfer_amount  <- map["transfer_amount"]
       debt_amount  <- map["debt_amount"]
       tip_amount  <- map["tip_amount"]
       before_cash <- map["before_cash"]
       total_cost_final  <- map["total_cost_final"]
       total_amount_final  <- map["total_amount_final"]
       total_receipt_amount_final  <- map["total_receipt_amount_final"]
   }
    
}
