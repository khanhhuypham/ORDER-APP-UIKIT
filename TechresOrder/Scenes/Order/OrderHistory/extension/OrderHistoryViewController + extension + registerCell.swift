//
//  OrderHistoryViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/12/2023.
//

import UIKit

extension OrderHistoryViewController:UIScrollViewDelegate {
    func bindTableViewAndRegisterCell(){
        registerCell()
        bindTableViewData()
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "OrderHistoryTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "OrderHistoryTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rx.setDelegate(self).disposed(by: rxbag)
    }
    

    
    
    private func bindTableViewData() {
        viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "OrderHistoryTableViewCell", cellType: OrderHistoryTableViewCell.self))
           {  (row, data, cell) in
              
                cell.data = data

           }.disposed(by: rxbag)
       }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        var p = viewModel.pagination.value
        let tableViewContentHeight = tableView.contentSize.height
        let tableViewHeight = tableView.frame.size.height
        let scrollOffset = scrollView.contentOffset.y
        
        if scrollOffset + tableViewHeight >= tableViewContentHeight {
            
            if(!p.isGetFullData && !p.isAPICalling){
                p.page += 1
                p.isAPICalling = true
                viewModel.pagination.accept(p)
                getOrderHistory()
            }
        }
    }
}
