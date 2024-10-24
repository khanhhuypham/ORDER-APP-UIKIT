//
//  Buffet.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/04/2024.
//

import UIKit
import ObjectMapper

struct BuffetResponse :Mappable{
    var list:[Buffet] = []
    
    var limit:Int = 0
    var total_record:Int = 0
      
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        list <- map["list"]
        limit <- map["limit"]
        total_record <- map["total_record"]
    }
    
}

struct Buffet : Mappable {
    var id = 0
    var buffet_ticket_id = 0
    var restaurant_id = 0
    var restaurant_brand_id = 0
    var name = ""
    var buffet_ticket_name = ""
    var code = ""
    var adult_price = 0
    var child_price = 0
    var status = 1
    var discount = 0

    
    lazy var ticketChildren:[BuffetTicketChild] = {
        
        if child_price > 0 {
            
            var ticketArray:[BuffetTicketChild] = []
                
            ticketArray.append(BuffetTicketChild(
                   name: "Vé người lớn",
                   ticketType: .adult,
                   price: adult_price,
                   quantity: adult_quantity,
                   total_amount: total_adult_amount,
                   discountPercent: adult_discount_percent,
                   discountAmount: adult_discount_amount,
                   discountPrice: adult_discount_price
            ))

            ticketArray.append(BuffetTicketChild(
                   name: "Vé trẻ em",
                   ticketType: .children,
                   price: child_price,
                   quantity: child_quantity,
                   total_amount: total_child_amount,
                   discountPercent: child_discount_percent,
                   discountAmount: child_discount_amount,
                   discountPrice: child_discount_price
            ))
            return ticketArray
        }
        return []
    }()
    
    var restaurant_vat_config_id = 0
    var restaurant_vat_config_percent = 0
    var description = ""
    var created_at = ""
    var avatar = ""
    var avatar_thumb = ""
    var updated_at = ""
    var vat_amount = 0
    
    
    var adult_quantity = 0
    var adult_discount_percent = 0
    var adult_discount_amount = 0
    var adult_discount_price = 0

    var child_quantity = 0
    var child_discount_percent = 0
    var child_discount_amount = 0
    var child_discount_price = 0
    
    var total_adult_amount = 0
    var total_child_amount = 0
    var total_final_amount = 0
    /*------------------------*/
    var quantity = 0
  
    var isSelected = DEACTIVE
    /*------------------------*/
    
    
    
//    var center:[BuffetTicketChild] {
//           get {
//               return center
//           }
//           set(newValue) {
//               if child_price > 0 {
//                   
//                   var ticketArray:[BuffetTicketChild] = []
//                       
//                   ticketArray.append(BuffetTicketChild(
//                          name: "Vé người lớn",
//                          ticketType: .adult,
//                          price: adult_price,
//                          quantity: adult_quantity,
//                          total_amount: total_adult_amount,
//                          discountPercent: adult_discount_percent)
//                      )
//
//                   ticketArray.append(BuffetTicketChild(
//                          name: "Vé trẻ em",
//                          ticketType: .children,
//                          price: child_price,
//                          quantity: child_quantity,
//                          total_amount: total_child_amount,
//                          discountPercent: child_discount_percent)
//                      )
//                   center = ticketArray
//               }
//           }
//    }
    
    
    init(){}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        restaurant_id <- map["restaurant_id"]
        restaurant_brand_id <- map["restaurant_brand_id"]
        name <- map["name"]
        buffet_ticket_id <- map["buffet_ticket_id"]
        buffet_ticket_name <- map["buffet_ticket_name"]
        code <- map["code"]
        adult_price <- map["adult_price"]
        child_price <- map["child_price"]
        status <- map["status"]

        restaurant_vat_config_id <- map["restaurant_vat_config_id"]
        restaurant_vat_config_percent <- map["restaurant_vat_config_percent"]
        description <- map["description"]
        created_at <- map["created_at"]
        avatar <- map["avatar"]
        avatar_thumb <- map["avatar_thumb"]
        updated_at <- map["updated_at"]
        vat_amount <- map["vat_amount"]
        
        adult_quantity <- map["adult_quantity"]
        adult_discount_percent <- map["adult_discount_percent"]
        adult_discount_amount <- map["adult_discount_amount"]
        adult_discount_price <- map["adult_discount_price"]
        
