//
//  OrderHistoryDetailOfFoodAppViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/08/2024.
//

import UIKit

class OrderHistoryDetailOfFoodAppViewController: BaseViewController {
    
    var viewModel = OrderHistoryDetailOfFoodAppViewModel()
    var router = OrderHistoryDetailOfFoodAppRouter()
    var order = FoodAppOrder()

    
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var total_amount: UILabel!
    @IBOutlet weak var lbl_order_id: UILabel!
    @IBOutlet weak var lbl_display_id: UILabel!
    @IBOutlet weak var lbl_created_at: UILabel!
    @IBOutlet weak var lbl_driver_name: UILabel!
    @IBOutlet weak var lbl_customer_name: UILabel!
    @IBOutlet weak var lbl_customer_phone: UILabel!
    @IBOutlet weak var lbl_total_estimate: UILabel!
    
    @IBOutlet weak var lbl_vat: UILabel!
    
    @IBOutlet weak var lbl_customer_discount: UILabel!

    @IBOutlet weak var lbl_discount: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var height_of_table: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        bindTableViewAndRegisterCell()
        setupData(order: order)
        viewModel.order.accept(order)
        getOrderHistoryDetailOfFoodApp(id: order.id)
    }
    
    

    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    
    @IBAction func actionPrintStamp(_ sender: Any) {
        
        PrinterUtils.shared.PrintFoodAppItems(
           presenter:self,
           printers:Constants.printers.filter{$0.type == .stamp_of_food_app},
           orders:[viewModel.order.value]
        )
        
    }
    
    
    @IBAction func actionPrintReceipt(_ sender: Any) {
                
        PrinterUtils.shared.PrintFoodAppItems(
           presenter:self,
           printers:Constants.printers.filter{$0.type == .cashier_of_food_app},
           orders:[viewModel.order.value]
        )
        
    }
    
    
}
