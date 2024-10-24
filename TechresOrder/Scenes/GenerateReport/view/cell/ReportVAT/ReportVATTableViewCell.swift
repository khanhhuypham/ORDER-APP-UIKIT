//
//  ReportVATTableViewCell.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 14/04/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import Charts
import ObjectMapper
class ReportVATTableViewCell: UITableViewCell {
    
    @IBOutlet weak var line_chart_view: LineChartView!
    @IBOutlet weak var root_view_empty_data: UIView!
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    // MARK: Biến của button filter
    @IBOutlet weak var btn_today: UIButton!
    @IBOutlet weak var btn_yesterday: UIButton!
    @IBOutlet weak var btn_this_week: UIButton!
    @IBOutlet weak var btn_this_month: UIButton!
    @IBOutlet weak var btn_last_month: UIButton!
    @IBOutlet weak var btn_last_three_month: UIButton!
    @IBOutlet weak var btn_this_year: UIButton!
    @IBOutlet weak var btn_last_year: UIButton!
    @IBOutlet weak var btn_last_three_year: UIButton!
    @IBOutlet weak var btn_all_year: UIButton!
    
    var lineChartItems = [ChartDataEntry]()
    var btnArray:[UIButton] = []

    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}
        var vatReport = viewModel.vatReport.value
        vatReport.vatReportData = []
        vatReport.reportType = sender.tag
        vatReport.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.vatReport.accept(vatReport)
        viewModel.view?.getVATReport()
    }
    
    
    var viewModel: GenerateReportViewModel? {
        didSet {
            guard let viewModel = self.viewModel else {return}
           
            btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
            Utils.changeBgBtn(btn: btn_this_month, btnArray: btnArray)
            for btn in self.btnArray{
                btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                    Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
                }).disposed(by: disposeBag)
                
                if btn.tag == viewModel.vatReport.value.reportType {
                    Utils.changeBgBtn(btn: btn, btnArray: btnArray)
                }

            }

            viewModel.vatReport.subscribe(onNext: { [self] report in
                lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.vat_amount)
                if report.vatReportData.count > 0{setupLineChart(dataChart: report.vatReportData,reportType: report.reportType)}
                root_view_empty_data.isHidden = report.vatReportData.count > 0 ? true : false
            }).disposed(by: disposeBag)

        }
    }
   
    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeToDetailReportVATViewController()
    }
    
    

}

extension ReportVATTableViewCell {
    func setupLineChart(dataChart:[VATReportData],reportType:Int) {

        lineChartItems.removeAll()
                
        lineChartItems = dataChart.enumerated().map{(i,value) in ChartDataEntry(x: Double(i), y: Double(value.vat_amount))}

    
        ChartUtils.customLineChart(
            chartView: line_chart_view,
            entries: lineChartItems,
            x_label: dataChart.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)},
            labelCount: ChartUtils.setLabelCountForChart(reportType: reportType, totalDataPoint: dataChart.count))
        
        // MARK: Handle click show tooltip
        // Set the extraTopOffset property to add padding
        line_chart_view.extraTopOffset = 30.0 // Adjust the value as per your requirement
    }
}
