//
//  WorkingSessionValue.swift
//  TechresOrder
//
//  Created by Kelvin on 22/02/2023.
//

import UIKit
import ObjectMapper

struct WorkingSessionValue: Mappable {
    
    var deposit_amount : Float?
    var deposit_cash_amount : Float?
    var deposit_bank_amount : Float?
    var deposit_transfer_amount : Float?
    var return_deposit_amount : Float?
    var return_deposit_cash_amount : Float?
    var return_deposit_bank_amount : Float?
    var return_deposit_transfer_amount : Float?
    var total_top_up_card_amount : Float?
    var total_top_up_card_cash_amount : Float?
    var total_top_up_card_bank_amount : Float?
    var total_top_up_card_transfer_amount : Float?
    var in_total_amount_by_addition_fee : Float?
    var in_cash_amount_by_addition_fee : Float?
    var in_bank_amount_by_addition_fee : Float?
    var in_transfer_amount_by_addition_fee : Float?
    var out_total_amount_by_addition_fee : Float?
    var out_cash_amount_by_addition_fee : Float?
    var out_bank_amount_by_addition_fee : Float?
    var out_transfer_amount_by_addition_fee : Float?
    var total_amount : Float?
    var cash_amount : Float?
    var bank_amount : Float?
    var transfer_amount : Float?
    var debt_amount : Float?
    var total_top_up_used_amount: Float? //
    var tip_amount : Float?
    var before_cash : Float?
    var total_cost_final : Float?
    var total_amount_final : Float?
    var total_receipt_amount_final : Float?
    
    var wallet_amount:Float?
    var in_wallet_amount_by_addition_fee:Float?
    var out_wallet_amount_by_addition_fee:Float?
    var deposit_wallet_amount:Float?
    var return_deposit_wallet_amount:Float?
    var total_top_up_card_wallet_amount:Float?
    
    
    init?(map: Map) {
   }
   init?() {
   }

   mutating func mapping(map: Map) {
       deposit_amount <- map["deposit_amount"]
       deposit_cash_amount <- map["deposit_cash_amount"]
       deposit_bank_amount <- map["deposit_bank_amount"]
       deposit_transfer_amount <- map["deposit_transfer_amount"]
       return_deposit_amount <- map["return_deposit_amount"]
       return_deposit_cash_amount <- map["return_deposit_cash_amount"]
       return_deposit_bank_amount <- map["return_deposit_bank_amount"]
       return_deposit_transfer_amount <- map["return_deposit_transfer_amount"]
       total_top_up_card_amount <- map["total_top_up_card_amount"]
       total_top_up_card_cash_amount <- map["total_top_up_card_cash_amount"]
       total_top_up_card_bank_amount <- map["total_top_up_card_bank_amount"]
       total_top_up_card_transfer_amount <- map["total_top_up_card_transfer_amount"]
       in_total_amount_by_addition_fee <- map["in_total_amount_by_addition_fee"]
       in_cash_amount_by_addition_fee <- map["in_cash_amount_by_addition_fee"]
       in_bank_amount_by_addition_fee <- map["in_bank_amount_by_addition_fee"]
       in_transfer_amount_by_addition_fee <- map["in_transfer_amount_by_addition_fee"]
       out_total_amount_by_addition_fee <- map["out_total_amount_by_addition_fee"]
       out_cash_amount_by_addition_fee <- map["out_cash_amount_by_addition_fee"]
       out_bank_amount_by_addition_fee <- map["out_bank_amount_by_addition_fee"]
       out_transfer_amount_by_addition_fee <- map["out_transfer_amount_by_addition_fee"]
       tip_amount <- map["tip_amount"]
       total_amount <- map["total_amount"]
       cash_amount <- map["cash_amount"]
       bank_amount <- map["bank_amount"]
       transfer_amount <- map["transfer_amount"]
       debt_amount <- map["debt_amount"]
       total_top_up_used_amount <- map["total_top_up_used_amount"]
       before_cash <- map["before_cash"]
       total_cost_final <- map["total_cost_final"]
       total_amount_final <- map["total_amount_final"]
       total_receipt_amount_final <- map["total_receipt_amount_final"]
       
       wallet_amount <- map["wallet_amount"]
       in_wallet_amount_by_addition_fee <- map["in_wallet_amount_by_addition_fee"]
       out_wallet_amount_by_addition_fee <- map["out_wallet_amount_by_addition_fee"]
       deposit_wallet_amount <- map["deposit_wallet_amount"]
       return_deposit_wallet_amount <- map["return_deposit_wallet_amount"]
       total_top_up_card_wallet_amount <- map["total_top_up_card_wallet_amount"]
       
      
   }
}

    
