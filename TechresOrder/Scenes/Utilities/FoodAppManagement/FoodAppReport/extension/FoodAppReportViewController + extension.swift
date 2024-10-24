//
//  FoodAppReportViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 24/08/2024.
//

import UIKit
import ObjectMapper
import RxRelay
import Charts
extension FoodAppReportViewController {
        

    func getRevenueSumaryReportOfFoodApp(){
        viewModel.getRevenueSumaryReportOfFoodApp().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<FoodAppReport>().map(JSONObject: response.data) {
                    
                    lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue)
                    lbl_total_order.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_order)
                    
                    report.dateString = viewModel.report.value.dateString
                    report.reportType = viewModel.report.value.reportType
                    viewModel.report.accept(report)
                    tableView.reloadData()
                    
                    
                    if viewModel.report.value.list.count > 0{
                        height_of_table.constant = 500
                        for i in (0...viewModel.report.value.list.count - 1){
                            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
                            height_of_table.constant += CGFloat(cell?.frame.height ?? 0)
                            tableView.layoutIfNeeded()
                        }
                        height_of_table.constant -= 500
                    }else{
                        height_of_table.constant = 0
                    }
                }
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
        
}

extension FoodAppReportViewController:UITableViewDataSource{
    
    func registerCell() {
        let cell = UINib(nibName: "FoodAppReportTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "FoodAppReportTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.dataSource = self
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.report.value.list.count 
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodAppReportTableViewCell", for: indexPath) as! FoodAppReportTableViewCell
  
        let data = viewModel.report.value.list[indexPath.row]
        
        var dateString = ChartUtils.getXLabel(dateTime:data.report_date, reportType: self.viewModel.report.value.reportType, dataPointnth:indexPath.row)


        switch self.viewModel.report.value.reportType{
             case REPORT_TYPE_THIS_MONTH:
                  dateString = String(format: "Ngày %@", dateString)

             case REPORT_TYPE_THIS_YEAR:
                  dateString = String(format: "Tháng %@", dateString)

             default :
                  break
        }

        cell.report_date.text = dateString
        cell.data = data
        return cell

    }
    
}
