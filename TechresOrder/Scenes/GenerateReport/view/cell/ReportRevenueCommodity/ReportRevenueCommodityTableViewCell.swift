//
//  ReportRevenueCommodityTableViewCell.swift
//  Techres-Seemt
//
//  Created by Nguyen Thanh Vinh on 16/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import Charts

class ReportRevenueCommodityTableViewCell: UITableViewCell {

    @IBOutlet weak var bar_chart: BarChartView!
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    @IBOutlet weak var lbl_total_original_amount: UILabel!
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
    
    @IBOutlet weak var btn_filter_value: UIButton!
    
    var filterType:[String] = ["Giá vốn","Giá bán","Số lượng"]
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

        // Configure the view for the selected state
    }
    

    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}
        var commodityReport = viewModel.commodityReport.value
        commodityReport.foods = []
        switch sender.tag{
            case REPORT_TYPE_TODAY:
                commodityReport.reportType = REPORT_TYPE_TODAY
                commodityReport.dateString = TimeUtils.getCurrentDateTime().dateTimeNow
                break
            case REPORT_TYPE_YESTERDAY:
                commodityReport.reportType = REPORT_TYPE_YESTERDAY
                commodityReport.dateString = TimeUtils.getCurrentDateTime().yesterday
                break
            case REPORT_TYPE_THIS_WEEK:
                commodityReport.reportType = REPORT_TYPE_THIS_WEEK
                commodityReport.dateString = TimeUtils.getCurrentDateTime().thisWeek
                break
            case REPORT_TYPE_THIS_MONTH:
                commodityReport.reportType = REPORT_TYPE_THIS_MONTH
                commodityReport.dateString = TimeUtils.getCurrentDateTime().thisMonth
                break
            case REPORT_TYPE_THREE_MONTHS:
                commodityReport.reportType = REPORT_TYPE_THREE_MONTHS
                commodityReport.dateString = TimeUtils.getCurrentDateTime().threeLastMonth
                break
            case REPORT_TYPE_THIS_YEAR:
                commodityReport.reportType = REPORT_TYPE_THIS_YEAR
                commodityReport.dateString = TimeUtils.getCurrentDateTime().yearCurrent
                break
            case REPORT_TYPE_LAST_YEAR:
                commodityReport.reportType = REPORT_TYPE_LAST_YEAR
                commodityReport.dateString = TimeUtils.getCurrentDateTime().lastYear
                break
            case REPORT_TYPE_THREE_YEAR:
                commodityReport.reportType = REPORT_TYPE_THREE_YEAR
                commodityReport.dateString = TimeUtils.getCurrentDateTime().threeLastYear
                break
            case REPORT_TYPE_LAST_MONTH:
                commodityReport.reportType = REPORT_TYPE_LAST_MONTH
                commodityReport.dateString = TimeUtils.getCurrentDateTime().lastMonth
                break
            case REPORT_TYPE_ALL_YEAR:
                commodityReport.reportType = REPORT_TYPE_ALL_YEAR
                commodityReport.dateString = ""
                break
            default:
                break
        }
        viewModel.commodityReport.accept(commodityReport)
        viewModel.view?.getRevenueReportCommodity()
    }
    
    
    
    var viewModel: GenerateReportViewModel? {
       didSet {
           if let viewModel = viewModel {
               
               btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
               Utils.changeBgBtn(btn: btn_this_month, btnArray: btnArray)
               for btn in self.btnArray{
                   btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                       Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
                   }).disposed(by: disposeBag)

               }
               
                            
               viewModel.commodityReport.subscribe(onNext: { [self] report in
                   lbl_total_amount.text = report.total_amount.toString
                   root_view_empty_data.isHidden = report.foods.count > 0 ? true : false
                    if report.foods.count > 0{
                        setupBarChart(data: report.foods, barChart: bar_chart)
                    }
            
                }).disposed(by: disposeBag)
           }
       }
    }
    
    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeToDetailReportRevenueCommodityViewController()
    }
}


extension ReportRevenueCommodityTableViewCell {

    func setupBarChart(data:[FoodReport],barChart:BarChartView){
        
  
        ChartUtils.customBarChart(
            chartView: bar_chart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.total_amount))},
            xLabel: data.map{String($0.food_name.count <= 15 ? $0.food_name : $0.food_name.prefix(15) + "...")}
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


