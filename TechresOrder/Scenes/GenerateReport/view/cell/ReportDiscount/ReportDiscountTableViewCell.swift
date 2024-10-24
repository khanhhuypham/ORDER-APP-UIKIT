//
//  ReportDiscountTableViewCell.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 15/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import ObjectMapper
class ReportDiscountTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var line_chart_view: LineChartView!
    @IBOutlet weak var root_view_empty_data: UIView!
    @IBOutlet weak var lbl_food_total_amount: UILabel!

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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}
        var discountReport = viewModel.discountReport.value
        discountReport.discountReportData = []
        discountReport.reportType = sender.tag
        discountReport.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.discountReport.accept(discountReport)
        viewModel.view?.getdiscountReport()
    }
    
  
    
    var viewModel: GenerateReportViewModel? = nil{
        didSet {
            guard let viewModel = self.viewModel else {return}
            btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
       
            for btn in self.btnArray{
                btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                    Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
                }).disposed(by: disposeBag)
                
                if btn.tag == viewModel.discountReport.value.reportType {
                    Utils.changeBgBtn(btn: btn, btnArray: btnArray)
                }

            }
            viewModel.discountReport.subscribe(onNext: { [self] report in
                lbl_food_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_amount)
                if report.discountReportData.count > 0{setupLineChart(dataChart: report.discountReportData,reportType: report.reportType)}
                root_view_empty_data.isHidden = report.discountReportData.count > 0 ? true : false
            }).disposed(by: disposeBag)
        }
    }
    
    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeToDetailReportDiscountViewController()
        
    }
}

//MARK: CHART HANDLER....
extension ReportDiscountTableViewCell{
    func setupLineChart(dataChart:[DiscountReportData],reportType:Int) {
        lineChartItems.removeAll()
        lineChartItems = dataChart.enumerated().map{(i,value) in ChartDataEntry(x: Double(i), y: Double(value.total_amount))}
        let x_label:[String] = dataChart.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)}
        ChartUtils.customLineChart(
            chartView: line_chart_view,
            entries: lineChartItems,
            x_label: x_label,
            labelCount: ChartUtils.setLabelCountForChart(reportType: reportType, totalDataPoint: dataChart.count)
        )
        line_chart_view.extraTopOffset = 30.0 // Adjust the value as per your requirement

    }
}

