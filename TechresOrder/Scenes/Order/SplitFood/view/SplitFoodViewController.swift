//
//  SplitFood_RebuildViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2023.
//

import UIKit
import JonAlert
class SplitFoodViewController: BaseViewController {

    var viewModel = SplitFoodViewModel()
    var router = SplitFoodRouter()
    var order_details = [OrderItem]()


    var order_id = 0
    var destination_table_id = 0
    var destination_table_name = ""
    var target_table_name = ""

    var target_table_id = 0
    var isTargetActive = STATUS_TABLE_CLOSED
    var target_order_id = 0
    var delegate:TechresDelegate?
    var only_one = 0
    @IBOutlet weak var lbl_title_move_food: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var view_no_data: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissController(_:)), name: NSNotification.Name(rawValue: "DISMISS_CONTROLLER"), object: nil)
        viewModel.bind(view: self, router: router)
        registerCellAndBindTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        root_view.roundCorners(corners: [.topLeft,.topRight], radius: 8)
        lbl_title_move_food.text = String(format: "TÁCH MÓN TỪ %@ SANG %@", destination_table_name, target_table_name)
        viewModel.order_id.accept(order_id)
        if(only_one == ACTIVE){
            self.viewModel.dataArray.accept(self.order_details)
        }else{
            getOrdersNeedMove()
        }
        
    }

    @objc func  dismissController(_ notification: Notification) {
        JonAlert.showError(message: "Món tặng không được phép thay đổi số lượng", duration: 2.0)
        dismiss(animated: true)
    }
    

    @IBAction func actionSave(_ sender: Any) {
        viewModel.destination_table_id.accept(self.destination_table_id)
        viewModel.target_table_id.accept(self.target_table_id)
        
        self.repairSplitFoods()
        
        if(viewModel.foods_move.value.count > 0 && viewModel.foods_extra_move.value.count > 0){
            moveFoodsAndExtraFoods()
        }else if(viewModel.foods_move.value.count > 0 || viewModel.foods_extra_move.value.count > 0){
            
            if(viewModel.foods_move.value.count > 0){
                moveFoods()
            }
            
            
            
            if(viewModel.foods_extra_move.value.count > 0){
                
               
                
                switch isTargetActive{
                    case STATUS_TABLE_USING:
                        viewModel.target_order_id.accept(self.target_order_id)
                        moveExtraFoods()
                    case STATUS_TABLE_CLOSED:
                        JonAlert.showError(message: "Phụ thu không được chuyển sang bàn chưa có hoá đơn", duration: 2.0)
              
                    default:
                        break
                }
                
            }
            
          
            
           
          
            
            
            
            dismiss(animated: true)
        }else{
            JonAlert.showError(message: "Hãy chọn món cần tách trước khi lưu lại!", duration: 2.0)
        }
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
  
}
