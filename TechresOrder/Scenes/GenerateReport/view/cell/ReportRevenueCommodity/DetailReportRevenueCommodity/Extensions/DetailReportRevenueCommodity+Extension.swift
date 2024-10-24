//
//  DetailReportRevenueByFoodViewController+Extension.swift
//  SEEMT
//
//  Created by Huynh Quang Huy on 08/06/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import RxRelay
import JonAlert
import Charts

//MARK: REGISTER CELL TABLE VIEW
extension DetaiRevenueCommodityViewController {

    func registerCellAndBindTableView(){
        registerCell()
        bindTableView()
    }

    private func registerCell() {
        let reportRevenueByFoodListTableViewCell = UINib(nibName: "DetailReportRevenueCommodityListTableViewCell", bundle: .main)
        tableView.register(reportRevenueByFoodListTableViewCell, forCellReuseIdentifier: "DetailReportRevenueCommodityListTableViewCell")
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = 80
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine

    }


    private func bindTableView() {
        viewModel.report.map{$0.foods}.bind(to: tableView.rx.items(cellIdentifier: "DetailReportRevenueCommodityListTableViewCell", cellType: DetailReportRevenueCommodityListTableViewCell.self))
        {  (row, food, cell) in
            cell.index = row + 1
            cell.data = food
        }.disposed(by: rxbag)

    }
}



extension DetaiRevenueCommodityViewController {
    func setupBarChart(data:[FoodReport],barChart:BarChartView){
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.total_amount))},
            xLabel: data.map{$0.food_name}
        )
        
        bar_chart.isUserInteractionEnabled = true
        // calculate the required height for the chart based on the number of labels and their rotated height
        let labelHeight = barChart.xAxis.labelRotatedHeight // use the rotated label height
        let labelRotationAngle = CGFloat(barChart.xAxis.labelRotationAngle) * .pi / 180 // convert the rotation angle to radians
        let chartHeight = barChart.frame.origin.y + (CGFloat(barChart.xAxis.labelCount) * labelHeight * abs(cos(labelRotationAngle))) // use the rotated height and the cosine of the rotation angle
        // resize the height of the chart view
        barChart.frame.size.height = chartHeight

    }
    
  
}
