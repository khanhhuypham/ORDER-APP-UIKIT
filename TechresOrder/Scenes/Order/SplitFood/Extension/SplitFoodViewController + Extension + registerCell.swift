//
//  SplitFood_RebuildViewController + Extension + registerCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2023.
//

import UIKit
import JonAlert
extension SplitFoodViewController{
    
    func registerCellAndBindTableView(){
        registerCell()
        bindTableViewData()
    }
    
    private func registerCell() {
        let splitFoodTableViewCell = UINib(nibName: "SplitFoodTableViewCell", bundle: .main)
        tableView.register(splitFoodTableViewCell, forCellReuseIdentifier: "SplitFoodTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func bindTableViewData() {
           viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "SplitFoodTableViewCell", cellType: SplitFoodTableViewCell.self))
               {  (row, orderDetail, cell) in
                   cell.viewModel = self.viewModel
                   cell.data = orderDetail
               }.disposed(by: rxbag)
    }
}


extension SplitFoodViewController{
    func repairSplitFoods(){
        var foodSplitRequests = [FoodSplitRequest]()
        var foodSplitExtraRequests = [ExtraFoodSplitRequest]()
        let foods = viewModel.dataArray.value
        
        for food in foods{
            
            if(food.isChange > 0) {
                if(food.is_extra_Charge == ACTIVE){
                    var foodSplitExtraRequest = ExtraFoodSplitRequest.init()
                    foodSplitExtraRequest.extra_charge_id = food.id
                    foodSplitExtraRequest.quantity = food.quantity_change
                    foodSplitExtraRequests.append(foodSplitExtraRequest)
                }else{
                    var foodSplitRequest = FoodSplitRequest.init()
                    foodSplitRequest.order_detail_id = food.id
                    foodSplitRequest.quantity = food.quantity_change
                    foodSplitRequests.append(foodSplitRequest)
                }
            }
            
        }
        viewModel.foods_extra_move.accept(foodSplitExtraRequests)
        viewModel.foods_move.accept(foodSplitRequests)
    }
}


extension SplitFoodViewController:CaculatorInputQuantityDelegate{

    func presentModalInputQuantityViewController(position:Int, current_quantity:Float) {
        let quantityInputViewController = QuantityInputViewController()
        let foods = self.viewModel.dataArray.value
        quantityInputViewController.is_sell_by_weight = foods[position].is_sell_by_weight
        quantityInputViewController.current_quantity = current_quantity
        quantityInputViewController.max_quantity = foods[position].quantity
        quantityInputViewController.view.backgroundColor = ColorUtils.blackTransparent()
        let nav = UINavigationController(rootViewController: quantityInputViewController)
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
        quantityInputViewController.delegate_quantity = self
        quantityInputViewController.position = position
        present(nav, animated: true, completion: nil)
    }
      
    func callbackCaculatorInputQuantity(number:Float, position:Int,id:Int) {
        var foods = self.viewModel.dataArray.value
        let quantity = foods[position].quantity

        if(number > quantity){
        
            if(foods[position].is_sell_by_weight == ACTIVE){
                JonAlert.showError(message: String(format: "Số lượng tối đa là %.2f", quantity), duration: 2.0)
            }else{
                JonAlert.showError(message: String(format: "Số lượng tối đa là %.0f", quantity), duration: 2.0)
            }
        }
        
        foods[position].isChange = 1
        foods[position].quantity_change = number
        viewModel.dataArray.accept(foods)
    }
    
}
