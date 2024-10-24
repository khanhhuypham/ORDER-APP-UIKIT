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
//        var order = viewModel.order.value
//        
//        for (i,_) in  order.details.enumerated(){
//            order.details[i].note = "ghi chú: Phạm Khánh Huy Phạm Khánh Huy Phạm Khánh Huy Phạm Khánh Huy Phạm Khánh Huy Phạm Khánh Huy"
//            for j in 1...10{
//                order.details[i].food_options.append(OrderItemChildrenOfFoodApp(name: String(format: "Phạm Khánh Huy %d", j), quantity: 1, price: 1000))
//            }
//            
//        }
//     
//        PrinterUtils.shared.PrintFoodAppItems(
//            presenter:self,
//            printers:Constants.foodAppPrinters.filter{$0.type == .stamp},
//            order:order
//        )
        
        PrinterUtils.shared.PrintFoodAppItems(
           presenter:self,
           printers:Constants.foodAppPrinters.filter{$0.type == .stamp},
           order:viewModel.order.value
        )
    }
    
    
    @IBAction func actionPrintReceipt(_ sender: Any) {
        
//        var order = viewModel.order.value
//        
//        for (i,_) in  order.details.enumerated(){
//            order.details[i].note = "ghi chú: Phạm Khánh Huy Phạm Khánh Huy Phạm Khánh Huy Phạm Khánh Huy Phạm Khánh Huy Phạm Khánh Huy"
//            for j in 1...10{
//                order.details[i].food_options.append(OrderItemChildrenOfFoodApp(name: String(format: "Phạm Khánh Huy %d", j), quantity: 1, price: 1000))
//            }
//            
//        }
//        
//        
//        PrinterUtils.shared.PrintFoodAppItems(
//            presenter:self,
//            printers:Constants.foodAppPrinters.filter{$0.type == .cashier},
//            order:order
//        )
        
        
        PrinterUtils.shared.PrintFoodAppItems(
           presenter:self,
           printers:Constants.foodAppPrinters.filter{$0.type == .cashier},
           order:viewModel.order.value
        )
    }
    
    
}
