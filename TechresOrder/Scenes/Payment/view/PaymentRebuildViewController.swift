//
//  PaymentRebuildViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/10/2023.
//

import UIKit
import JonAlert


class PaymentRebuildViewController: BaseViewController {
    let viewModel = PaymentRebuildViewModel()
    private let router = PaymentRebuildRouter()
    
    @IBOutlet weak var btn_back: UIButton!
    
    @IBOutlet weak var lbl_table_name: UILabel!
    @IBOutlet weak var lbl_total_payment: UILabel!
    @IBOutlet weak var lbl_order_code: UILabel!
    @IBOutlet weak var lbl_created_at: UILabel!
    @IBOutlet weak var lbl_employee_name: UILabel!
    @IBOutlet weak var lbl_customer_slot: UILabel!
    @IBOutlet weak var lbl_customer_name: UILabel!
    @IBOutlet weak var lbl_customer_phone: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var height_of_table: NSLayoutConstraint!
    
    @IBOutlet weak var view_customer_phone: UIView!
    @IBOutlet weak var view_customer_name: UIView!
    
    //===================tổng ước tính==================
    @IBOutlet weak var lbl_total_temp_payment: UILabel!
    
 
    //===================service Charge==================
    
    @IBOutlet weak var view_of_service_charge: UIView!

    @IBOutlet weak var icon_checkbox_of_service_charge: UIImageView!
    @IBOutlet weak var icon_service_charge: UIImageView!
    @IBOutlet weak var lbl_service_charge_txt: UILabel!
    @IBOutlet weak var lbl_total_service_charge: UILabel!
    
    //===================extra Charge==================
    @IBOutlet weak var view_of_extra_charge: UIView!
    @IBOutlet weak var btn_checkbox_of_extra_charge: UIButton!
    @IBOutlet weak var icon_checkbox_of_extra_charge: UIImageView!
    @IBOutlet weak var icon_extra_charge: UIImageView!
    @IBOutlet weak var lbl_extra_charge_txt: UILabel!
    @IBOutlet weak var lbl_total_extra_charge: UILabel!
    
    //===================VAT==================
    @IBOutlet weak var icon_vat: UIImageView!
    @IBOutlet weak var lbl_vat_text: UILabel!
    
    @IBOutlet weak var btn_checkbox_vat: UIButton!
    @IBOutlet weak var image_checkbox_vat: UIImageView!
    @IBOutlet weak var btn_detail_vat: UIButton!
    @IBOutlet weak var lbl_total_vat: UILabel!
    
    
    //===================Discount==================
    @IBOutlet weak var icon_discount: UIImageView!
    @IBOutlet weak var lbl_discount_text: UILabel!
    
    @IBOutlet weak var btn_show_discount_detail: UIButton!
    @IBOutlet weak var view_of_discount_detail: UIView!
    
    @IBOutlet weak var lbl_discount_percent_of_food: UILabel!
    
    @IBOutlet weak var lbl_discount_percent_of_drink: UILabel!
    //============================================
    
    
    
    @IBOutlet weak var btn_checkbox_discount: UIButton!
    @IBOutlet weak var image_checkbox_discount: UIImageView!
    
    @IBOutlet weak var lbl_discount_percent: UILabel!
    @IBOutlet weak var lbl_total_discount: UILabel!
    
    
    @IBOutlet weak var btn_checkbox_point: UIButton!
    @IBOutlet weak var image_checkbox_point: UIImageView!
    @IBOutlet weak var lbl_total_used_point: UILabel!
    @IBOutlet weak var view_total_used_point: UIView!
    
    @IBOutlet weak var lbl_order_customer_beer_inventory_quantity: UILabel!
    
    
    @IBOutlet weak var lbl_membership_point_used: UILabel!
    @IBOutlet weak var lbl_membership_point_used_amount: UILabel!
    
    
    
    @IBOutlet weak var lbl_membership_accumulate_point_used: UILabel!
    @IBOutlet weak var lbl_membership_accumulate_point_used_amount: UILabel!
    
    @IBOutlet weak var lbl_membership_promotion_point_used: UILabel!
    @IBOutlet weak var lbl_membership_promotion_point_used_amount: UILabel!
    
    
    @IBOutlet weak var lbl_membership_alo_point_used: UILabel!
    @IBOutlet weak var lbl_membership_alo_point_used_amount: UILabel!
    
    
    @IBOutlet weak var view_print: UIView!
    @IBOutlet weak var view_payment: UIView!
    
    @IBOutlet weak var btn_show_history: UIButton!
    @IBOutlet weak var btn_print_receipt: UIButton!
    @IBOutlet weak var btn_payment: UIButton!
    
    var order = OrderDetail()
    var real_time_url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        viewModel.order.accept(order)
        
        bindTableViewAndRegisterCell()
        mapDataAndCheckLvl(order:order)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSocketIO()
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)

        getOrderDetail()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let  real_time_url = String(format: "restaurants/%d/branches/%d/orders/%d",
                                    ManageCacheObject.getCurrentUser().restaurant_id,
                                    ManageCacheObject.getCurrentBranch().id,
                                    order.id)
        
        SocketIOManager.shared().socketRealTime!.emit("leave_room", real_time_url)
        

        
    }

    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    
    @IBAction func actionStickExtraChargeCheckBox(_ sender: Any) {
        if viewModel.order.value.total_amount_extra_charge_percent > 0{
            var order = viewModel.order.value
            order.total_amount_extra_charge_percent = 0
            viewModel.order.accept(order)
            applyExtraChargeOnTotalBill()
        }else{
            presentExtraChargePopup(order_id: viewModel.order.value.id)
        }
    }
    
    
    @IBAction func actionCheckVAT(_ sender: Any) {
        applyVAT(applyVAT: viewModel.order.value.is_apply_vat == ACTIVE ? DEACTIVE : ACTIVE)
    }
    
    @IBAction func actionShowDetailedVAT(_ sender: Any) {
        if(viewModel.order.value.vat_amount > 0){// Navigator to vat detail
            presentModalDetailVATViewController(order_id: viewModel.order.value.id)
        }
    }
    

    @IBAction func actionCheckDiscount(_ sender: Any) {
        if(Utils.checkRoleDiscountGifFood(permission: ManageCacheObject.getCurrentUser().permissions)){
            var order = viewModel.order.value
            
            let totalDiscount = order.total_amount_discount_amount + order.food_discount_amount + order.drink_discount_amount
            
            if(totalDiscount > 0){
                order.food_discount_percent = 0
                order.drink_discount_percent = 0
                order.total_amount_discount_percent = 0
                viewModel.order.accept(order)
                applyDiscount()
            }else{
                presentModalDiscountViewController(order_id:order.id)
            }
        }else{
            JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)
        }
    }
    
    
    @IBAction func actionShowDiscountDetail(_ sender: Any) {
        btn_show_discount_detail.isSelected = !btn_show_discount_detail.isSelected
        view_of_discount_detail.isHidden = btn_show_discount_detail.isSelected ? false : true
    }
    
  
    
    @IBAction func actionShowHistory(_ sender: Any) {
        viewModel.makeOrderHistoryViewController()
    }
    
    @IBAction func actionPrintReceipt(_ sender: Any){
        getBrandBankAccount(order: viewModel.order.value)
    }
    
    
    @IBAction func actionPay(_ sender: Any) {
        executePaymentProcedure(step: 1)
    }
    
    
}
