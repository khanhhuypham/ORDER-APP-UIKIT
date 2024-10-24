//
//  OrderRebuildViewController + extension + popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/01/2024.
//

import UIKit
import JonAlert



extension OrderRebuildViewController:TechresDelegate {
     // Thêm biến employee_id:Int
    func presentModalMoreAction(order:Order) {
        let vc = OrderActionViewController()
        vc.order = order
        vc.delegate = self
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overCurrentContext

        // 2
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                
                // 3
                sheet.detents = [.large()]
                
            }
        } else {
            // Fallback on earlier versions
        }
        present(nav, animated: true, completion: nil)
    }
}

extension OrderRebuildViewController:OrderActionViewControllerDelegate, QRCodeCashbackBillDelegate{
    
    func callBackToGetOption(option: OrderAction) {
        guard let order = viewModel.selectedOrder.value else {return}
        var completion:(() -> Void) = {}
        
        switch option{
            case .orderHistory:
                let vc = OrderHistoryViewController()
                vc.order = order
                completion = {vc.btn_back.isHidden = true}
                vc.modalPresentationStyle = .pageSheet
                present(vc, animated: true, completion: completion)
                break
            
            case .moveTable:
                let vc = DialogChooseTableViewController()
                vc.order = order
                vc.option = .moveTable
                vc.delegate = self
                vc.modalPresentationStyle = .pageSheet
                present(vc, animated: true, completion: completion)
                break
            
            case .mergeTable:
                let vc = DialogChooseTableViewController()
                vc.order = order
                vc.option = .mergeTable
                vc.delegate = self
                vc.modalPresentationStyle = .pageSheet
                present(vc, animated: true, completion: completion)
                break
                
                
            case .splitFood:
                let vc = DialogChooseTableViewController()
                vc.order = order
                vc.option = .splitFood
                vc.delegate = self
                vc.moveTableDelegate = self
                vc.modalPresentationStyle = .pageSheet
                present(vc, animated: true, completion: completion)
                break
            
            case .sharePoint:
                let vc = ChooseEmployeeNeedShareViewController()
                vc.order_id = order.id
                vc.table_name = order.table_name
                vc.modalPresentationStyle = .pageSheet
                present(vc, animated: true)
                break
            
            
            case .cancelOrder:
                closeTable(order: order)
                break
            
        }
        
     
    }
    
    func navigateToEmployeeSharePointViewController(order_id : Int, table_name:String){
//        let chooseEmployeeNeedShareViewController = ChooseEmployeeNeedShareRouter().viewController as! ChooseEmployeeNeedShareViewController
//        chooseEmployeeNeedShareViewController.order_id = order_id
//        chooseEmployeeNeedShareViewController.table_name = table_name
//        sourceView?.navigationController?.pushViewController(chooseEmployeeNeedShareViewController, animated: true)
    }
   
    
    // Thay trường employeeId -> enployee_id
    // Thêm biến employee_id:Int
    func callBackOrderActionSharePoint(order_id: Int, table_name:String, employeeId:Int) {
        if(Utils.checkRoleManagerOrder(permission: Constants.user.permissions, employeeId: employeeId)){

        }else{
            JonAlert.showError(message: "Bạn không có quyền chia điểm cho nhân viên khác hãy liên hệ quản lý để được cấp quyền.", duration: 3.0)
        }
        
    }
    

    func callBackQRCodeCashbackBill(order_id: Int, qrcode: String) {
        dLog(qrcode)
                
        let str_qrcode = qrcode.components(separatedBy: [":"])
        
        if str_qrcode[0] == "CUSTOMER_GIFT"{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.presentModalGifDetailViewController(order_id: order_id, branch_id: ManageCacheObject.getCurrentBranch().id, qrcode: qrcode)
            }
        } else {
            self.assignCustomerToBill(orderId:order_id,qrValue:qrcode)
        }
        
    }
    
}



extension OrderRebuildViewController:OrderMoveFoodDelegate{
    func callBackToSplitItem(destination_order: Order, target_order: Order,only_one:Int,isTargetActive:Int) {
        let vc = SplitFoodViewController()
        vc.delegate = self
        
        vc.order_id = destination_order.id
        vc.destination_table_id = destination_order.table_id
        vc.destination_table_name = destination_order.table_name
        vc.target_table_id = target_order.table_id
        vc.isTargetActive = isTargetActive
        vc.target_table_name = target_order.table_name
        vc.target_order_id = target_order.id
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }
    

    func callBackReload() {
        self.fetchOrders()
    }
}



extension OrderRebuildViewController{
    func presentModalDialogUpdateVersionViewController(is_require_update:Int, content:String) {
        let vc = DialogConfirmUpdateVersionViewController()
        vc.is_require_update = is_require_update
        vc.content = content
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        let nav = UINavigationController(rootViewController: vc)
        // 1
        nav.modalPresentationStyle = .overCurrentContext

        
        // 2
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                
                // 3
                sheet.detents = [.large()]
                
            }
        } else {
            // Fallback on earlier versions
        }
        // 4
       
        present(nav, animated: true, completion: nil)

    }
}



extension OrderRebuildViewController: UsedGiftDelegate{
    
    func presentModalGifDetailViewController(order_id:Int, branch_id:Int, qrcode:String) {
        let dialogGiftDetailViewController = DialogGiftDetailViewController()
        dialogGiftDetailViewController.delegate = self
        dialogGiftDetailViewController.order_id = order_id
        dialogGiftDetailViewController.qrcode = qrcode
        dialogGiftDetailViewController.branch_id = branch_id
        dialogGiftDetailViewController.view.backgroundColor = ColorUtils.blackTransparent()
        let nav = UINavigationController(rootViewController: dialogGiftDetailViewController)
        // 1
        nav.modalPresentationStyle = .overCurrentContext

        
        // 2
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                
                // 3
                sheet.detents = [.large()]
                
            }
        } else {
            // Fallback on earlier versions
        }
        // 4
        present(nav, animated: true, completion: nil)
    }
    
    func callBackUsedGift(order_id: Int) {
        var order = Order()!
        order.id = order_id
        self.viewModel.makeOrderDetailViewController(order: order)
    }
}



extension OrderRebuildViewController{
    
    func presentModalPaymentQRCodeViewController(order:Order){
        let vc = PaymentQRCodeViewController()
        vc.order = order
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
    
  
}

