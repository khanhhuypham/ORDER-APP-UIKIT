//
//  OrderRebuildTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/01/2024.
//

import UIKit
import JonAlert
class OrderRebuildTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var view_order_status: UIView!
    @IBOutlet weak var lbl_order_status: UILabel!
    @IBOutlet weak var lbl_booking_ready: UILabel!
    
    
    
    @IBOutlet weak var view_table_status: UIView!
    @IBOutlet weak var lbl_table_name: UILabel!
    @IBOutlet weak var lbl_table_merge: UILabel!


    @IBOutlet weak var lbl_total_amount: UILabel!
    @IBOutlet weak var lbl_order_code: UILabel!
    @IBOutlet weak var lbl_order_time: UILabel!
    @IBOutlet weak var lbl_number_customer_slot: UILabel!
    
    @IBOutlet weak var stackView_of_btn: UIStackView!
    @IBOutlet weak var btn_scan_bill: UIButton!
    @IBOutlet weak var btn_number_slot: UIButton!
    @IBOutlet weak var btn_payment: UIButton!
    @IBOutlet weak var btn_gif_food: UIButton!
    @IBOutlet weak var btn_more_action: UIButton!
    
    @IBOutlet weak var btn_payment_qrcode: UIButton!
    @IBOutlet weak var textField: UITextField!
    

    
    
    
    @IBAction func actionShowMoreAction(_ sender: UIButton) {
        guard let viewModel = viewModel else { return}
        viewModel.selectedOrder.accept(data)
        viewModel.view?.presentModalMoreAction(order: data ?? Order()!)

    }
    
    
    @IBAction func actionAddGiftFood(_ sender: Any) {
        guard let viewModel = viewModel else { return}
        
        if(Utils.checkRoleDiscountGifFood(permission: ManageCacheObject.getCurrentUser().permissions)){
            viewModel.makeNavigatorAddFoodViewController(order: data!)
        }else{
            viewModel.view?.showWarningMessage(content: "Hiện tại bạn chưa được cấp quyền sử dụng tính năng này. Vui lòng liên hệ quản lý để được cấp quyền!")
        }
    }
    
    @IBAction func actionNavigateToPaymentVC(_ sender: Any) {
        guard let viewModel = viewModel else { return}
        viewModel.makePayMentViewController(order:data!)
    }
    
    
    @IBAction func actionScanBill(_ sender: Any) {
        guard let viewModel = viewModel else { return}
        viewModel.makeScanBillViewController(order: data!)
    }
    
    @IBAction func actionShowPaymentQRCode(_ sender: Any) {
        guard let viewModel = viewModel, let order = self.data else { return}
        viewModel.view?.presentModalPaymentQRCodeViewController(order: order)
    }
    

    @IBAction func actionEnterSlotNumber(_ sender: Any) {
        guard let viewModel = viewModel else { return}
        
        if data!.table_id == 0{
            return
        }
        
        if permissionUtils.GPQT_3_and_above {
            if(ManageCacheObject.getSetting().is_require_update_customer_slot_in_order == ACTIVE){
                textField.becomeFirstResponder()
            }else {
                viewModel.view?.showWarningMessage(content: "Hiện tại nhà hàng chưa được bật tính năng nhập số người!")
            }
        }else{
            viewModel.view?.showWarningMessage(content: "Vui lòng nâng cấp lên giải pháp quản trị")
        }
    
    }
    
        
    
    @objc func textFieldEditingDidEnd(_ textField: UITextField) {
        let number = Int(textField.text ?? "0") ?? 0
        if(number >= 1){
            guard let viewModel = viewModel else { return}
            data?.using_slot = number
            viewModel.view?.updateCustomerNumberSlot(order: data ?? Order()!)
        }else{
            JonAlert.show(message: "Vui lòng nhật số người trên bàn phải lớn hơn 0", duration: 2.0)
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        textField.setMaxValue(maxValue: 999)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel: OrderRebuildViewModel?
    
    
    
    // MARK: - Variable -
    public var data: Order? = nil {
       didSet {
          mapdata(data: data ?? Order()!)
       }
    }
    
    
    private func mapdata(data:Order){
   
        lbl_order_time.text =  data.using_time_minutes_string
        lbl_table_merge.text = data.table_merged_names.joined(separator: ",")
        
        
        if(ManageCacheObject.getSetting().is_hide_total_amount_before_complete_bill == ACTIVE && !Utils.checkRoleOwnerAndGeneralManager(permission: ManageCacheObject.getCurrentUser().permissions)){
            lbl_total_amount.text = data.total_amount > 1000
            ? Utils.hideTotalAmount(amount: Float(data.total_amount))
            : Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: data.total_amount)
         
        }else{
            lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: data.total_amount)
        }
        
        lbl_order_code.text = String(format: "#%d", data.id)
        
        lbl_table_name.text = String(format: "%@%@",data.order_method.prefix ,data.table_name)
         
      
        textField.text = String(format: "%d", data.using_slot)
        
        
        if(data.order_status == ORDER_STATUS_REQUEST_PAYMENT){
            lbl_order_status.text = "Yêu cầu thanh toán".uppercased()
            
            view_table_status.backgroundColor = ColorUtils.orange_brand_200()
            lbl_table_name.textColor = ColorUtils.orange_brand_900()
            
            lbl_total_amount.textColor = ColorUtils.orange_brand_900()
            view_order_status.backgroundColor = ColorUtils.orange_brand_200()
            lbl_order_status.textColor = ColorUtils.orange_brand_900()
            
            btn_scan_bill.tintColor = ColorUtils.orange_brand_900()
            btn_payment.tintColor = ColorUtils.orange_brand_900()
            btn_gif_food.tintColor = ColorUtils.orange_brand_900()
            btn_more_action.tintColor = ColorUtils.orange_brand_900()
            btn_payment_qrcode.tintColor = ColorUtils.orange_brand_900()
                        
                        
            lbl_booking_ready.textColor = ColorUtils.orange_brand_900()
            textField.backgroundColor =  ColorUtils.orange_brand_200()
            textField.textColor = ColorUtils.orange_brand_900()
            btn_number_slot.isUserInteractionEnabled = true
            stackView_of_btn.isHidden = false
        }else if(data.order_status == ORDER_STATUS_WAITING_WAITING_COMPLETE){
            
            lbl_order_status.text = "Chờ thanh toán".uppercased()
           
            view_table_status.backgroundColor = ColorUtils.red_000()
            lbl_table_name.textColor = ColorUtils.red_600()
            lbl_total_amount.textColor = ColorUtils.red_600()
            view_order_status.backgroundColor = ColorUtils.red_000()
            lbl_order_status.textColor = ColorUtils.red_600()
            lbl_booking_ready.textColor = ColorUtils.red_600()
            textField.backgroundColor = ColorUtils.red_000()
            textField.textColor = ColorUtils.red_600()
            
            btn_number_slot.isUserInteractionEnabled = false
            stackView_of_btn.isHidden = true
        }else{
            lbl_order_status.text = "Đang phục vụ".uppercased()
            lbl_total_amount.textColor = ColorUtils.blue_brand_700()
            
            view_table_status.backgroundColor = ColorUtils.blue_brand_200()
            
            lbl_table_name.textColor = data.order_method.fgColor
            
            view_order_status.backgroundColor = ColorUtils.blue_brand_200()
            
            lbl_order_status.textColor = ColorUtils.blue_brand_700()
            
            
            btn_scan_bill.tintColor = ColorUtils.blue_brand_700()
            btn_payment.tintColor = ColorUtils.blue_brand_700()
            btn_gif_food.tintColor = ColorUtils.blue_brand_700()
            btn_more_action.tintColor = ColorUtils.blue_brand_700()
            btn_payment_qrcode.tintColor = ColorUtils.blue_brand_700()
                        
            lbl_booking_ready.textColor = ColorUtils.blue_brand_700()

            textField.backgroundColor = ColorUtils.blue_brand_200()
            textField.textColor = ColorUtils.blue_brand_700()
            
            btn_number_slot.isUserInteractionEnabled = true
            stackView_of_btn.isHidden = false
        }
        
        lbl_booking_ready.isHidden = data.booking_infor_id > 0 ? false : true
        btn_scan_bill.isEnabled = data.booking_status == STATUS_BOOKING_SET_UP ? false : true
        btn_gif_food.isEnabled = data.booking_status == STATUS_BOOKING_SET_UP ? false : true
        btn_more_action.isEnabled = data.booking_status == STATUS_BOOKING_SET_UP ? false : true
        
        
        btn_payment_qrcode.isHidden = (permissionUtils.GPBH_2 || permissionUtils.GPBH_3) && Constants.brand.setting?.payment_type == .pay_os ? false : true
        
 
        if(ManageCacheObject.getSetting().service_restaurant_level_id < 2){
            btn_scan_bill.isHidden = true
        }
        
        self.contentView.layoutSubviews()
        self.layoutIfNeeded()
    }
}
