//
//  PaymentRebuildViewController + extension + registerCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/10/2023.
//

import UIKit

extension PaymentRebuildViewController {

    func bindTableViewAndRegisterCell(){
        registerCell()
        bindTableViewData()
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "PaymentRebuildTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "PaymentRebuildTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
    }
    
    private func bindTableViewData() {
        viewModel.order.map{$0.order_details}.bind(to: tableView.rx.items(cellIdentifier: "PaymentRebuildTableViewCell", cellType: PaymentRebuildTableViewCell.self))
           {  (row, orderDetail, cell) in
                cell.viewModel = self.viewModel
                cell.orderStatus = self.viewModel.order.value.status
                cell.data = orderDetail
           }.disposed(by: rxbag)
    }
  
}



