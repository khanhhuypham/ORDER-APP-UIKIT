//
//  OrderActionViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 15/01/2023.
//

import UIKit
import JonAlert

class OrderActionViewController: UIViewController {

    var delegate:OrderActionViewControllerDelegate?

    
    
    
    @IBOutlet weak var root_view: UIView!
    
    var destination_table_id = 0
    var destination_table_name = ""
    var target_table_name = ""
    var target_table_id = 0
    var order_id = 0
    
    
    
    var employee = Account()
    var order:Order?
  
    
    
    @IBOutlet weak var view_of_order_history: UIView!
    @IBOutlet weak var view_of_move_table: UIView!
    @IBOutlet weak var view_of_merge_table: UIView!
    @IBOutlet weak var view_of_split_food: UIView!
    @IBOutlet weak var view_of_share_point: UIView!
    @IBOutlet weak var view_of_cancel_table: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Thêm điều kiện kiểm tra nếu là quản lý trở lên thì loại bỏ
//        if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_FOUR){
//            if(Utils.checkRoleManagerOrder(permission: ManageCacheObject.getCurrentUser().permissions, employeeId: employee.id)){
//                Utils.isHideAllView(isHide: false, view: view_of_share_point)
//            }
//        }else{
//            Utils.isHideAllView(isHide: true, view: view_of_share_point)
//        }
        
        
        if permissionUtils.OrderManager {
            view_of_order_history.isHidden = false
            view_of_move_table.isHidden = false
            view_of_merge_table.isHidden = false
            view_of_split_food.isHidden = false
            view_of_share_point.isHidden = false
            view_of_cancel_table.isHidden = false
            
          
            
            if order?.table_id == 0{
                view_of_move_table.isHidden = true
                view_of_merge_table.isHidden = true
                view_of_share_point.isHidden = true
                view_of_cancel_table.isHidden = true
            }
            
        }else{
            view_of_order_history.isHidden = false
            view_of_move_table.isHidden = true
            view_of_merge_table.isHidden = true
            view_of_split_food.isHidden = true
            view_of_share_point.isHidden = true
            view_of_cancel_table.isHidden = true
        }
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    
    }

    
    @objc func handleTapOutSide(_ gesture:UIGestureRecognizer){
         let tapLocation = gesture.location(in: root_view)
         if !root_view.bounds.contains(tapLocation){
             actionCancel("")
         }
     }
     
    
    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true)
    }
    
    
    
    
    
    @IBAction func actionOrderHistory(_ sender: Any) {
        
        delegate?.callBackToGetOption(option: .orderHistory)
        dismiss(animated: true)
    }
    
    
    @IBAction func actionMoveTable(_ sender: Any) {
        delegate?.callBackToGetOption(option: .moveTable)
        dismiss(animated: true)

        
    }
    
    
    @IBAction func actionMergeTable(_ sender: Any) {
        // check quyền trước khi thực hiện gộp bàn
        dismiss(animated: true,completion: {self.delegate?.callBackToGetOption(option: .mergeTable)})

        
    }
    @IBAction func actionMoveFood(_ sender: Any) {
        // check quyền trước khi thực hiện chuyển bàn
        dismiss(animated: true,completion: {self.delegate?.callBackToGetOption(option: .splitFood)})

        
    }
    
    @IBAction func actionSplitPoint(_ sender: Any) {
        // check quyền trước khi thực hiện chia điểm
        dismiss(animated: true,completion: {self.delegate?.callBackToGetOption(option: .sharePoint)})

    }
    
    
    @IBAction func actionCancelTable(_ sender: Any) {
        dismiss(animated: true,completion: {self.delegate?.callBackToGetOption(option: .cancelOrder)})
    }
    
}
