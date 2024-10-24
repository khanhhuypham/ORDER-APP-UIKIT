//
//  OrderDetail.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 14/01/2023.
//


import ObjectMapper
struct OrderDetail: Mappable {
    
    var is_take_away = DEACTIVE
    

    var area_id = 0
    var table_id = 0
    var id = 0
    var status = 0
    var amount:Double = 0
    var total_point = 0
    var discount_percent = 0
    var vat_percent = 0
    var vat_amount = 0
    var total_amount:Double = 0
    var total_final_amount:Double = 0
    var is_allow_request_payment = 0
    var order_details = [OrderItem]()
    
    var buffet:Buffet? = nil{
        didSet{
 
            guard let buffet = self.buffet, buffet.id != 0 else {
                buffet = nil
                return
            }
                    
            
            var item = OrderItem.init()
            item.id = buffet.id
            item.buffet_ticket_id = buffet.buffet_ticket_id
            item.name = buffet.buffet_ticket_name
            item.status = FOOD_STATUS.setValue(value: buffet.status)
            item.quantity = Float(buffet.adult_quantity + buffet.child_quantity)
            item.price = buffet.adult_price
            item.total_price = Double(buffet.total_adult_amount + buffet.total_child_amount)
            item.category_type = .buffet_ticket
            item.discount_price = buffet.adult_discount_price
            item.discount_amount = buffet.adult_discount_amount
            item.discount_percent = buffet.adult_discount_percent
          
            
            if buffet.child_price != 0 {
                
               
                
                let children = [
                    OrderDetailAddition(
                        id:1,
                        name: "vé người lớn",
                        quantity: Float(buffet.adult_quantity),
                        price:buffet.adult_price,
                        total_price: buffet.total_adult_amount,
                        discountAmount: buffet.adult_discount_amount,
                        discountPercent: buffet.adult_discount_percent,
                        discountPrice: buffet.adult_discount_price
                    ),
                    
                    OrderDetailAddition(
                        id:2,
                        name: "vé trẻ em",
                        quantity: Float(buffet.child_quantity),
                        price:buffet.child_price,
                        total_price: buffet.total_child_amount,
                        discountAmount: buffet.child_discount_amount,
                        discountPercent: buffet.child_discount_percent,
                        discountPrice: buffet.child_discount_price
                    )
                ]
                
                item.discount_percent = 0
                
                item.discount_price = 0
                item.discount_price = children.map{$0.discountPrice}.reduce(0,+)
                
                item.discount_amount = 0
                item.discount_amount = children.map{$0.discountAmount}.reduce(0,+)
                
                for child in children {
                    item.order_detail_buffetTicket.append(child)
                }
            }
    
            self.order_details.append(item)
        }
    }
    var payment_date = ""
    var table_name:String = ""
    var created_at:String = ""
    var employee_name:String = ""
    var customer_slot_number = 0
    var is_share_point = 0
    var total_order_detail_customer_request = 0
    var is_apply_vat = 0
    var is_allow_review = 0
    var booking_status = 0
    var branch_address:String = ""
    var total_amount_discount_percent = 0
    var food_discount_percent = 0
    var drink_discount_percent = 0
    var food_discount_amount = 0
    var drink_discount_amount = 0
    var total_amount_extra_charge_amount = 0
    var total_amount_extra_charge_percent = 0
    var customer_name = ""
    var customer_phone = ""
    var branch_phone = ""
    var service_charge_amount = 0
    var total_amount_discount_amount = 0
    // lấy điểm số trong view payment
    var order_customer_beer_inventory_quantity = 0
    var membership_point_used = 0
    var membership_accumulate_point_used = 0
    var membership_promotion_point_used = 0
    var membership_alo_point_used = 0
    var membership_point_used_amount = 0
    var membership_accumulate_point_used_amount = 0
    var membership_promotion_point_used_amount = 0
    var membership_alo_point_used_amount = 0
    
    var booking_deposit_amount:Double = 0
    var cash_amount = 0
    var bank_amount = 0
    var transfer_amount = 0
    var wallet_amount = 0
    var tip_amount = 0
    
