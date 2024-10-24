//
//  OrderItemPrintFormatViewController + extension + MapDataForPrintFood.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/08/2024.
//

import UIKit

extension OrderItemPrintFormatViewController {
    
    func mapDataForFoodPrint(printer:Printer,order:OrderDetail,printItems:[Food]){
    
        viewModel.printItems.accept(printItems)
        switch viewModel.printType.value{
            case .new_item://1 - món mới
                lbl_title.text = "PHIẾU MỚI"
                lbl_item_name.isHidden = true
                lbl_note.isHidden = true
                lbl_ordered_quantity.isHidden = true
                lbl_used_quantity.isHidden = true
                lbl_returned_quantity.isHidden = true
                view_of_table.isHidden = false
            
            case .cancel_item: //2 - Hủy món
                lbl_title.text = "PHIẾU HUỶ"
                lbl_item_name.isHidden = true
                lbl_note.isHidden = true
                lbl_ordered_quantity.isHidden = true
                lbl_used_quantity.isHidden = true
                lbl_returned_quantity.isHidden = true
                view_of_table.isHidden = false
            
            case .return_item://  3 - trả bia
                lbl_title.text = "PHIẾU TRẢ"
                lbl_item_name.isHidden = false
                lbl_note.isHidden = false
                lbl_ordered_quantity.isHidden = false
                lbl_used_quantity.isHidden = false
                lbl_returned_quantity.isHidden = false
                view_of_table.isHidden = true
                if let item = printItems.first{
                    lbl_item_name.text = String(format:"Tên món: %@",item.name)
                    lbl_note.text = String(format:"Ghi chú: %@",item.note)
                    lbl_ordered_quantity.text = String(format:"Số lượng đã gọi: %d",Int(item.quantity) + Int(item.return_quantity_for_drink))
                    lbl_used_quantity.text = String(format:"Số lượng sử dụng: %d",Int(item.quantity))
                    lbl_returned_quantity.text = String(format:"Số lượng trả: %d",Int(item.return_quantity_for_drink))
                }
            
            
            case .print_test://  3 - trả bia
                lbl_title.text = "PHIẾU MỚI"
                lbl_item_name.isHidden = true
                lbl_note.isHidden = true
                lbl_ordered_quantity.isHidden = true
                lbl_used_quantity.isHidden = true
                lbl_returned_quantity.isHidden = true
                view_of_table.isHidden = false
            
            default:
                break
            
        }
        
        
        //========================================= map dữ liệu cho table name=========================
        lbl_table_name.text = String(format: order.is_take_away == ACTIVE ? "Bàn: MV%@" : "Bàn: %@",order.table_name)
        lbl_order_id.text = String(format: "Mã hoá đơn: #%d", order.id)
        lbl_date.text = String(format: "Ngày: %@", order.created_at)
        lbl_employee_name.text = order.employee_name
        
        tableView.reloadData()
        if printItems.count > 0{
            height_of_table.constant = 200
            for i in (0...printItems.count - 1){
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
                height_of_table.constant += CGFloat(cell?.frame.height ?? 0)
                tableView.layoutIfNeeded()
            }
            height_of_table.constant -= 200
        }else{
            height_of_table.constant = 0
        }
        
        changeTextColorForPOSPRinter(parentView:generalView,textColor:textColor,bgColor: .black)
    }
    

    
    private func changeTextColorForPOSPRinter(parentView:UIView,textColor:UIColor,bgColor:UIColor) {
        
        if parentView.subviews.count > 0{
            
            parentView.subviews.forEach{(view) in
                
                view.backgroundColor = bgColor
                
                if let label = view as? UILabel {
                    
                    label.textColor = textColor
                    
                    switch label.tag{
                        case 0:
                            label.font = UIFont.systemFont(ofSize: 18, weight: .light)
                        case 1:
                            label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
                        case 2:
                            label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
                        default:
                            label.font = UIFont.systemFont(ofSize: 18, weight: .light)
                    }
                }
                self.changeTextColorForPOSPRinter(parentView:view, textColor:textColor, bgColor:bgColor)
            }
        }
    }
      
}