        child_quantity <- map["child_quantity"]
        child_discount_percent <- map["child_discount_percent"]
        child_discount_amount <- map["child_discount_amount"]
        child_discount_price <- map["child_discount_price"]
        
        
        total_adult_amount <- map["total_adult_amount"]
        total_child_amount <- map["total_child_amount"]
        total_final_amount <- map["total_final_amount"]
    }
    
    
    
    mutating func select() -> Void {
        isSelected = ACTIVE
        if quantity <= 0 && isSelected == ACTIVE{
            quantity = 1

            if let position = ticketChildren.firstIndex(where: {$0.ticketType == .adult}){
                ticketChildren[position].select()
            }
        
        }
    }
    
    
    mutating func deSelect() -> Void {
        isSelected = DEACTIVE
        
        if isSelected == DEACTIVE{
            quantity = 0
            adult_discount_percent = 0
            child_discount_percent = 0
             
            for (i,_) in ticketChildren.enumerated(){
                ticketChildren[i].deSelect()
            }
        }
    }
    
    

    mutating func increaseByOne() -> Void {
      
        let maximumNumber = 999
       
        if self.quantity != maximumNumber{
            self.quantity += 1
        }
        
        self.quantity = self.quantity >= maximumNumber ? maximumNumber : self.quantity
        
        
        if self.quantity > 0 {
            
            self.isSelected = ACTIVE
            
            if let position = ticketChildren.firstIndex(where: {$0.ticketType == .adult}), quantity == 1{
                var ticketArray = ticketChildren
                ticketArray[position].isSelected = ACTIVE
                ticketArray[position].quantity = 1
                ticketChildren = ticketArray
            }
            
        }

    }

    
    
    mutating func decreaseByOne() -> Void {
       
        if self.quantity != 0{
            self.quantity -= 1
        }
        self.quantity = self.quantity <= 0 ? 0 : self.quantity

        
        if self.quantity > 0 {
            self.isSelected = ACTIVE
        }else{
            self.deSelect()
        }
    }
    
    
    mutating func setQuantity(quantity:Int) -> Void {
        
        let maximumNumber = 999
        self.quantity = quantity
        isSelected = ACTIVE
        
        if quantity >= maximumNumber {
            self.quantity = 999
        }
  
    }
    

    
    mutating func setDiscount(adultDiscountPercent:Int, childDiscountPercent:Int) -> Void {
    
        if ticketChildren.count > 0{
            
            if adultDiscountPercent == 0 && childDiscountPercent == 0{
                return
            }
            
            if  adultDiscountPercent > 0, let position = ticketChildren.firstIndex(where: {$0.ticketType == .adult}){
                ticketChildren[position].select()
            }
            
            if  childDiscountPercent > 0, let position = ticketChildren.firstIndex(where: {$0.ticketType == .children}){
                ticketChildren[position].select()
            }
            
            isSelected = ACTIVE
            
            
        }else{
            
            self.adult_discount_percent = adultDiscountPercent
            if isSelected == DEACTIVE{
                select()
            }
            
        }
        
    }
    

}
enum BuffetTicketType{
    case adult
    case children
}
struct BuffetTicketChild {
    var name = ""
    var price = 0
    var quantity = 0
    var total_amount = 0
    var discountPercent = 0
    var discountAmount = 0
    var discountPrice = 0
    var ticketType:BuffetTicketType = .adult
    var isSelected = DEACTIVE
    
    init(){}
    
    init(name:String,ticketType:BuffetTicketType,price:Int,quantity:Int,total_amount:Int,discountPercent:Int,discountAmount:Int,discountPrice:Int){
        self.name = name
        self.ticketType = ticketType
        self.price = price
        self.quantity = quantity
        self.total_amount = total_amount
        self.discountPercent = discountPercent
        self.discountAmount = discountAmount
        self.discountPrice = discountPrice
    }
    
    mutating func select() -> Void {
        isSelected = ACTIVE
        if quantity <= 0 && isSelected == ACTIVE{
            quantity = 1
        }
    }
    
    
    mutating func deSelect() -> Void {
        isSelected = DEACTIVE
        
         if isSelected == DEACTIVE{
            quantity = 0
            discountPercent = 0
        }
    }
    
    

    mutating func increaseByOne() -> Void {
      
        let maximumNumber = 999
       
        quantity += 1
        isSelected = ACTIVE
        
        if quantity >= maximumNumber {
            
            quantity = 999
        }
       

    }

    
    
    mutating func decreaseByOne() -> Void {
       
        quantity -= 1

        if quantity <= 0 {
            quantity = 0
            isSelected = DEACTIVE
        }
    }
    
    
    
    mutating func setQuantity(quantity:Int) -> Void {

        let maximumNumber = 999
        self.quantity = quantity
        isSelected = ACTIVE
        
        if quantity >= maximumNumber {
            self.quantity = 999
        }else if quantity == 0{
            isSelected = DEACTIVE
        }
    }
    
    
        
}
