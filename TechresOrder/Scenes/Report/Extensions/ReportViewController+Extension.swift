//
//  ReportViewController+Extension.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 30/01/2023.
//

import UIKit
import ObjectMapper
import Charts

extension ReportViewController {
    
    func registerCellAndBindtable(){
        registerCell()
        bindTableView()
        checkLevelShowCurrentPointOfEmployee()
    }
    
    private func registerCell(){

        let itemReportDetailTableViewCell = UINib(nibName: "ItemReportDetailTableViewCell", bundle: .main)
        tableView.register(itemReportDetailTableViewCell, forCellReuseIdentifier: "ItemReportDetailTableViewCell")
        tableView.rowHeight = 40
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    private func bindTableView() {
        viewModel.report.map{$0.revenues}.bind(to: tableView.rx.items(cellIdentifier: "ItemReportDetailTableViewCell", cellType: ItemReportDetailTableViewCell.self))
           {  (row, revenue, cell) in
               cell.lbl_total_revenue.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: revenue.total_revenue)
               cell.lbl_report_date.text = ChartUtils.getXLabel(dateTime: revenue.report_time, reportType: self.viewModel.report.value.reportType, dataPointnth: row)
           }.disposed(by: rxbag)
    }
    
   private func checkLevelShowCurrentPointOfEmployee(){
        if(ManageCacheObject.getSetting().service_restaurant_level_id < GPQT_LEVEL_ONE){
            root_view_point.isHidden = true
            height_of_root_view_point.constant = 0
        }
    }
}




extension ReportViewController {
    //MARK: revenue by time
    func reportRevenueByTime(){
        viewModel.reportRevenueByEmployee().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<RevenueReport>().map(JSONObject: response.data) {
                    report.dateString = self.viewModel.report.value.dateString
                    report.reportType = self.viewModel.report.value.reportType
                    self.viewModel.report.accept(report)
                    self.lbl_total_revenue.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue)
                    self.setupLineChart(revenuesToday: report.revenues,reportType: report.reportType,line_chart: self.line_chart_view)
                }
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }

     

    func setupLineChart(revenuesToday:[Revenue],reportType:Int,line_chart:LineChartView){
    
        lineChartItems = revenuesToday.enumerated().map{(i,value) in ChartDataEntry(x: Double(i), y: Double(value.total_revenue))}
        let x_label:[String] = revenuesToday.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)}
        ChartUtils.customLineChart(
            chartView: line_chart,
            entries: lineChartItems,
            x_label: x_label,
            labelCount: ChartUtils.setLabelCountForChart(reportType: reportType, totalDataPoint: revenuesToday.count)
        )
        // MARK: Handle click show tooltip
        // Set the extraTopOffset property to add padding
        line_chart.extraTopOffset = 30.0 // Adjust the value as per your requirement
    }
    
    
}
