//
//  ReportSurchargeTableViewCell.swift
//  Techres-Seemt
//
//  Created by Nguyen Thanh Vinh on 16/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import Charts
import ObjectMapper
class ReportSurchargeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var line_chart_view: LineChartView!
    @IBOutlet weak var lbl_total_amount: UILabel!
    @IBOutlet weak var root_view_empty_data: UIView!
    
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
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}
        var surchargeReport = viewModel.surchargeReport.value
        surchargeReport.surchargeReportData = []
        surchargeReport.reportType = sender.tag
        surchargeReport.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.surchargeReport.accept(surchargeReport)
        viewModel.view?.getReportSurcharge()
    }

    
    var viewModel: GenerateReportViewModel? {
        didSet {

            guard let viewModel = self.viewModel else {return}

            btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
          
            for btn in self.btnArray{
                btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                    Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
                }).disposed(by: disposeBag)
                if btn.tag == viewModel.surchargeReport.value.reportType {
                    Utils.changeBgBtn(btn: btn, btnArray: btnArray)
                }

            }
            viewModel.surchargeReport.subscribe( onNext: { [self] report in
                lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_amount)
                root_view_empty_data.isHidden =  report.surchargeReportData.count > 0 ? true : false
                if report.surchargeReportData.count > 0{setupLineChart(dataChart: report.surchargeReportData,reportType: report.reportType)}
            }).disposed(by: disposeBag)

        }
    }
    
}


extension ReportSurchargeTableViewCell {

    func setupLineChart(dataChart:[SurchargeReportData],reportType:Int) {

        lineChartItems.removeAll()

        lineChartItems = dataChart.enumerated().map{(i,value) in ChartDataEntry(x: Double(i), y: Double(value.total_amount))}
    
        var x_label:[String] = dataChart.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)}
        ChartUtils.customLineChart(
            chartView: line_chart_view,
            entries: lineChartItems,
            x_label: dataChart.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)},
            labelCount: ChartUtils.setLabelCountForChart(reportType: reportType, totalDataPoint: dataChart.count)
        )

        // MARK: Handle click show tooltip
        // Set the extraTopOffset property to add padding
        line_chart_view.extraTopOffset = 30.0
    }
}
