//
//  OrderManagementViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 25/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper

extension OrderManagementViewController:UITextFieldDelegate{
  
     func registerCell() {
        let orderManagementTableViewCell = UINib(nibName: "OrderManagementTableViewCell", bundle: .main)
        tableView.register(orderManagementTableViewCell, forCellReuseIdentifier: "OrderManagementTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UItableViewController
        
        
        
        btnShowMore = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 40)))
        btnShowMore.setTitleColor(ColorUtils.blue_brand_700(), for: .normal)
        btnShowMore.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnShowMore.setTitle("Xem thêm", for: .normal)
        btnShowMore.addTarget(self, action: #selector(showMore(_:)), for: .touchUpInside)
        btnShowMore.isHidden = true
        tableView.tableFooterView = btnShowMore

        tableView.rx.modelSelected(Order.self) .subscribe(onNext: { element in
            self.viewModel.makePayMentViewController(order: element)
        }).disposed(by: rxbag)
        
    }
    
    @objc private func refresh(_ sender: AnyObject) {
          // Code to refresh table view
        viewModel.clearDataAndCallAPI()
        refreshControl.endRefreshing()
    }
    
    @objc private func showMore(_ sender: UIButton) {
        var apiParameter = viewModel.APIParameter.value
        if(!apiParameter.isGetFullData){
            apiParameter.page += 1
            viewModel.APIParameter.accept(apiParameter)
            ordersHistory()
        }
    }
    
     func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "OrderManagementTableViewCell", cellType: OrderManagementTableViewCell.self))
           {  (row, order, cell) in
               cell.data = order
               cell.viewModel = self.viewModel           
           }.disposed(by: rxbag)
    }
    
}

extension OrderManagementViewController{
    
    public func getTotalAmountOfOrders(){
        viewModel.getTotalAmountOfOrders().subscribe(onNext: { [self](response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let dataFromServer = Mapper<OrderStatistic>().map(JSONObject: response.data) {
                
                    temp_revenue.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dataFromServer.total_amount)
                }

            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    
    public func ordersHistory(){
        viewModel.orders().subscribe(onNext: { [self](response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
          
                if let dataFromServer = Mapper<OrderResponse>().map(JSONObject: response.data) {
                   
                
                    var apiParameter = viewModel.APIParameter.value
              
                    if(dataFromServer.data.count > 0 && !apiParameter.isGetFullData){
                        var dataArray = viewModel.dataArray.value
                        dataArray.append(contentsOf: dataFromServer.data)
                        viewModel.dataArray.accept(dataArray)
                    }
                    
                    apiParameter.isGetFullData = dataFromServer.data.count < apiParameter.limit ? true: false
                    btnShowMore.isHidden = apiParameter.isGetFullData ? true : false
                    
                    
                    viewModel.APIParameter.accept(apiParameter)
                    view_nodata_order.isHidden = viewModel.dataArray.value.count > 0 ? true : false
                    total_order_number.text = String(dataFromServer.total_record!)
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
}
