//
//  PaymentRebuildViewController + extension + mapdata.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/10/2023.
//

import UIKit

extension PaymentRebuildViewController {
    func mapDataAndCheckLvl(order: OrderDetail){
        mapData(order: order)
        checkLevel(order: order)
    }
    
    
    private func mapData(order: OrderDetail){
        //========================================= map dữ liệu cho table name=========================
        lbl_table_name.text = String(format: order.table_id == 0 ? "#%d - MV%@" :"#%d - %@", order.id, order.table_name)
        
        //========================================= map dữ liệu cho label tổng thanh toán=========================
        if(ManageCacheObject.getSetting().is_hide_total_amount_before_complete_bill == ACTIVE && !Utils.checkRoleOwnerAndGeneralManager(permission: ManageCacheObject.getCurrentUser().permissions)){
            if(order.total_amount > 1000){
                lbl_total_payment.text = Utils.hideTotalAmount(amount: Float(order.total_final_amount))
            }else{
                lbl_total_payment.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: order.total_final_amount)
            }
        }else{
            lbl_total_payment.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: order.total_final_amount)
        }
        
        //========================================= map dữ liệu cho label: mã đơn hàng, sớ khách, ngày tạo, nhân viên=========================
        lbl_order_code.text = String(format: "#%d", order.id)
        lbl_created_at.text = TimeUtils.getFullCurrentDate()
        lbl_employee_name.text = order.employee_name
        lbl_customer_slot.text = String(order.customer_slot_number)
        
        lbl_customer_name.text = order.customer_name
        lbl_customer_phone.text = order.customer_phone
        view_customer_phone.isHidden = order.customer_name.count > 0 ? false : true
        view_customer_name.isHidden =  order.customer_phone.count > 0 ? false : true
        
        //========================================= map dữ liệu cho tổng ước tính==================================
        if(ManageCacheObject.getSetting().is_hide_total_amount_before_complete_bill == ACTIVE && !Utils.checkRoleOwnerAndGeneralManager(permission: ManageCacheObject.getCurrentUser().permissions)){
        
            if(order.amount > 1000){
                lbl_total_temp_payment.text = Utils.hideTotalAmount(amount: Float(order.amount))
            }else{
                lbl_total_temp_payment.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: order.amount)
            }
        }else{
            lbl_total_temp_payment.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: order.amount)
        }
        
        
        //=================== mapping data cho chi phí dịch vụ==================
        view_of_service_charge.isHidden = permissionUtils.GPBH_1 ? true : false
        checkStatusOfServiceChargeView(order: order)
       
        
        //=================== mapping data cho phụ thu==================
        view_of_extra_charge.isHidden = permissionUtils.GPBH_1 ? true : false
        checkStatusOfExtraChargeView(order: order)
        lbl_total_extra_charge.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.total_amount_extra_charge_amount)
        
        //=================== mapping data cho vat ==================
        lbl_total_vat.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(order.vat_amount))
        checkStatusOfVATView(order: order)
        
        //=================== mapping data cho discount ==================
        view_total_used_point.isHidden = true
    
        checkStatusOfDiscountView(order: order)
      

        if(order.status == ORDER_STATUS_COMPLETE || order.status == ORDER_STATUS_DEBT_COMPLETE){
            /*
                từ module quản lý hoá đơn route sang module thanh toán, ta sẽ thay đổi màu chữ thành xanh lá
            */
            btn_back.setImage(UIImage(named: "icon-prev-green"), for: .normal)
            lbl_total_temp_payment.textColor = ColorUtils.green_600()
            lbl_total_payment.textColor = ColorUtils.green_600()
            lbl_table_name.textColor = ColorUtils.green_600()
            lbl_created_at.text = order.payment_date
        }
        
        
        //========================================= map dữ liệu cho label: kho bia, nạp, tích luỹ, khuyến mãi, giá trị==================================
        
        lbl_order_customer_beer_inventory_quantity.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.order_customer_beer_inventory_quantity)
        lbl_membership_point_used.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.membership_point_used)
        lbl_membership_accumulate_point_used.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.membership_accumulate_point_used)
        lbl_membership_promotion_point_used.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.membership_promotion_point_used)
        lbl_membership_alo_point_used.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.membership_alo_point_used)
     

        lbl_membership_point_used_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.membership_point_used_amount)
        lbl_membership_accumulate_point_used_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.membership_accumulate_point_used_amount)
        lbl_membership_promotion_point_used_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.membership_promotion_point_used_amount)
        lbl_membership_alo_point_used_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.membership_alo_point_used_amount)
        
        
        /* += chiều cao của cell, để heightOfTable hiển thị hết tất các cell (khi tất cả các cell của table được hiển thị).
                thì khi đó tableView.cellForRow(at: IndexPath(row: i, section: 0)) != nil
                và ta có thể lấy được chiều caò của từng cell
                note: sau khi += cell?.frame.height ?? 0 thì nhớ chạy  tableView.layoutIfNeeded() để dàn layout lại
         */
        
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
        
    }
        
    private func checkLevel(order:OrderDetail){
        let billPrinter:Printer = Constants.printers.filter{$0.type == .cashier}.first ?? Printer()


        if order.status == ORDER_STATUS_COMPLETE || order.status == ORDER_STATUS_DEBT_COMPLETE || order.status == ORDER_STATUS_CANCEL {
            //Màn hình chi tiết hóa đơn chỉ hiển thị nút in hóa đơn đối với gpbh1o3
            permissionUtils.GPBH_1 || permissionUtils.GPBH_2_o_1 ? showView(view: view_print) : showView(view: UIView())
            btn_print_receipt.isHidden = permissionUtils.GPBH_1_o_3 || permissionUtils.GPBH_2_o_1 ? false : true
         
        }else{
            /*
                    ở GPBH1
                            _if: GPBH1o1 -> show nút tính tiền
             
                            _if: GPBH1o2 -> show nút tính tiền
             
                            _if: GPBH1o3
                                         -> if: máy in bill == ACTIVE -> show nút in và thanh toán
                                         -> if: máy in bill == DEACTIVE -> show nút tính tiền
                    ở GPBH2
                            _if: GPBH2o1
                                        _if: role = owner || cashier access
                                                     -> if: máy in bill == ACTIVE -> show nút in và thanh toán
                                                     -> if: máy in bill == DEACTIVE -> show nút tính tiền
             
                                        -> if: các role còn lại -> show nút yêu cầu thanh toán
             
                            _if: GPBH2o2 -> show nút yêu cầu thanh toán
             
                            _if: GPBH2o3 -> show nút yêu cầu thanh toán
                    
                    ở GPBH3
                            _if: GPBH3 -> show nút yêu cầu thanh toán
                */
            showView(view: view_payment)
            
            if permissionUtils.GPBH_1 {
                changeBtn(type: 1)
                if permissionUtils.GPBH_1_o_3{
                    billPrinter.is_have_printer == ACTIVE
                    ? changeBtn(type: 2)
                    : changeBtn(type: 1)
                }
            }else if permissionUtils.GPBH_2 {
                changeBtn(type: 3)
                if permissionUtils.GPBH_2_o_1{
                    permissionUtils.OwnerOrCashier ? changeBtn(type: 2) : changeBtn(type: 3)
                }
            }else if permissionUtils.GPBH_3{
                changeBtn(type: 3)
            }
            
            if order.table_id == 0{
                showView(view: UIView())
            }
                      
        }

    }
    
    private func changeBtn(type:Int){
        switch type{
            case 1:
                btn_payment.setTitle(" TÍNH TIỀN", for: .normal)
                btn_payment.setImage(UIImage(named: "send_2"), for: .normal)
            case 2:
                btn_payment.setTitle(" IN HOÁ ĐƠN VÀ TÍNH TIỀN", for: .normal)
                btn_payment.setImage(UIImage(named: "icon-printer-white"), for: .normal)
            case 3:
                btn_payment.setTitle(" YÊU CẦU THANH TOÁN", for: .normal)
                btn_payment.setImage(UIImage(named: "send_2"), for: .normal)
            default:
                break
        }
      
    }

    private func showView(view:UIView){
        view_print.isHidden = true
        view_payment.isHidden = true
        view.isHidden = false
    }
    
    
    private func checkStatusOfServiceChargeView(order: OrderDetail){
        /*
            hàm này được sử dụng để thay đổi image của btn và màu chữ trong ExtraCharge view
         */
        lbl_total_service_charge.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.service_charge_amount)
        
        icon_checkbox_of_service_charge.image = UIImage(named: order.service_charge_amount > 0 ? "icon-sticked-checkbox-gray" : "icon-check-disable")
        
        if(order.status == ORDER_STATUS_COMPLETE || order.status == ORDER_STATUS_DEBT_COMPLETE){
      
            icon_service_charge.image = UIImage(named: "icon-discount-green")
            lbl_service_charge_txt.textColor = ColorUtils.green_600()
            lbl_total_service_charge.textColor = ColorUtils.green_600()
        }
 
    }
    
    
    
    private func checkStatusOfExtraChargeView(order: OrderDetail){
        /*
            hàm này được sử dụng để thay đổi image của btn và màu chữ trong ExtraCharge view
         */
        icon_checkbox_of_extra_charge.image = UIImage(named: order.total_amount_extra_charge_percent > 0 ? "check" : "icon-check-enable")
        icon_extra_charge.image = UIImage(named: "icon-discount")
        lbl_extra_charge_txt.textColor = ColorUtils.blue_brand_700()
        lbl_total_extra_charge.textColor = ColorUtils.blue_brand_700()
        
        if(order.status == ORDER_STATUS_COMPLETE || order.status == ORDER_STATUS_DEBT_COMPLETE){
            icon_checkbox_of_extra_charge.image = UIImage(named: order.total_amount_extra_charge_percent > 0 ? "icon-sticked-checkbox-gray" : "icon-check-disable")
            icon_extra_charge.image = UIImage(named: "icon-discount-green")
            btn_checkbox_of_extra_charge.isUserInteractionEnabled = false
            lbl_extra_charge_txt.textColor = ColorUtils.green_600()
            lbl_total_extra_charge.textColor = ColorUtils.green_600()
        }
        
        //nếu bàn booking đã set up chờ nhận khách thì unable nut1 check VAT và giảm giá
        if(order.booking_status == STATUS_BOOKING_SET_UP
        || !Utils.checkRoleDiscountGifFood(permission: ManageCacheObject.getCurrentUser().permissions)){
            icon_checkbox_of_extra_charge.image = UIImage(named: "icon-check-disable")
            btn_checkbox_of_extra_charge.isUserInteractionEnabled = false
        }
        
    }
    
    private func checkStatusOfVATView(order: OrderDetail){
        /*
            hàm này được sử dụng để thay đổi image của btn và màu chữ trong VAT view
         */
        
        image_checkbox_vat.image = UIImage(named: order.is_apply_vat == ACTIVE ? "check" : "icon-check-enable")
       
        if(order.status == ORDER_STATUS_COMPLETE || order.status == ORDER_STATUS_DEBT_COMPLETE){
            image_checkbox_vat.image = UIImage(named: order.is_apply_vat == ACTIVE ? "icon-sticked-checkbox-gray" : "icon-check-disable")
            btn_checkbox_vat.isUserInteractionEnabled = false
            icon_vat.image = UIImage(named: "icon-checked-vat-green")
            lbl_vat_text.textColor = ColorUtils.green_600()
            lbl_total_vat.textColor = ColorUtils.green_600()
        }
        
        //nếu bàn booking đã set up chờ nhận khách thì unable nut1 check VAT và giảm giá
        if(order.booking_status == STATUS_BOOKING_SET_UP
        || !Utils.checkRoleDiscountGifFood(permission: ManageCacheObject.getCurrentUser().permissions)){
            image_checkbox_vat.image = UIImage(named: "icon-check-disable")
            btn_checkbox_vat.isUserInteractionEnabled = false
        }
    }
    
    private func checkStatusOfDiscountView(order: OrderDetail){
        /*
            hàm này được sử dụng để thay đổi image của btn và màu chữ trong discount view
         */
        let totalDiscount = order.total_amount_discount_amount + order.food_discount_amount + order.drink_discount_amount

        lbl_total_discount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(totalDiscount))
        image_checkbox_discount.image = UIImage(named: totalDiscount > 0 ? "check" : "icon-check-enable")
        lbl_discount_percent.isHidden = totalDiscount > 0 ? false : true
        
        if(order.total_amount_discount_amount > 0){
            lbl_discount_percent.text = "(tổng bill)"
            
            lbl_total_discount.text = String(
                format: "%@ (%d%%)",
                Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(totalDiscount)),
                order.total_amount_discount_percent
            )
           
            btn_show_discount_detail.isHidden = true
        }else if order.food_discount_amount > 0 || order.drink_discount_amount > 0{
            lbl_discount_percent_of_food.text = String(format:"%@ (%d%%)", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.food_discount_amount),order.food_discount_percent)
            lbl_discount_percent_of_drink.text = String(format:"%@ (%d%%)", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: order.drink_discount_amount),order.drink_discount_percent)
            lbl_discount_percent.text = "(Theo loại món)"
            btn_show_discount_detail.isHidden = false
        }else{
            btn_show_discount_detail.isHidden = true
            view_of_discount_detail.isHidden = true
        }
        
      
        
        let point = order.order_customer_beer_inventory_quantity + order.membership_point_used + order.membership_accumulate_point_used + order.membership_promotion_point_used + order.membership_alo_point_used
        //Trường hợp có điểm nạp
        if point > 0{
            image_checkbox_discount.image = UIImage(named: "icon-check-disable")
            btn_checkbox_discount.isUserInteractionEnabled = false
            if order.membership_point_used > 0 && 
                order.order_customer_beer_inventory_quantity == 0 &&
                order.membership_accumulate_point_used == 0 &&
                order.membership_promotion_point_used == 0 &&
                order.membership_alo_point_used == 0
            {
                image_checkbox_discount.image = UIImage(named: "icon-check-enable")
                btn_checkbox_discount.isUserInteractionEnabled = true
            }
        }

        
        if(order.status == ORDER_STATUS_COMPLETE || order.status == ORDER_STATUS_DEBT_COMPLETE){
            image_checkbox_discount.image = UIImage(named: totalDiscount > 0 ? "icon-sticked-checkbox-gray" : "icon-check-disable")
            btn_checkbox_discount.isUserInteractionEnabled = false
            icon_discount.image = UIImage(named: "icon-discount-green")
            lbl_discount_text.textColor = ColorUtils.green_600()
            lbl_total_discount.textColor = ColorUtils.green_600()
        }
        
        
        //nếu bàn booking đã set up chờ nhận khách thì unable nut1 check VAT và giảm giá
        if(order.booking_status == STATUS_BOOKING_SET_UP
        || !Utils.checkRoleDiscountGifFood(permission: ManageCacheObject.getCurrentUser().permissions)){
            image_checkbox_discount.image = UIImage(named: "icon-check-disable")
            btn_checkbox_discount.isUserInteractionEnabled = false
        }
    }
    
    
    
}
