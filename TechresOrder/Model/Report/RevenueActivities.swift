//
//  RevenueActivities.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import ObjectMapper

struct RevenueActivities: Mappable {
    var restaurant_id = 0
    var restaurant_brand_id = 0
    var branch_id = 0
    var total_revenue_amount_sell = 0
    var total_revenue_amount_debt = 0
    var total_revenue_amount_paided = 0
    var total_revenue_amount_waiting = 0
    var total_customer_slot_number_complete = 0

    var total_customer_slot_number_not_complete = 0
    var total_cost_amount_confirm = 0
    var total_cost_amount_not_confirm = 0
    var total_revenue_amount_deposit = 0
  
  init() {}
   init?(map: Map) {
  }


  mutating func mapping(map: Map) {
      restaurant_id                                      <- map["restaurant_id"]
      restaurant_brand_id                                    <- map["restaurant_brand_id"]
      branch_id                                   <- map["branch_id"]
      total_revenue_amount_sell                                 <- map["total_revenue_amount_sell"]
      total_revenue_amount_debt                                  <- map["total_revenue_amount_debt"]
      total_revenue_amount_paided                      <- map["total_revenue_amount_paided"]
      total_revenue_amount_waiting                          <- map["total_revenue_amount_waiting"]
      
      total_customer_slot_number_complete                         <- map["total_customer_slot_number_complete"]
      
      total_customer_slot_number_not_complete                         <- map["total_customer_slot_number_not_complete"]
      total_cost_amount_confirm                         <- map["total_cost_amount_confirm"]
      total_cost_amount_not_confirm                         <- map["total_cost_amount_not_confirm"]
     
  }
  
}
