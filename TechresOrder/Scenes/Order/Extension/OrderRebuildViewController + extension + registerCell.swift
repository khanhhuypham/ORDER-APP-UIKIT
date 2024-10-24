//
//  OrderRebuildViewController + extension + registerCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/01/2024.
//

import UIKit
import JonAlert
extension OrderRebuildViewController{
    
    func registerCellAndBindTable(){
        registerCell()
        bindTableViewData()
    }
    
    
    private func registerCell() {
        let orderTableViewCell = UINib(nibName: "OrderRebuildTableViewCell", bundle: .main)
        tableView.register(orderTableViewCell, forCellReuseIdentifier: "OrderRebuildTableViewCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.rx.modelSelected(Order.self) .subscribe(onNext: { element in
            
            if(element.order_status != ORDER_STATUS_WAITING_WAITING_COMPLETE){
                self.viewModel.makeOrderDetailViewController(order: element)
            }else{
                self.showWarningMessage(content:"Đơn hàng đang chờ thu tiền bạn không được phép thao tác.")
            }
            
        }).disposed(by: rxbag)
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UItableViewController
    }
    
    @objc func refresh(_ sender: AnyObject) {
          // Code to refresh table view
           clearDataAndCallApi()
           refreshControl.endRefreshing()
    }
}
extension OrderRebuildViewController{
    private func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "OrderRebuildTableViewCell", cellType: OrderRebuildTableViewCell.self))
           {  (row, order, cell) in
               cell.viewModel = self.viewModel
               cell.data = order
        }.disposed(by: rxbag)
    }
}
