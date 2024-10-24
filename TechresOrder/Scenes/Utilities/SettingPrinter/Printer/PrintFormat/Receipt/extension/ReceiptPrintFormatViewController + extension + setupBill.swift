//
//  ReceiptPrintFormatViewController + extension + setupBill.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/05/2024.
//

import UIKit

extension ReceiptPrintFormatViewController {
    
    func setupBill(order:OrderDetail,bankAccount:BankAccount){
        let setting = ManageCacheObject.getSetting()

        lbl_name_of_food_app_partner.isHidden = true
        lbl_restaurant_name.text = ManageCacheObject.getCurrentBranch().name
        lbl_table_type.text = order.table_id == 0 ? "(Màng về)" : "(Tại bàn)"
        lbl_address.text = String(format: "Địa chỉ: %@", order.branch_address)
        lbl_cumtomer_service.text = String(format: "CSKH: %@", order.branch_phone)
        
        lbl_table_name.text = String(format: order.table_id == 0 ? "Bàn: MV%@ - #%d - Số khách: %d" : "Bàn: %@ - #%d - Số khách: %d",order.table_name,order.id,order.customer_slot_number)
        lbl_employee_name.text = order.employee_name
        lbl_saler.text = String(format: "NVKD: %@", order.employee_name)
        lbl_accumulative_point.text = String(format: "NV tích điểm: %@", order.employee_name)
        lbl_date.text = String(format: "Ngày: %@", TimeUtils.getFullCurrentDate())
        
        view_of_accumulative_point.isHidden = permissionUtils.GPBH_1 ? true : false
        view_of_saler.isHidden = permissionUtils.GPBH_1 ? true : false
        
        
        
        
        if permissionUtils.GPBH_1{
            view_of_accumulative_point.isHidden = true
            view_of_saler.isHidden = true
            lbl_title_SL.isHidden = true
            lbl_title_DG.isHidden = true
        }else{
            view_of_accumulative_point.isHidden = false
            view_of_saler.isHidden = false
            
            switch Constants.bill_type {
            case .bill2,.bill4:
                lbl_title_SL.isHidden = false
                lbl_title_DG.isHidden = false
                
            case .bill1,.bill3:
                lbl_title_SL.isHidden = true
                lbl_title_DG.isHidden = true
            }
        }
        
        
        
        
        //=================== mapping data cho món tặng==================
        var giftedAmount:Float = 0
        let giftedItems = order.order_details.filter{$0.is_gift == ACTIVE}
        
        for item in giftedItems {
            giftedAmount += Float(item.price) * item.quantity
        }
        lbl_total_gifted.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: giftedAmount)
        
        
        lbl_total_payment.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(order.amount))
        net_payment.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(order.total_final_amount))
        
        //=================== mapping data cho chi phí dịch vụ==================
        lbl_total_service_charge.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.service_charge_amount)
        
        
        //=================== mapping data cho phụ thu==================
        lbl_total_extra_charge.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.total_amount_extra_charge_amount)
        
        //=================== mapping data cho vat ==================
        lbl_total_vat.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(order.vat_amount))
        lbl_vat_title.text = setting.is_show_vat_on_items_in_bill == ACTIVE
        ? "VAT (*%VAT hiển thị sau giá món)"
        : "VAT: "
        
        view_of_vat_content.isHidden = order.is_apply_vat == ACTIVE ? true : false
        top_contraint_of_greeting_content.constant = view_of_vat_content.isHidden == true ? 16 : 8
        
        //=================== mapping data for deposit ==================
        deposit_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: order.booking_deposit_amount)
        returned_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(
            amount: order.cash_amount + order.bank_amount + order.transfer_amount + order.wallet_amount
        )
        change_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.tip_amount)
        
        //=================== mapping data for discount ==================
        
        let totalDiscount = order.total_amount_discount_amount + order.food_discount_amount + order.drink_discount_amount
        
        lbl_total_discount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(totalDiscount))
        
        
        if order.total_amount_discount_amount > 0{
            view_of_discount_detail.isHidden = true
            
            lbl_total_discount.text = String(
                format: "%@ (%d%%)",
                Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(totalDiscount)),
                order.total_amount_discount_percent
            )
            
            lbl_discount_percent.text = "(tổng bill)"
        }else if order.food_discount_amount > 0 || order.drink_discount_amount > 0{
            view_of_discount_detail.isHidden = false
            lbl_discount_percent.text = "(Theo loại món)"
            lbl_discount_percent_of_food.text = String(format:"%@ (%d%%)", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.food_discount_amount),order.food_discount_percent)
            lbl_discount_percent_of_drink.text = String(format:"%@ (%d%%)", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.drink_discount_amount),order.drink_discount_percent)
        } else{
            stack_view_of_discount.isHidden = true
        }
        
        
        
        
        if setting.is_hidden_payment_detail_in_bill == ACTIVE {
            view_of_gift.isHidden = giftedAmount == 0 ? true : false
            view_of_used_point.isHidden = order.membership_point_used_amount == 0 ? true : false
            view_of_extra_charge.isHidden = order.total_amount_extra_charge_amount == 0 ? true : false
            view_of_vat.isHidden = order.vat_amount == 0 ? true : false
            view_of_deposit.isHidden = order.booking_deposit_amount == 0 ? true : false
            view_of_change_amount.isHidden = order.tip_amount == 0 ? true : false
        }
        
        
        if !bankAccount.bank_number.isEmpty && !bankAccount.bank_name.isEmpty && !bankAccount.bank_account_name.isEmpty{
            qr_code_view.isHidden = false
            qr_code_img_view?.image = generateQRCode(from:bankAccount.qr_code)
            lbl_account_number.text = String(format: "Số tài khoản: %@", bankAccount.bank_number)
            lbl_bank.text = String(format: "Tên ngân hàng: %@", bankAccount.bank_name)
            lbl_account_holder.text = String(format: "Tên tài khoản: %@", bankAccount.bank_account_name)
        }else{
            qr_code_view.isHidden = true
        }
        
        
        
        if permissionUtils.GPBH_1{
            lbl_title_total_payment.font = UIFont.systemFont(ofSize: 18, weight: .light)
            lbl_total_payment.font = UIFont.systemFont(ofSize: 18, weight: .light)
            net_payment.font = UIFont.systemFont(ofSize: 18, weight: .light)
            title_net_payment.font = UIFont.systemFont(ofSize: 18, weight: .light)
            
            view_of_greeting.isHidden = false
            view_of_used_point.isHidden = true
            view_of_service_charge.isHidden = true
            view_of_extra_charge.isHidden = true
            view_of_deposit.isHidden = true
            view_of_change_amount.isHidden = true
            view_of_return_amount.isHidden = true
            
        }else{
            view_of_greeting.isHidden = setting.greeting_content_on_bill.isEmpty && setting.vat_content_on_bill.isEmpty ? true : false
            vat_content.text = setting.vat_content_on_bill
            greeting_content.text = setting.greeting_content_on_bill
            
            view_of_used_point.isHidden = false
            view_of_service_charge.isHidden = order.service_charge_amount > 0 ? false : true
            view_of_extra_charge.isHidden = false
            view_of_deposit.isHidden = false
            view_of_change_amount.isHidden = false
            view_of_return_amount.isHidden = false
            
            lbl_title_total_payment.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            lbl_total_payment.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            net_payment.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            title_net_payment.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            
        }
        
        tableView.reloadData()
        
        if order.order_details.count > 0{
            height_of_table.constant = 200
            for i in (0...order.order_details.count - 1){
                
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
                height_of_table.constant += CGFloat(cell?.frame.height ?? 0)
                tableView.layoutIfNeeded()
            }
            height_of_table.constant -= 200
        }else{
            height_of_table.constant = 0
        }
        
        
   
        changeTextColorOfView(parentView: contentView,color:textColor)
   
        view.layoutIfNeeded()
        addViewBorder(color: textColor, thickness: 1)
    }
    

    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    
    private func addViewBorder(color:UIColor,thickness:CGFloat) {
        qr_code_view.addBorder(toEdges: [.top,.bottom], color: color, thickness: thickness)
        tableView.addBorder(toEdges: [.top,.bottom], color: color, thickness: thickness)
        view_of_greeting.addBorder(toEdges: [.top,.bottom], color: color, thickness: thickness)
    }
    
    private func changeTextColorOfView(parentView:UIView,color:UIColor) {
        
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
                        default:
                            label.font = UIFont.systemFont(ofSize: 16, weight: .light)
                    }
                }
                self.changeTextColorOfView(parentView: view,color: color)
            }
            
        }
    }
    
}
