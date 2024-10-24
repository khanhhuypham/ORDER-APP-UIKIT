//
//  OrderHistoryDetailOfFoodAppViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/08/2024.
//

import UIKit
import ObjectMapper
import RxSwift
extension OrderHistoryDetailOfFoodAppViewController {
    
    
    
    public func getOrderHistoryDetailOfFoodApp(id:Int){
        appServiceProvider.rx.request(.getOrderHistoryDetailOfFoodApp(
            restaurant_id: Constants.restaurant_id,
            restaurant_brand_id: Constants.brand.id,
            id: id,
            is_app_food: 1
        ))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
       .subscribe(onNext: { [self](response) in
           
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let order = Mapper<FoodAppOrder>().map(JSONObject: response.data){
                   
                    self.viewModel.order.accept(order)
                    setupData(order: order)
                }

            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    public func setupData(order:FoodAppOrder){
        total_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: order.total_amount)
        lbl_order_id.text = order.channel_order_id
        lbl_display_id.text = order.display_id
        lbl_created_at.text = order.created_at
        lbl_driver_name.text = order.driver_name
        lbl_customer_name.text = order.customer_name
        lbl_customer_phone.text = order.phone
        lbl_total_estimate.text =  Utils.stringVietnameseMoneyFormatWithNumber(amount: order.order_amount)
        lbl_vat.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: 0)
        lbl_customer_discount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: order.customer_discount_amount)
        lbl_discount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: order.discount_amount)
        
       
        if order.details.count > 0{
            height_of_table.constant = 200
            for i in (0...order.details.count - 1){
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
                height_of_table.constant += CGFloat(cell?.frame.height ?? 0)
                tableView.layoutIfNeeded()
            }
            height_of_table.constant -= 200
        }else{
            height_of_table.constant = 0
        }
    }
    
    
    
}


extension OrderHistoryDetailOfFoodAppViewController {

    func bindTableViewAndRegisterCell(){
        registerCell()
        bindTableViewData()
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "OrderHistoryDetailOfFoodAppTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "OrderHistoryDetailOfFoodAppTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
    }
    
    private func bindTableViewData() {
        viewModel.order.map{$0.details}.bind(to: tableView.rx.items(
            cellIdentifier: "OrderHistoryDetailOfFoodAppTableViewCell",
            cellType: OrderHistoryDetailOfFoodAppTableViewCell.self)
        ){(row, orderDetail, cell) in
                cell.data = orderDetail
        }.disposed(by: rxbag)
    }
  
}

