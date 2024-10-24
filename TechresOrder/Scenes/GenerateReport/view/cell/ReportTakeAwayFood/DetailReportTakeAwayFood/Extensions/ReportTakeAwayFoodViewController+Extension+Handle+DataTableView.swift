//
//  ReportTakeAwayFoodViewController+Extension+Handle+DataTableView.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 13/07/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//MARK: REGISTER CELL TABLE VIEW
extension ReportTakeAwayFoodViewController {
    
    
    func registerCellAndBindTableView(){
        registerCell()
        bindTableView()
    }
    
    private func registerCell() {
        let foodItemReportTakeAwayFoodTableViewCell = UINib(nibName: "FoodItemReportTakeAwayFoodTableViewCell", bundle: .main)
        tableView.register(foodItemReportTakeAwayFoodTableViewCell, forCellReuseIdentifier: "FoodItemReportTakeAwayFoodTableViewCell")
        tableView.rowHeight = 80
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    private func bindTableView() {
        viewModel.report.map{$0.foods}.asObservable().bind(to: tableView.rx.items(cellIdentifier: "FoodItemReportTakeAwayFoodTableViewCell", cellType: FoodItemReportTakeAwayFoodTableViewCell.self))
           {  (row, data, cell) in
               cell.index = row + 1
               cell.data = data
           }.disposed(by: rxbag)
    }
 
}


