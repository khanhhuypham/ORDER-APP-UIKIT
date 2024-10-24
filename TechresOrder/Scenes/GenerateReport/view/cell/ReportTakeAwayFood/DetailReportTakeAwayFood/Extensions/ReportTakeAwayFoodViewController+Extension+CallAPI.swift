//
//  ReportCancelFoodViewController+Extension.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 16/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import ObjectMapper
import Foundation

extension ReportTakeAwayFoodViewController {
    func getReportTakeAwayFood(){
        viewModel.getReportTakeAwayFood().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<FoodReportData>().map(JSONObject: response.data) {

                    report.reportType = viewModel.report.value.reportType
                    report.dateString = viewModel.report.value.dateString
                    viewModel.report.accept(report)
                    setupBarChart(data: viewModel.report.value.foods, barChart: bar_chart)
                    lbl_total_amout.text = report.total_amount.toString
                    root_view_empty_data.isHidden = report.foods.count > 0 ? true : false
                }
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.")
            }
        }).disposed(by: rxbag)
    }
}
