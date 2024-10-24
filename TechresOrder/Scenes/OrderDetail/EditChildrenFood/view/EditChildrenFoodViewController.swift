//
//  EditChildrenFoodViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 02/03/2024.
//

import UIKit

class EditChildrenFoodViewController: BaseViewController {
    var viewModel = EditChildrenFoodViewModel()
    var orderItem:OrderItem? = nil
    var orderId:Int = 0
    var completetion:(() -> Void)? = nil
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_amount: UILabel!
    @IBOutlet weak var text_field_quantity: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var height_of_table: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        bindTableViewAndRegisterCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let item = self.orderItem else{return}
        viewModel.orderItem.accept(item)
        viewModel.orderId.accept(orderId)
        mapData()
        
    }
    
    
    @IBAction func decreaseQuantity(_ sender: Any) {
        var item = viewModel.orderItem.value
        item.setQuantity(quantity: item.quantity - (item.is_sell_by_weight == ACTIVE ? 0.01 : 1))
        
        if item.quantity <= 0.01{
            item.quantity = item.is_sell_by_weight == ACTIVE ? 0.01 : 1
            Toast.show(message:item.is_sell_by_weight == ACTIVE ? "Tối thiểu là 0.01" : "Tối thiểu là 1", controller: self)
        }
        
        text_field_quantity.text = Utils.stringQuantityFormatWithNumberFloat(amount: item.quantity)
        viewModel.orderItem.accept(item)
    }
    
    @IBAction func increaseQuantity(_ sender: Any) {
        var item = viewModel.orderItem.value
        item.setQuantity(quantity: item.quantity + (item.is_sell_by_weight == ACTIVE ? 0.01 : 1))
        text_field_quantity.text = Utils.stringQuantityFormatWithNumberFloat(amount: item.quantity)
        viewModel.orderItem.accept(item)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        
        var updateItems:[FoodUpdate] = []
        let item = viewModel.orderItem.value
        
        var updateItem = FoodUpdate.init()
        updateItem.order_detail_id = item.id
        
        updateItem.quantity = item.quantity
        
        if updateItem.quantity == 0{
            updateItem.quantity = item.is_sell_by_weight == ACTIVE ? 0.01 : 1
        }
        
        
        updateItem.note = item.note
        updateItems.append(updateItem)
        
        for child in item.order_detail_additions.filter{$0.isChange == ACTIVE}{
            var updateItem = FoodUpdate.init()
            updateItem.order_detail_id = child.id
            updateItem.quantity = child.isSelected == ACTIVE ? child.quantity : 0
            updateItems.append(updateItem)
        }
        
        updateFoodsToOrder(updateFood: updateItems)
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
           dismiss(animated: true)
        }
    }
    
    
}

