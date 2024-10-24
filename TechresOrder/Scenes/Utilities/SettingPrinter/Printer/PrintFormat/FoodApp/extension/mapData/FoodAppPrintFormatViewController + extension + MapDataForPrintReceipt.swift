//
//  FoodAppPrintFormatViewController + extension + MapDataForPrintReceipt.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/08/2024.
//

import UIKit


extension FoodAppPrintFormatViewController {
    
    func mapDataForReceiptPrint(order:FoodAppOrder){

        lbl_name_of_food_app_partner.text = order.channel_order_food_name.uppercased() + "\n"
        lbl_restaurant_name.text = ManageCacheObject.getCurrentBranch().name
        lbl_table_type.text = "(MANG ĐI)"
        lbl_order_id.text = String(format: "Đơn hàng: #%@",order.channel_order_id)
        lbl_display_id.text = String(format: "Mã khác: #%@",order.display_id)
        lbl_address.text = String(format: "Địa chỉ: %@", Constants.branch.address)
        lbl_cumtomer_service.text = String(format: "CSKH: %@", Constants.branch.phone)
        lbl_driver_name.text = order.driver_name
        lbl_driver_phone.text = order.driver_phone
        lbl_employee_name.text = Constants.user.name
        lbl_date.text = String(format: "Ngày giờ: %@", order.created_at)
        lbl_total_payment.text = order.order_amount.toString
        

        if isCustomerOrder{
            lbl_customer_order_amount.text = "Tổng tạm tính"
            lbl_customer_order_amount.text = order.customer_order_amount.toString
            view_of_restaurant_discount.isHidden = true
            view_of_customer_discount.isHidden = false
        }else{
            lbl_customer_order_amount.text = "Tổng hoá đơn"
            lbl_customer_order_amount.text = order.total_amount.toString
            view_of_restaurant_discount.isHidden = false
            view_of_customer_discount.isHidden = false
        }
        
        lbl_restaurant_discount.text = order.discount_amount.toString
        lbl_customer_discount.text =  order.customer_discount_amount.toString
        lbl_shipping_fee.text = order.shipping_fee.toString
        
       
        view_of_shipping_fee.isHidden = order.shipping_fee > 0  ? false : true
        
        lbl_total_vat.text = "0"
        
        tableView.reloadData()
        
        if order.details.count > 0{
            height_of_table.constant = 200
            for i in (0...order.details.count - 1){
                
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
                height_of_table.constant += CGFloat(cell?.frame.height ?? 0)
                tableView.layoutIfNeeded()
            }
            height_of_table.constant -= 200
        }else{
            height_of_table.constant = 0
        }
        
        changeTextColorOfView(parentView: generalView,color:textColor)
        view.layoutIfNeeded()
        addViewBorder(color: textColor, thickness: 1)
    }
    
    
    private func addViewBorder(color:UIColor,thickness:CGFloat) {
        tableView.addBorder(toEdges: [.top,.bottom], color: color, thickness: thickness)
        view_of_copy_right.addBorder(toEdges: [.top], color: color, thickness: thickness)
    }
    
    private func changeTextColorOfView(parentView:UIView,color:UIColor) {
        generalView.backgroundColor = .black
        if parentView.subviews.count > 0{
            
            parentView.subviews.forEach{(view) in
                
                view.backgroundColor = .black
                
                if let label = view as? UILabel {
                    label.textColor = color
                    
                    switch label.tag{
                        case 0:
                            label.font = UIFont.systemFont(ofSize: 16, weight: .light)
                        case 1:
                            label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                        case 2:
                            label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                        case 3:
                            label.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
                        default:
                            label.font = UIFont.systemFont(ofSize: 16, weight: .light)
                    }
                }
                self.changeTextColorOfView(parentView: view,color: color)
            }
            
        }
    }
      
}