    init?(map: Map) {}
    init() {}
    

    init(order:Order) {
        self.id = order.id
        self.table_name = order.table_name
        self.created_at = order.created_at
        self.employee_name = order.employee.name
        self.customer_slot_number = order.using_slot
        self.status = order.order_status
        self.total_final_amount = order.total_amount
        self.is_take_away = order.is_take_away
    }
    
    
    init(table:Table) {
        self.id = table.order_id
        self.table_name = table.name
        self.table_id = table.id
        self.area_id = table.area_id
        self.is_take_away = table.is_take_away
    }

    
    mutating func mapping(map: Map) {
        id              <- map["id"]
        area_id         <- map["area_id"]
        table_id         <- map["table_id"]
        status       <- map["status"]
        is_apply_vat       <- map["is_apply_vat"]
        is_allow_review       <- map["is_allow_review"]
        amount           <- map["amount"]
        total_point           <- map["total_point"]
        discount_percent  <- map["discount_percent"]
        total_amount            <- map["total_amount"]
        total_final_amount            <- map["total_final_amount"]
        is_allow_request_payment            <- map["is_allow_request_payment"]
        order_details            <- map["order_details"]
        buffet <- map["order_buffet_ticket"]
        payment_date            <- map["payment_date"]
        table_name            <- map["table_name"]
        vat_amount            <- map["vat_amount"]
        vat_percent            <- map["vat"]
        created_at            <- map["created_at"]
        employee_name            <- map["employee_name"]
        table_name            <- map["table_name"]
        customer_slot_number    <- map["customer_slot_number"]
        is_share_point          <- map["is_share_point"]
        branch_address          <- map["branch_address"]
        total_order_detail_customer_request          <- map["total_order_detail_customer_request"]
        customer_name <- map["customer_name"]
        customer_phone <- map["customer_phone"]
        branch_phone <- map["branch_phone"]
        booking_status <- map["booking_status"]
      
        total_amount_discount_percent <- map["total_amount_discount_percent"]
        food_discount_percent <- map["food_discount_percent"]
        drink_discount_percent <- map["drink_discount_percent"]
        food_discount_amount <- map["food_discount_amount"]
        drink_discount_amount <- map["drink_discount_amount"]
        total_amount_extra_charge_amount <- map["total_amount_extra_charge_amount"]
        total_amount_extra_charge_percent <- map["total_amount_extra_charge_percent"]
        total_amount_discount_amount <- map["total_amount_discount_amount"]
        service_charge_amount <- map["service_charge_amount"]
        
        order_customer_beer_inventory_quantity <- map["order_customer_beer_inventory_quantity"]
        membership_point_used <- map["membership_point_used"]
        membership_accumulate_point_used <- map["membership_accumulate_point_used"]
        membership_promotion_point_used <- map["membership_promotion_point_used"]
        membership_alo_point_used <- map["membership_alo_point_used"]
        membership_point_used_amount <- map["membership_point_used_amount"]
        membership_accumulate_point_used_amount <- map["membership_accumulate_point_used_amount"]
        membership_promotion_point_used_amount <- map["membership_promotion_point_used_amount"]
        membership_alo_point_used_amount <- map["membership_alo_point_used_amount"]
        
        
        booking_deposit_amount <- map["booking_deposit_amount"]
        cash_amount <- map["cash_amount"]
        bank_amount <- map["bank_amount"]
        transfer_amount <- map["transfer_amount"]
        wallet_amount <- map["wallet_amount"]
        tip_amount <- map["tip_amount"]
        
        
    }
}



struct ReviewFoodData: Mappable {
    
    var order_detail_id = 0
    var score = 0
    var note = ""
    
    init?(map: Map) {
   }
   init?() {
   }

    mutating func mapping(map: Map) {
        order_detail_id                 <- map["order_detail_id"]
        score                           <- map["score"]
        note                            <- map["note"]
    }
}



struct NewOrder: Mappable {
    var order_id = 0
    init?(map: Map) {}
    mutating func mapping(map: Map) {
        order_id  <- map["order_id"]
    }
}
