//
//  GenerateReportViewController+Extension.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import JonAlert

extension GenerateReportViewController:SambagMonthYearPickerViewControllerDelegate{
    
    func sambagMonthYearPickerDidSet(_ viewController: SambagMonthYearPickerViewController, result: SambagMonthYearPickerResult) {
        
        var report = viewModel.revenueCostProfitReport.value
        report.dateString = result.description
        report.fromDate = result.description
        report.reportType = REPORT_TYPE_THIS_MONTH
        viewModel.revenueCostProfitReport.accept(report)
        self.getRevenueCostProfitReport()
        
        viewController.dismiss(animated: true, completion: nil)
    }

    func sambagMonthYearPickerDidCancel(_ viewController: SambagMonthYearPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func showDateTimePicker(selectedDate:String){
        let vỉewController = SambagMonthYearPickerViewController()
        var limit = SambagSelectionLimit()

        var dateNow = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        dateNow = dateFormatter.date(from: selectedDate) ?? Date()
        limit.selectedDate = dateNow

        // Set the minimum and maximum selectable dates
        let calendar = Calendar.current
        let currentDate = Date()
        let minDate = calendar.date(byAdding: .year, value: -1000, to: currentDate) // One year ago
        let maxDate = calendar.date(byAdding: .year, value: 0, to: currentDate) // One year from now
        limit.minDate = minDate
        limit.maxDate = maxDate

        vỉewController.limit = limit
        vỉewController.delegate = self
        present(vỉewController, animated: true, completion: nil)
    }
    
}
