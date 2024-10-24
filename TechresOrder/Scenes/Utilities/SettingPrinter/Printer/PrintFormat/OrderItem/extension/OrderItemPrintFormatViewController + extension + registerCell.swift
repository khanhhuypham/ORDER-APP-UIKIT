//
//  OrderItemPrintFormatViewController + extension + registerCellAndBindTable.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/12/2023.
//

import UIKit

extension OrderItemPrintFormatViewController {
    
    func bindTableViewAndRegisterCell(){
        registerCell()
        bindTableViewData()
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "OrderItemPrintFormatTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "OrderItemPrintFormatTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
    
    }
    
    private func bindTableViewData() {
        viewModel.printItems.bind(to: tableView.rx.items(cellIdentifier: "OrderItemPrintFormatTableViewCell", cellType: OrderItemPrintFormatTableViewCell.self)){(row, item, cell) in
            cell.viewModel = self.viewModel
            cell.data = item
        }.disposed(by: rxbag)
    }
    
    
  
}
