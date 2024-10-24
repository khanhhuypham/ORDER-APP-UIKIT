//
//  ReportRevenueEmployeeViewController+Extension+Handle+DataTableView.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 12/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper

extension ReportRevenueEmployeeViewController {
    func getReportRevenueEmployee(){
        viewModel.getReportEmployee().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

                if var report = Mapper<EmployeeRevenueReport>().map(JSONObject: response.data) {
                    
                    report.dateString = viewModel.report.value.dateString
                    report.reportType = viewModel.report.value.reportType
                    setupBarChart(dataChart: report.reportData)
                    viewModel.report.accept(report)
                    lbl_total_amout.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue)
                    root_view_empty_data.isHidden = report.total_revenue > 0 ? true : false
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
}

//MARK: REGISTER CELL TABLE VIEW
extension ReportRevenueEmployeeViewController{
    func registerCellAndBindTableView(){
        registerCell()
        bindTableView()
    }
    
    
   private func registerCell() {
        let employeeItemReportTableViewCell = UINib(nibName: "EmployeeItemReportTableViewCell", bundle: .main)
        tableView.register(employeeItemReportTableViewCell, forCellReuseIdentifier: "EmployeeItemReportTableViewCell")
        tableView.rowHeight = 70
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
    }

    private func bindTableView() {
        viewModel.report.map{$0.reportData}.asObservable().bind(to: tableView.rx.items(cellIdentifier: "EmployeeItemReportTableViewCell", cellType: EmployeeItemReportTableViewCell.self))
           {  (row, data, cell) in
               cell.index = row + 1
               cell.data = data
           }.disposed(by: rxbag)
    }
 
}


