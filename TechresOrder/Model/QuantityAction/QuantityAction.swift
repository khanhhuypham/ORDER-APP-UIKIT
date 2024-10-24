//
//  QuantityAction.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 10/05/2024.
//


import UIKit


protocol QuantityAction {
    var quantity:Float { get set }
    var is_selected:Bool { get set }
    var min:Float { get set }
    var max:Float { get set }
    var chidrenItem:[ChidrenItem] {get set}
    var category_type:FOOD_CATEGORY {get set}
    var unit_type:String {get set}
}

//Common Implementation using protocol extension
extension QuantityAction {
    
    mutating func setQuantity(quantity:Float,is_sell_by_weight:Int = DEACTIVE,is_allow_print_stamp:Int = DEACTIVE) -> Void{
        self.quantity = quantity
        self.is_selected = true
        
        
        if self.quantity >= max{
            self.quantity = max
        }else if self.quantity == 0{
            self.deSelect()
        }
        
        if self.quantity > 0 {
            self.is_selected = true
            
            for (i,child) in chidrenItem.enumerated(){
                if child.is_selected && is_allow_print_stamp == ACTIVE{
                    chidrenItem[i].quantity = is_sell_by_weight == ACTIVE ? 1 : self.quantity
                }
            }

            if self.category_type == .service && self.quantity > 1{
                self.quantity = 1
            }
        }else{
            self.quantity = 0
            self.is_selected = false
        }
        
    }
    
    
    mutating func select() -> Void {
        is_selected = true
        if quantity <= 0 && is_selected{
            quantity = min
        }
    }
    
    
    mutating func deSelect() -> Void {
        is_selected = false
        if !is_selected{
            quantity = 0
            
            for (i,_) in chidrenItem.enumerated(){
                chidrenItem[i].deSelect()
            }
            
        }
   
        
    }
    
    
    mutating func selectChildren(id:Int) -> Void {

    }
    
    
    mutating func deSelectChildren(id:Int) -> Void {
       
    }
    
    mutating func increaseChildrenByOne(id:Int) -> Void {
        
    }
    
    mutating func decreaseChildrenByOne(id:Int) -> Void {
       
    }
    

    
 
    
    
}


struct ChidrenItem {
    var id:Int
    var name:String
    var price:Int
    var quantity:Float
    var totalAmount:Int
    var is_selected:Bool
    var min:Float?
    var max:Float?
    
    init(id: Int, name: String, price: Int, quantity: Float, totalAmount: Int, is_selected: Bool = false, min:Float? = nil, max:Float? = nil) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.totalAmount = totalAmount
        self.is_selected = is_selected
        self.min = min
        self.max = max
    }
    
    mutating func select() -> Void {
        is_selected = true
        if quantity <= 0 && is_selected{
            if let min = self.min{
                quantity = min
            }else{
                quantity = 1
            }
           
        }
    }
    
    
    mutating func deSelect() -> Void {
        is_selected = false
        
         if !is_selected{
            quantity = 0
        }
    }
    
    
    mutating func increaseByOne() -> Void {
        quantity += 1
        is_selected = quantity > 0 ? true : false
    }

    
    
    mutating func decreaseByOne() -> Void {
        quantity -= 1
        quantity = quantity > 0 ? quantity : 0
        is_selected = quantity > 0 ? true : false
    }
    
    
    
}
