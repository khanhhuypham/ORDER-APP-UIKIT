//
//  RevenueDetailViewController+Extensions.swift
//  TechresOrder
//
//  Created by Kelvin on 05/02/2023.
//

import UIKit
import ObjectMapper
import Charts

extension RevenueDetailViewController {
    
    func setupBarChart(data: [SaleReportData], reportType: Int) {
        let x_label:[String] = data.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)}
        ChartUtils.customBarChart(
            chartView: barChartView,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.total_revenue))},
            xLabel: x_label,
            isDateXLabel: true
        )
        barChartView.isUserInteractionEnabled = true
        
        let labelHeight = barChartView.xAxis.labelRotatedHeight // use the rotated label height
        let labelRotationAngle = CGFloat(barChartView.xAxis.labelRotationAngle) * .pi / 180 // convert the rotation angle to radians
        let chartHeight = barChartView.frame.origin.y + (CGFloat(barChartView.xAxis.labelCount) * labelHeight * abs(cos(labelRotationAngle)))
        // resize the height of the chart view
        barChartView.frame.size.height = chartHeight
    }
}

extension RevenueDetailViewController {
    
    //MARK: Register Cells as you want
    func registerCell(){
        let itemRevenueDetailTableViewCell = UINib(nibName: "ItemRevenueDetailTableViewCell", bundle: .main)
        tableView.register(itemRevenueDetailTableViewCell, forCellReuseIdentifier: "ItemRevenueDetailTableViewCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rx.setDelegate(self).disposed(by: rxbag)
    }
}

extension RevenueDetailViewController {
    func bindTableView() {
        viewModel.saleReport.map{$0.saleReportData}.bind(to: tableView.rx.items(cellIdentifier: "ItemRevenueDetailTableViewCell", cellType: ItemRevenueDetailTableViewCell.self))
           {  (row, revenue, cell) in
               cell.index = row + 1
               cell.lbl_total_revenue.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: revenue.total_revenue)
               cell.lbl_report_date.text = ChartUtils.getXLabel(dateTime: revenue.report_time, reportType: self.viewModel.saleReport.value.reportType, dataPointnth: row)
           }.disposed(by: rxbag)
    }
    
}

extension RevenueDetailViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension RevenueDetailViewController {
    //MARK: revenue by time
    func reportRevenueByTime(){
        viewModel.reportRevenueByTime().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<SaleReport>().map(JSONObject: response.data) {

                    report.reportType = viewModel.saleReport.value.reportType
                    report.dateString = viewModel.saleReport.value.dateString
                    viewModel.saleReport.accept(report)
                    lbl_total_revenue.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue)
                    setupBarChart(data: report.saleReportData, reportType: report.reportType)
                }
            } else {
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
}
