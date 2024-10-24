//
//  OrderDetailRebuildViewController + extension + setup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 01/09/2023.
//

import UIKit
import JonAlert
extension OrderDetailViewController{
    
    func firstSetup(){

        setupSocketIO()
        view_send_chef_bar.isHidden = true
        view_update_food.isHidden = true
        viewModel.order.value.id > 0 ? getOrder() : JonAlert.showError(message: "Vui lòng mở bàn trước khi order!", duration: 2.0)
        
      
        viewModel.foodsNeedToPrint.asObservable().subscribe(onNext: { [weak self]  (list) in
            guard let self = self else { return }
            self.lbl_number_need_to_print.text = String(list.count)
            self.view_send_chef_bar.isHidden = list.count > 0 ? false : true
            
            dLog(list.count + self.viewModel.foodsNeedToUpdate.value.count)
            
        
            self.view_print_and_save.isHidden = self.view_update_food.isHidden && self.view_send_chef_bar.isHidden
        }).disposed(by: rxbag)
        
        viewModel.order.map{$0.order_details.filter{$0.isChange == ACTIVE}}.subscribe(onNext: {[weak self](list) in
            guard let self = self else { return }
            self.lbl_number_need_to_update.text = String(list.count)
            
            self.view_update_food.isHidden = list.count > 0 ? false : true
      
            self.view_print_and_save.isHidden = self.view_update_food.isHidden && self.view_send_chef_bar.isHidden
        }).disposed(by: rxbag)
        
    }
    

    func mapData(order:OrderDetail){
        
        if(order.status == ORDER_STATUS_REQUEST_PAYMENT){
            btnAddOtherFood.setImage(UIImage(named: "icon-order-detail-add-other-food-request-payment"), for: .normal)
            btnAddFood.setImage(UIImage(named: "icon-order-detail-add-food-request-payment"), for: .normal)
            btnSplitFood.setImage(UIImage(named: "icon-order-detail-split-food-request-payment"), for: .normal)
            btnAddGiftFood.setImage(UIImage(named: "icon-order-detail-add-gift-food-request-payment"), for: .normal)
            btnPaymentFood.setImage(UIImage(named: "icon-order-detail-payment-request-payment"), for: .normal)
            lbl_order_code.textColor = ColorUtils.orange_brand_900()
            lbl_total_amount.textColor = ColorUtils.orange_brand_900()
            lbl_total_estimate.textColor = ColorUtils.orange_brand_900()
        }else{
            btnAddOtherFood.setImage(UIImage(named: "icon-order-detail-add-other-food-opening"), for: .normal)
            btnAddFood.setImage(UIImage(named: "icon-order-detail-add-food-opening"), for: .normal)
            btnSplitFood.setImage(UIImage(named: "icon-order-detail-split-food-opening"), for: .normal)
            btnAddGiftFood.setImage(UIImage(named: "icon-order-detail-add-gift-food-opening"), for: .normal)
            btnPaymentFood.setImage(UIImage(named: "icon-order-detail-payment-opening"), for: .normal)
            
            if order.is_take_away == ACTIVE {
                btnPaymentFood.setImage(UIImage(named: "icon-order-detail-payment-takeaway"), for: .normal)
                lbl_title_total_amount.text = "TỔNG THANH TOÁN"
            }
            
            lbl_order_code.textColor = ColorUtils.blue_brand_700()
            
            btnAddOtherFood.isEnabled = order.booking_status == STATUS_BOOKING_SET_UP ? false : true
            btnSplitFood.isEnabled = order.booking_status == STATUS_BOOKING_SET_UP ? false : true
            btnAddGiftFood.isEnabled = order.booking_status == STATUS_BOOKING_SET_UP ? false : true
            view_print_bill_and_payment.isHidden = order.is_take_away == ACTIVE ? false : true
        }
        
      
        if(ManageCacheObject.getSetting().is_hide_total_amount_before_complete_bill == ACTIVE && !Utils.checkRoleOwnerAndGeneralManager(permission: ManageCacheObject.getCurrentUser().permissions)){

            lbl_total_estimate.text = order.amount > 1000
            ? Utils.hideTotalAmount(amount: Float(order.amount))
            : Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: order.amount)
            
            lbl_total_amount.text = order.total_amount > 1000
            ? Utils.hideTotalAmount(amount: Float(order.total_amount))
            : Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: order.total_amount)
            
        }else{
            lbl_total_estimate.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: order.amount)
            lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: order.total_amount)
        }
        
    
        
        if(order.status == ORDER_STATUS_REQUEST_PAYMENT){
            btnBack.setImage(UIImage(named: "icon-prev"), for: .normal)
        }
    
        lbl_order_code.text = String(format:order.is_take_away == ACTIVE ? "#%d - MV%@" : "#%d - %@", order.id, order.table_name)
        
    
        view_review_food.isHidden = order.is_allow_review == ACTIVE ? false : true
    }
    
    
    
    func repairUpdateFoods(items:[OrderItem]){
        var foodArrayNeedToUpdate = [FoodUpdate]()
        let foods = items.filter{Int($0.isChange) == ACTIVE}
        
        for food in foods{
            var foodNeedToUpdate = FoodUpdate.init()
            foodNeedToUpdate.order_detail_id = food.id
            foodNeedToUpdate.quantity = food.quantity
            foodNeedToUpdate.note = food.note
            foodNeedToUpdate.discount_percent = food.discount_percent
            foodArrayNeedToUpdate.append(foodNeedToUpdate)
        }
        viewModel.foodsNeedToUpdate.accept(foodArrayNeedToUpdate)
    }
    


}
