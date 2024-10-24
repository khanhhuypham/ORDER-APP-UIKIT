//
//  ReturnFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 15/01/2023.
//

import UIKit
import JonAlert
class ReturnFoodViewController: BaseViewController {
    var viewModel = ReturnFoodViewModel()
    var router = ReturnFoodRouter()
    
    @IBOutlet weak var root_view: UIView!
    var type = 0 // 0 : return beer 1 : cancelFood
    var order_id = 0
    var order_detail_id = 0
    var quantity:Float = 0
    var total:Float = 0
    var status = 0
    @IBOutlet weak var textfield_note: UITextView!
    
    @IBOutlet weak var lbl_quantity: UILabel!
    
    var delegate:CaculatorInputQuantityDelegate?
    var delegateReturnBeer:ReturnBeerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        root_view.round(with: .both, radius: 8)
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        viewModel.order_id.accept(self.order_id)
        viewModel.order_detail_id.accept(self.order_detail_id)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        textfield_note.withDoneButton()
        

        
    }
    @IBAction func actionSub(_ sender: Any) {
        if(type == 1 && !Utils.checkRoleCancelFoodCompleted(permission: ManageCacheObject.getCurrentUser().permissions)){

            JonAlert.showError(message: "Bạn không có quyền sử dụng chức năng này.", duration: 2.0)
        }else{
            if(quantity > 1) {
                quantity = quantity - 1
                self.lbl_quantity.text =  String(format: "%.0f", quantity)
                self.viewModel.quantity.accept(Int(quantity))
            } else {

                JonAlert.showError(message: "Số lượng tối thiểu là 1", duration: 2.0)
            }
            
        }
        
//        if let number = Int(self.lbl_quantity.text!){
//            var quantity = number
//
//            quantity -= 1
//            quantity = quantity == 0 ? 1 : quantity
//            self.lbl_quantity.text = String(format: "%d", quantity)
//            self.viewModel.quantity.accept(quantity)
//        }
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        
        if(type == 1 && !Utils.checkRoleCancelFoodCompleted(permission: ManageCacheObject.getCurrentUser().permissions) && status > 0){
            JonAlert.showError(message: "Bạn không có quyền sử dụng chức năng này.", duration: 2.0)
        }else{
            if(quantity < total){
                quantity = quantity + 1
                self.lbl_quantity.text =  String(format: "%.0f", quantity)
                self.viewModel.quantity.accept(Int(quantity))

            }
        }
        
    }
    

    @IBAction func actionReturnBeer(_ sender: Any) {
        self.viewModel.note.accept(textfield_note.text)
        self.returnBeer()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    @IBAction func actionInputQuantity(_ sender: Any) {
        self.presentModalInputQuantityViewController()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
