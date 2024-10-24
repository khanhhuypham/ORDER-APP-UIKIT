//
//  ReportRevenueTempTodayTableViewCell.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import RxSwift
import Charts
class ReportRevenueTempTodayTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_today_total_amount_temp: UILabel!
    
    @IBOutlet weak var lbl_revenue_temp_ready_payment: UILabel!
    
    @IBOutlet weak var lbl_revenue_temp_not_payment: UILabel!
    @IBOutlet weak var btnRevenueDetail: UIButton!
    @IBOutlet weak var line_chart: LineChartView!
    var lineChartItems = [ChartDataEntry]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionShowDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.ReportRevenueTempTodayViewController()
    }
    
    
    
    
    var viewModel: GenerateReportViewModel? {
       didSet {
           guard let viewModel = self.viewModel else {return}
           viewModel.dailyOrderReport.subscribe(onNext: { [weak self] (dailyOrderReport) in
                 self?.lbl_revenue_temp_not_payment.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.revenue_serving)
                 self?.lbl_revenue_temp_ready_payment.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.revenue_paid)
                 self?.lbl_today_total_amount_temp.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: dailyOrderReport.revenue_paid + dailyOrderReport.revenue_serving)
            }).disposed(by: disposeBag)

           viewModel.toDayRenueReport.subscribe(onNext: { [weak self] (toDayRenueReport) in
                 self!.setupLineChart(revenuesToday: toDayRenueReport.revenues ?? [],reportType: toDayRenueReport.reportType,line_chart: self!.line_chart)
           }).disposed(by: disposeBag)
       }
    }

}

extension ReportRevenueTempTodayTableViewCell{
 

    func setupLineChart(revenuesToday:[Revenue],reportType:Int,line_chart:LineChartView){
        lineChartItems.removeAll()
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
