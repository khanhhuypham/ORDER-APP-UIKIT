//
//  ReportRevenueGeneralTableViewCell.swift
//  Techres-Seemt
//
//  Created by macmini_techres_04 on 13/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import Charts


class ReportRevenueGeneralTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_revenue_total_amount: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var root_view_empty_data: UIView!
    
    @IBOutlet weak var lbl_time: UILabel!
    // MARK: Biến của button filter
    @IBOutlet weak var btn_today: UIButton!
    @IBOutlet weak var btn_yesterday: UIButton!
    @IBOutlet weak var btn_this_month: UIButton!
    @IBOutlet weak var btn_last_month: UIButton!
    @IBOutlet weak var btn_last_three_month: UIButton!
    @IBOutlet weak var btn_this_year: UIButton!
    @IBOutlet weak var btn_last_year: UIButton!
    @IBOutlet weak var btn_last_three_year: UIButton!
    @IBOutlet weak var btn_all_year: UIButton!
    
    @IBOutlet weak var btn_this_week: UIButton!
    var chartItems = [ChartDataEntry]()
    var btnArray:[UIButton] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        
        guard let viewModel = self.viewModel else {return}
        var saleReport = viewModel.saleReport.value
        saleReport.saleReportData = []
        saleReport.reportType = sender.tag
        saleReport.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.saleReport.accept(saleReport)
        viewModel.view?.getSaleReport()
    }
    

    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeRevenueDetailViewController()
    }
    
    @IBAction func actionShowCalendar(_ sender: Any) {

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

               }
               
               viewModel.saleReport.subscribe(onNext: { [weak self] report in
                   if report.saleReportData.count > 0{
                       self?.setupBarChart(data: report.saleReportData, reportType: report.reportType)
                   }
                   self?.lbl_revenue_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue)
                   self?.root_view_empty_data.isHidden = report.saleReportData.count > 0 ? true :false
                 }).disposed(by: disposeBag)
           }
    }
}

extension ReportRevenueGeneralTableViewCell {
    
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
