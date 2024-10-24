//
//  OrderItemPrintFormatViewController + extension + MapDataForPrintStamp.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/08/2024.
//

import UIKit

extension OrderItemPrintFormatViewController {

    func mapDataForStampPrint(printer:Printer,order:OrderDetail,printItems:[Food]){
        
        switch printer.printer_paper_size{
            
            case 50:
                if let first = printItems.first{
                    lbl_stamp1_children_item.numberOfLines = 7
                    mapDatForStamp1(order: order, item: first)
                }
            
            default:
                lbl_stamp1_children_item.numberOfLines = 4
                lbl_stamp2_children_item.numberOfLines = 4
                if printItems.count == 2{
                    mapDatForStamp1(order: order, item: printItems[0])
                    mapDatForStamp2(order: order, item: printItems[1])
                }else if printItems.count == 1{
                    lbl_stamp2_note.isHidden = true
                    lbl_stamp2_date.text = ""
                    lbl_stamp2_order_id.text = ""
                    lbl_stamp2_item_name.text = ""
                    lbl_stamp2_children_item.text = ""
                    lbl_stamp2_note.text = ""
                    lbl_stamp2_price.text = ""
                    mapDatForStamp1(order: order, item: printItems[0])
                }
                
        }
        
        changeTextColorForTSCPrinter(printer:printer,parentView:generalView,textColor:.black,bgColor: .white)
    }
    
    
    private func mapDatForStamp1(order:OrderDetail,item:Food) {
        lbl_stamp1_note.isHidden = item.note.isEmpty ? true : false
        lbl_stamp1_children_item.isHidden = item.addition_foods.isEmpty ? true : false
        var text1 = ""
        item.addition_foods.enumerated().forEach{(i,value) in
           
            if i != item.addition_foods.count - 1{
                text1 += String(format: " + %@ x %.0f\n",  value.name, value.quantity)
            }else{
                text1 += String(format: " + %@ x %.0f",  value.name, value.quantity)
            }
        }
        lbl_stamp1_date.text = order.created_at
        lbl_stamp1_order_id.text = "#" + String(order.id)
        lbl_stamp1_item_name.text = item.name
        lbl_stamp1_children_item.text = text1
        lbl_stamp1_note.text = String(format: "(%@)", item.note)
        lbl_stamp1_price.text = "Giá: " + Utils.stringVietnameseMoneyFormatWithNumberInt(amount:item.price)
    }
    
    
    private func mapDatForStamp2(order:OrderDetail,item:Food) {
        lbl_stamp2_note.isHidden = item.note.isEmpty ? true : false
        var text2 = ""
        item.addition_foods.enumerated().forEach{(i,value) in
            if i != item.addition_foods.count - 1{
                text2 += String(format: " + %@ x %.0f\n",  value.name, value.quantity)
            }else{
                text2 += String(format: " + %@ x %.0f",  value.name, value.quantity)
            }
        }
        lbl_stamp2_date.text = order.created_at
        lbl_stamp2_order_id.text = "#" + String(order.id)
        lbl_stamp2_item_name.text = item.name
        lbl_stamp2_children_item.text = text2
        lbl_stamp2_note.text = String(format: "(%@)", item.note)
        lbl_stamp2_price.text = "Giá: " + Utils.stringVietnameseMoneyFormatWithNumberInt(amount:item.price)
    }
    
   
    
    private func changeTextColorForTSCPrinter(printer:Printer,parentView:UIView,textColor:UIColor,bgColor:UIColor) {
        
        if parentView.subviews.count > 0{
            
            parentView.subviews.forEach{(view) in
                
                view.backgroundColor = bgColor
                
                if let label = view as? UILabel {
                    label.textColor = textColor
                   
                    switch label.tag{
                        case 1:
                            label.font = UIFont.systemFont(ofSize:printer.printer_paper_size == 50 ? 26 : 16, weight: .black)
                        case 2:
                            label.font = UIFont.systemFont(ofSize:printer.printer_paper_size == 50 ? 22 : 14, weight: .black)
                        default:
                            label.font = UIFont.systemFont(ofSize:printer.printer_paper_size == 50 ? 16 : 12, weight: .semibold)
                    }
                }
                self.changeTextColorForTSCPrinter(printer:printer,parentView:view, textColor:textColor, bgColor:bgColor)
            }
        }
    }
    
}
