//
//  FoodAppPrintFormatViewController + extension + MapDataForPrintFood.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/08/2024.
//

import UIKit

extension FoodAppPrintFormatViewController {
    
    
    func mapDataForStampPrint(printer:Printer,printItems:[OrderItemOfFoodApp],infor:(total:Int,nth:Int)){
                
        switch printer.printer_paper_size{
            
            case 50:
                viewModel.limitLine.accept(5)
                if let first = printItems.first{
                    lbl_stamp1_note.numberOfLines = 2
                    lbl_stamp2_note.numberOfLines = 2
                    lbl_stamp1_children_item.numberOfLines = viewModel.limitLine.value
                    mapDatForStamp1(item: first,nth: String(format: "%d/%d", infor.nth + 1,infor.total))
                }
            
            default:
                viewModel.limitLine.accept(2)
                lbl_stamp1_item_name.numberOfLines = viewModel.limitLine.value
                lbl_stamp2_item_name.numberOfLines = viewModel.limitLine.value
                lbl_stamp1_children_item.numberOfLines = viewModel.limitLine.value
                lbl_stamp2_children_item.numberOfLines = viewModel.limitLine.value
                lbl_stamp1_note.numberOfLines = 1
                lbl_stamp2_note.numberOfLines = 1
            
                if printItems.count == 2{
                    mapDatForStamp1(item: printItems[0],nth: String(format: "%d/%d", infor.nth + 1,infor.total))
                    mapDatForStamp2( item: printItems[1],nth: String(format: "%d/%d", infor.nth + 2,infor.total))
                }else if printItems.count == 1{
                    lbl_stamp2_note.isHidden = true
//                    lbl_stamp2_FoodApp_order_id.text = ""
                    lbl_stamp2_order_id.text = ""
                    lbl_stamp2_item_name.text = ""
                    lbl_stamp2_children_item.text = ""
                    lbl_stamp2_note.text = ""
                    lbl_stamp2_price.text = ""
                    lbl_stamp2_date.text = ""
                    mapDatForStamp1(item: printItems[0],nth: String(format: "%d/%d", infor.nth + 1,infor.total))
                }
                
        }
        
        changeTextColorForTSCPrinter(printer:printer,parentView:generalView,textColor:.black,bgColor: .white)
    }
    
    
    private func mapDatForStamp1(item:OrderItemOfFoodApp,nth:String) {

        var text = ""
        
        item.food_options.enumerated().forEach{(i,value) in
            
            if i == 0{
                text += String(format: " + %@, ",  value.name)
            }else if i == item.food_options.count - 1{
                text += String(format: "%@",  value.name)
            }else{
                text += String(format: "%@, ",  value.name)
            }
                      
            
        }
        lbl_stamp1_order.text = nth
        lbl_stamp1_note.isHidden = item.note.isEmpty ? true : false
        lbl_stamp1_children_item.isHidden = text.isEmpty ? true : false
        lbl_stamp1_item_name.text = item.name
        lbl_stamp1_children_item.text = text
//        lbl_stamp1_FoodApp_order_id.text = String(format: "%@ %@",order.channel_order_food_code ,order.channel_order_id)
        lbl_stamp1_order_id.text = "#" + String(viewModel.order.value.display_id)
        lbl_stamp1_note.text = String(format: "(%@)", item.note)
        lbl_stamp1_price.text = "Giá: " + (item.total_price_addition/Double(item.quantity)).toString
        lbl_stamp1_date.text = viewModel.order.value.created_at
    }
    
    
    private func mapDatForStamp2(item:OrderItemOfFoodApp,nth:String) {
        var text = ""

        item.food_options.enumerated().forEach{(i,value) in

            if i == 0{
                text += String(format: " + %@,",  value.name)
            }else if i == item.food_options.count - 1{
                text += String(format: "%@",value.name)
            }else{
                text += String(format: "%@,",value.name)
            }

        }
        
        lbl_stamp2_order.text = nth
        lbl_stamp2_note.isHidden = item.note.isEmpty ? true : false
        lbl_stamp2_children_item.isHidden = text.isEmpty ? true : false
        
        
//        lbl_stamp1_FoodApp_order_id.text = String(format: "%@ %@",order.channel_order_food_code ,order.channel_order_id)
        lbl_stamp2_order_id.text = "#" + String(viewModel.order.value.id)
        lbl_stamp2_item_name.text = item.name
        lbl_stamp2_children_item.text = text
        lbl_stamp2_note.text = String(format: "(%@)", item.note)
        
        
        
        lbl_stamp2_price.text = "Giá: " + (item.total_price_addition/Double(item.quantity)).toString
        lbl_stamp2_date.text = viewModel.order.value.created_at
    }
    
   
    
    private func changeTextColorForTSCPrinter(printer:Printer,parentView:UIView,textColor:UIColor,bgColor:UIColor) {
        generalView.backgroundColor = .white
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
