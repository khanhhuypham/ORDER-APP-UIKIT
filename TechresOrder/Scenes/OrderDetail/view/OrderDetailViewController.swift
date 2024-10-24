//
//  OrderDetailRebuildViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/08/2023.
//

import UIKit
import JonAlert
class OrderDetailViewController: BaseViewController {

    var viewModel = OrderDetailViewModel()
    var router = OrderDetailRouter()
    let refreshControl = UIRefreshControl()
    var order = OrderDetail()

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lbl_order_code: UILabel!
    
    @IBOutlet weak var lbl_title_total_amount: UILabel!
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var view_print_and_save: UIView!
    @IBOutlet weak var view_update_food: UIView!
    @IBOutlet weak var lbl_number_need_to_update: UILabel!
    @IBOutlet weak var view_send_chef_bar: UIView!
    @IBOutlet weak var lbl_number_need_to_print: UILabel!
    @IBOutlet weak var view_review_food: UIView!


    @IBOutlet weak var view_second: UIView!
    @IBOutlet weak var lbl_total_estimate: UILabel!
    @IBOutlet weak var btnAddOtherFood: UIButton!
    @IBOutlet weak var btnAddFood: UIButton!
    @IBOutlet weak var btnSplitFood: UIButton!
    @IBOutlet weak var btnAddGiftFood: UIButton!
    @IBOutlet weak var btnPaymentFood: UIButton!
    
    @IBOutlet weak var view_action: UIView!

    @IBOutlet weak var view_print_bill_and_payment: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        viewModel.order.accept(order)
        bindTableViewAndRegisterCell()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstSetup()
    }

        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let real_time_url = String(format: "%@/%d/%@/%d/%@/%d",
                                   "restaurants",
                                   ManageCacheObject.getCurrentUser().restaurant_id,
                                   "branches", ManageCacheObject.getCurrentUser().branch_id,
                                   "orders",
                                   self.order.id)
        SocketIOManager.shared().socketRealTime!.emit("leave_room", real_time_url)
    }
    
    


    @IBAction func actionBack(_ sender: Any) {
    
        if viewModel.order.value.order_details.filter{$0.isChange == 1}.count > 0{
            presentModalDialogConfirmViewController(
                content: "Đơn hàng chưa được lưu bạn có muốn lưu lại không?",
                confirmClosure: {
                    self.actionUpdateFood("")
                    self.viewModel.makePopViewController()
                },
                cancelClosure: {
                    self.viewModel.makePopViewController()
                }
            )
        }else{
            viewModel.makePopViewController()
        }
    }
    
    

    @IBAction func actionAddOtherFood(_ sender: Any) {
        if(viewModel.order.value.booking_status != STATUS_TABLE_BOOKING || viewModel.order.value.booking_status == STATUS_BOOKING_WAITING_COMPLETE){
            //Check có quyền mới cho dùng chức năng này
            Utils.checkRoleAddCustomFood(permission: ManageCacheObject.getCurrentUser().permissions)
            ? viewModel.makeAddOtherViewController()
            : showWarningMessage(content: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý")
            
        }else{
            showWarningMessage(content: "Bàn booking chưa nhận khách bạn không được phép thao tác")
        }
    }
    
    @IBAction func actionAddFood(_ sender: Any) {
        viewModel.is_gift.accept(DEACTIVE)
        viewModel.makeNavigatorAddFoodViewController()
    }
    
    @IBAction func actionSplitFood(_ sender: Any) {

        Utils.checkRoleManagerOrder(permission: ManageCacheObject.getCurrentUser().permissions)
        ? presentModalSeparateFoodViewController(order: viewModel.order.value)
        : showWarningMessage(content: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý")
    }
    
    @IBAction func actionAddGifFood(_ sender: Any) {
        // check quyền trước khi thực hiện tặng món
        if(Utils.checkRoleDiscountGifFood(permission: ManageCacheObject.getCurrentUser().permissions)){
            viewModel.is_gift.accept(ACTIVE)
            viewModel.makeNavigatorAddFoodViewController()
        }else{
            JonAlert.showError(message: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý", duration: 2.0)
        }
       
    }
    
    @IBAction func actionPayment(_ sender: Any) {
        viewModel.makePayMentViewController(is_take_away: order.is_take_away)
    }
    
    @IBAction func actionReviewFood(_ sender: Any) {
        presentModalReviewFoodViewController(order_id: viewModel.order.value.id)
    }
    
    @IBAction func actionUpdateFood(_ sender: Any) {
        repairUpdateFoods(items: viewModel.order.value.order_details)
        updateFoodsToOrder()
    }
    
    @IBAction func actionSentChefBar(_ sender: Any) {
        
        
        
        if permissionUtils.GPBH_1 || permissionUtils.GPBH_2{
            permissionUtils.GPBH_2_o_1 ? self.getOrderNeedToPrintFor2o1(print: true) : self.getFoodsNeedPrint(print: true)
        }else{
            self.getItemNeedToSendToKitchen(send:true)
        }
    
    }
    
    
    @IBAction func actionPrintBillAndPay(_ sender: Any) {

        if viewModel.foodsNeedToPrint.value.count > 0{
            presentModalDialogConfirmViewController(
                content: "Hiện tại còn món chưa gửi Bếp/Bar bạn có muốn gửi Bếp/Bar trước khi thanh toán không?",
                confirmClosure: {
                    self.actionSentChefBar("")
                }
            )
        }else{
            ManageCacheObject.getPaymentMethod().is_apply_only_cash_amount_payment_method == ACTIVE
            ? callBackToGetPaymentMethod(paymentMethod: Constants.PAYMENT_METHOD.CASH)
            : presentPaymentPopupViewController(totalPayment: viewModel.order.value.total_final_amount)
        }
    }

}
